-- MIT License - Copyright (c) 2026 InfraGuard AI Contributors
-- InfraGuard AI - Supabase Database Schema
-- Run this in the Supabase SQL Editor to create all tables

-- ============================================
-- EXTENSIONS
-- ============================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";

-- ============================================
-- ENUMS
-- ============================================
CREATE TYPE user_role AS ENUM ('citizen', 'field_technician', 'utility_engineer', 'municipal_officer', 'industrial_user', 'admin');
CREATE TYPE outage_status AS ENUM ('predicted', 'active', 'resolved');
CREATE TYPE outage_severity AS ENUM ('low', 'medium', 'high', 'critical');
CREATE TYPE road_condition AS ENUM ('good', 'fair', 'poor', 'critical');
CREATE TYPE defect_type AS ENUM ('pothole', 'crack', 'erosion', 'flooding', 'other');
CREATE TYPE work_order_type AS ENUM ('electricity', 'roads', 'combined');
CREATE TYPE work_order_priority AS ENUM ('low', 'medium', 'high', 'critical');
CREATE TYPE work_order_status AS ENUM ('open', 'scheduled', 'in_progress', 'completed', 'cancelled');
CREATE TYPE asset_type AS ENUM ('substation', 'transformer', 'pole', 'cable', 'road_segment', 'drainage');

-- ============================================
-- PROFILES (extends Supabase auth.users)
-- ============================================
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name TEXT NOT NULL,
  email TEXT,
  phone TEXT,
  role user_role NOT NULL DEFAULT 'citizen',
  region TEXT NOT NULL DEFAULT 'Greater Accra',
  avatar_url TEXT,
  organization TEXT,
  is_verified BOOLEAN DEFAULT FALSE,
  preferences JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- INFRASTRUCTURE ASSETS
-- ============================================
CREATE TABLE assets (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  asset_type asset_type NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  location GEOGRAPHY(POINT, 4326),
  latitude DOUBLE PRECISION NOT NULL,
  longitude DOUBLE PRECISION NOT NULL,
  region TEXT NOT NULL,
  district TEXT,
  risk_score DOUBLE PRECISION DEFAULT 0 CHECK (risk_score >= 0 AND risk_score <= 1),
  condition TEXT DEFAULT 'Good',
  last_inspected TIMESTAMPTZ,
  forecast_7day TEXT,
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_assets_type ON assets(asset_type);
CREATE INDEX idx_assets_region ON assets(region);
CREATE INDEX idx_assets_risk ON assets(risk_score DESC);

-- ============================================
-- OUTAGES (Electricity)
-- ============================================
CREATE TABLE outages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  area TEXT NOT NULL,
  region TEXT NOT NULL,
  latitude DOUBLE PRECISION NOT NULL,
  longitude DOUBLE PRECISION NOT NULL,
  status outage_status NOT NULL DEFAULT 'active',
  severity outage_severity NOT NULL DEFAULT 'medium',
  start_time TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  end_time TIMESTAMPTZ,
  predicted_end TIMESTAMPTZ,
  affected_customers INTEGER DEFAULT 0,
  cause TEXT,
  confidence_score DOUBLE PRECISION DEFAULT 0,
  related_asset_id UUID REFERENCES assets(id),
  reported_by UUID REFERENCES profiles(id),
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_outages_status ON outages(status);
CREATE INDEX idx_outages_region ON outages(region);
CREATE INDEX idx_outages_severity ON outages(severity);

-- ============================================
-- OUTAGE PREDICTIONS (AI-generated)
-- ============================================
CREATE TABLE outage_predictions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  area TEXT NOT NULL,
  region TEXT NOT NULL,
  probability DOUBLE PRECISION NOT NULL CHECK (probability >= 0 AND probability <= 1),
  predicted_start TIMESTAMPTZ NOT NULL,
  estimated_duration_hours INTEGER DEFAULT 1,
  reason TEXT,
  contributing_factors TEXT[] DEFAULT '{}',
  confidence_score DOUBLE PRECISION DEFAULT 0,
  model_version TEXT DEFAULT 'v1.0',
  weather_data JSONB DEFAULT '{}',
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_predictions_active ON outage_predictions(is_active, predicted_start);

-- ============================================
-- ROAD REPORTS
-- ============================================
CREATE TABLE road_reports (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  latitude DOUBLE PRECISION NOT NULL,
  longitude DOUBLE PRECISION NOT NULL,
  location GEOGRAPHY(POINT, 4326),
  address TEXT,
  region TEXT NOT NULL,
  district TEXT,
  defect_type defect_type NOT NULL,
  condition road_condition NOT NULL DEFAULT 'fair',
  photo_url TEXT,
  photo_urls TEXT[] DEFAULT '{}',
  ai_confidence DOUBLE PRECISION DEFAULT 0,
  ai_analysis TEXT,
  ai_model_version TEXT DEFAULT 'v1.0',
  estimated_repair_cost DOUBLE PRECISION,
  time_to_failure_days INTEGER,
  climate_vulnerability TEXT,
  reported_by UUID REFERENCES profiles(id),
  status TEXT DEFAULT 'open',
  description TEXT,
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_road_reports_region ON road_reports(region);
CREATE INDEX idx_road_reports_condition ON road_reports(condition);
CREATE INDEX idx_road_reports_status ON road_reports(status);

-- ============================================
-- WORK ORDERS
-- ============================================
CREATE TABLE work_orders (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  type work_order_type NOT NULL,
  priority work_order_priority NOT NULL DEFAULT 'medium',
  title TEXT NOT NULL,
  description TEXT,
  location TEXT NOT NULL,
  latitude DOUBLE PRECISION NOT NULL,
  longitude DOUBLE PRECISION NOT NULL,
  region TEXT NOT NULL,
  assigned_team TEXT,
  assigned_to UUID REFERENCES profiles(id),
  due_date TIMESTAMPTZ,
  status work_order_status NOT NULL DEFAULT 'open',
  urgency_score DOUBLE PRECISION CHECK (urgency_score >= 0 AND urgency_score <= 1),
  related_outage_id UUID REFERENCES outages(id),
  related_road_report_id UUID REFERENCES road_reports(id),
  cost_estimate DOUBLE PRECISION,
  completion_notes TEXT,
  metadata JSONB DEFAULT '{}',
  created_by UUID REFERENCES profiles(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_work_orders_status ON work_orders(status);
CREATE INDEX idx_work_orders_priority ON work_orders(priority);
CREATE INDEX idx_work_orders_type ON work_orders(type);

-- ============================================
-- MAINTENANCE TASKS
-- ============================================
CREATE TABLE maintenance_tasks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  asset_id UUID REFERENCES assets(id) NOT NULL,
  description TEXT NOT NULL,
  scheduled_date TIMESTAMPTZ NOT NULL,
  priority work_order_priority DEFAULT 'medium',
  assigned_to UUID REFERENCES profiles(id),
  is_completed BOOLEAN DEFAULT FALSE,
  completed_at TIMESTAMPTZ,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- NOTIFICATIONS
-- ============================================
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES profiles(id) NOT NULL,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  type TEXT DEFAULT 'info',
  is_read BOOLEAN DEFAULT FALSE,
  data JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_notifications_user ON notifications(user_id, is_read);

-- ============================================
-- AUDIT LOG (Ghana DPA compliance)
-- ============================================
CREATE TABLE audit_log (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES profiles(id),
  action TEXT NOT NULL,
  resource_type TEXT NOT NULL,
  resource_id UUID,
  details JSONB DEFAULT '{}',
  ip_address INET,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_audit_log_user ON audit_log(user_id, created_at DESC);

-- ============================================
-- ROW-LEVEL SECURITY POLICIES
-- ============================================

-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE assets ENABLE ROW LEVEL SECURITY;
ALTER TABLE outages ENABLE ROW LEVEL SECURITY;
ALTER TABLE outage_predictions ENABLE ROW LEVEL SECURITY;
ALTER TABLE road_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE work_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE maintenance_tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_log ENABLE ROW LEVEL SECURITY;

-- Profiles: users can read all profiles, update own
CREATE POLICY "Profiles viewable by all authenticated" ON profiles FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Users can insert own profile" ON profiles FOR INSERT WITH CHECK (auth.uid() = id);

-- Assets: viewable by all, editable by engineers/admin
CREATE POLICY "Assets viewable by all" ON assets FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Assets editable by engineers" ON assets FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('utility_engineer', 'municipal_officer', 'admin'))
);

-- Outages: viewable by all, manageable by engineers/admin
CREATE POLICY "Outages viewable by all" ON outages FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Outages manageable by engineers" ON outages FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('utility_engineer', 'admin'))
);

-- Predictions: viewable by all
CREATE POLICY "Predictions viewable by all" ON outage_predictions FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Predictions manageable by engineers" ON outage_predictions FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('utility_engineer', 'admin'))
);

-- Road Reports: citizens can create, all can view
CREATE POLICY "Road reports viewable by all" ON road_reports FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Citizens can create reports" ON road_reports FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Own reports updatable" ON road_reports FOR UPDATE USING (auth.uid() = reported_by);
CREATE POLICY "Officers can update reports" ON road_reports FOR UPDATE USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('municipal_officer', 'field_technician', 'admin'))
);

-- Work Orders: role-based access
CREATE POLICY "Work orders viewable by staff" ON work_orders FOR SELECT USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('field_technician', 'utility_engineer', 'municipal_officer', 'admin'))
);
CREATE POLICY "Work orders creatable by staff" ON work_orders FOR INSERT WITH CHECK (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('utility_engineer', 'municipal_officer', 'admin'))
);
CREATE POLICY "Work orders updatable by assigned" ON work_orders FOR UPDATE USING (
  auth.uid() = assigned_to OR auth.uid() = created_by OR
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
);

-- Notifications: users see only their own
CREATE POLICY "Users see own notifications" ON notifications FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "System can create notifications" ON notifications FOR INSERT WITH CHECK (TRUE);

-- Audit log: admin only
CREATE POLICY "Audit log admin only" ON audit_log FOR SELECT USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
);
CREATE POLICY "Audit log insertable" ON audit_log FOR INSERT WITH CHECK (TRUE);

-- Maintenance: engineers and admin
CREATE POLICY "Maintenance viewable by staff" ON maintenance_tasks FOR SELECT USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('field_technician', 'utility_engineer', 'admin'))
);
CREATE POLICY "Maintenance manageable by engineers" ON maintenance_tasks FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('utility_engineer', 'admin'))
);

-- ============================================
-- FUNCTIONS
-- ============================================

-- Auto-update updated_at
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_profiles_updated_at BEFORE UPDATE ON profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER tr_assets_updated_at BEFORE UPDATE ON assets FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER tr_outages_updated_at BEFORE UPDATE ON outages FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER tr_road_reports_updated_at BEFORE UPDATE ON road_reports FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER tr_work_orders_updated_at BEFORE UPDATE ON work_orders FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Auto-create profile on signup
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO profiles (id, full_name, email, phone)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'full_name', 'New User'),
    NEW.email,
    NEW.phone
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();
