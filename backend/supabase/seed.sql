-- MIT License - Copyright (c) 2026 InfraGuard AI Contributors
-- InfraGuard AI - Seed Data (Synthetic Ghana data for demo)
-- Run AFTER schema.sql

-- ============================================
-- SAMPLE ASSETS (Grid + Road infrastructure)
-- ============================================
INSERT INTO assets (id, asset_type, name, latitude, longitude, region, district, risk_score, condition, last_inspected, forecast_7day) VALUES
  ('a0000001-0000-0000-0000-000000000001', 'substation', 'Achimota Substation', 5.6150, -0.2290, 'Greater Accra', 'Accra Metropolis', 0.45, 'Good', NOW() - INTERVAL '30 days', 'Stable – no predicted incidents'),
  ('a0000001-0000-0000-0000-000000000002', 'transformer', 'Osu Transformer T-012', 5.5560, -0.1819, 'Greater Accra', 'Accra Metropolis', 0.82, 'Degraded', NOW() - INTERVAL '90 days', 'HIGH RISK – overload likely in 48hrs'),
  ('a0000001-0000-0000-0000-000000000003', 'transformer', 'Kumasi Central T-045', 6.6885, -1.6244, 'Ashanti', 'Kumasi Metropolis', 0.68, 'Fair', NOW() - INTERVAL '45 days', 'Monitor – aging components detected'),
  ('a0000001-0000-0000-0000-000000000004', 'substation', 'Tema Industrial Substation', 5.6698, -0.0166, 'Greater Accra', 'Tema Metropolis', 0.35, 'Good', NOW() - INTERVAL '15 days', 'Stable – recent maintenance completed'),
  ('a0000001-0000-0000-0000-000000000005', 'cable', 'Tema 33kV Feeder F-12', 5.6600, -0.0200, 'Greater Accra', 'Tema Metropolis', 0.55, 'Fair', NOW() - INTERVAL '60 days', 'Cable aging – monitor for faults'),
  ('a0000001-0000-0000-0000-000000000006', 'pole', 'Tamale Pole Cluster P-78', 9.4034, -0.8393, 'Northern', 'Tamale Metropolis', 0.72, 'Poor', NOW() - INTERVAL '120 days', 'Harmattan damage – inspection needed'),
  ('a0000001-0000-0000-0000-000000000007', 'road_segment', 'N1 Highway Seg. 14', 5.5913, -0.2229, 'Greater Accra', 'Accra Metropolis', 0.71, 'Poor', NOW() - INTERVAL '60 days', 'Pothole expansion expected with weekend rains'),
  ('a0000001-0000-0000-0000-000000000008', 'road_segment', 'Kumasi Ring Road Seg. 8', 6.6900, -1.6250, 'Ashanti', 'Kumasi Metropolis', 0.52, 'Fair', NOW() - INTERVAL '40 days', 'Network cracking progressing slowly'),
  ('a0000001-0000-0000-0000-000000000009', 'road_segment', 'Kaneshie-Mallam Road', 5.5500, -0.2167, 'Greater Accra', 'Accra Metropolis', 0.91, 'Critical', NOW() - INTERVAL '10 days', 'URGENT: Flooding risk to nearby power infrastructure'),
  ('a0000001-0000-0000-0000-000000000010', 'drainage', 'Odaw River Drainage D-03', 5.5700, -0.2100, 'Greater Accra', 'Accra Metropolis', 0.85, 'Poor', NOW() - INTERVAL '180 days', 'Blocked – contributing to road flooding');

-- ============================================
-- SAMPLE OUTAGES
-- ============================================
INSERT INTO outages (area, region, latitude, longitude, status, severity, start_time, predicted_end, affected_customers, cause, confidence_score, related_asset_id) VALUES
  ('Osu, Accra', 'Greater Accra', 5.5560, -0.1819, 'active', 'high', NOW() - INTERVAL '3 hours', NOW() + INTERVAL '4 hours', 12500, 'Transformer overload at Osu substation', 0.87, 'a0000001-0000-0000-0000-000000000002'),
  ('East Legon, Accra', 'Greater Accra', 5.6370, -0.1580, 'predicted', 'medium', NOW() + INTERVAL '18 hours', NULL, 8200, 'Heat wave + peak load expected', 0.72, NULL),
  ('Tema Industrial Area', 'Greater Accra', 5.6698, -0.0166, 'resolved', 'critical', NOW() - INTERVAL '29 hours', NULL, 24000, 'Cable fault on 33kV feeder', 0.95, 'a0000001-0000-0000-0000-000000000005');

-- ============================================
-- SAMPLE PREDICTIONS
-- ============================================
INSERT INTO outage_predictions (area, region, probability, predicted_start, estimated_duration_hours, reason, contributing_factors, confidence_score) VALUES
  ('Kumasi Central', 'Ashanti', 0.78, NOW() + INTERVAL '24 hours', 6, 'Historical pattern + storm forecast', ARRAY['Rainy season onset', 'Aging transformer T-045', 'Load spike from Kejetia Market'], 0.82),
  ('Tamale Metropolis', 'Northern', 0.62, NOW() + INTERVAL '48 hours', 3, 'Harmattan dust affecting insulators', ARRAY['Dust accumulation', 'Dry season stress', 'Old connectors'], 0.68),
  ('Cape Coast', 'Central', 0.55, NOW() + INTERVAL '72 hours', 2, 'Scheduled maintenance nearby', ARRAY['Planned feeder switching', 'University load'], 0.74);

-- ============================================
-- SAMPLE ROAD REPORTS
-- ============================================
INSERT INTO road_reports (latitude, longitude, address, region, district, defect_type, condition, ai_confidence, ai_analysis, estimated_repair_cost, time_to_failure_days, climate_vulnerability, status) VALUES
  (5.5913, -0.2229, 'N1 Highway, Accra-Tema Motorway', 'Greater Accra', 'Accra', 'pothole', 'poor', 0.94, 'Large pothole (60cm diameter, 15cm depth). Risk of vehicle damage. 30 days to critical failure.', 2500.00, 30, 'HIGH – rainfall accelerates', 'open'),
  (6.6885, -1.6244, 'Kumasi Ring Road, near Adum', 'Ashanti', 'Kumasi', 'crack', 'fair', 0.88, 'Network cracking detected. Moderate severity. Climate vulnerability HIGH due to rainfall.', 1200.00, 60, 'HIGH – rainfall exposure', 'in_progress'),
  (5.5500, -0.2167, 'Kaneshie-Mallam Road, Accra', 'Greater Accra', 'Accra', 'flooding', 'critical', 0.91, 'Severe waterlogging detected. Road impassable during heavy rain. URGENT: Nearby power at risk.', 15000.00, 7, 'CRITICAL – immediate action', 'open'),
  (9.4000, -0.8400, 'Tamale-Bolgatanga Highway Km 12', 'Northern', 'Tamale', 'erosion', 'poor', 0.85, 'Shoulder erosion advancing. 2m section undermined. Danger to heavy vehicles.', 8000.00, 45, 'MODERATE – dry season', 'open'),
  (5.1100, -1.2400, 'Cape Coast-Takoradi Road', 'Central', 'Cape Coast', 'pothole', 'fair', 0.79, 'Multiple small potholes in 500m stretch. Moderate traffic impact.', 3500.00, 90, 'MODERATE – coastal humidity', 'scheduled');

-- ============================================
-- SAMPLE WORK ORDERS
-- ============================================
INSERT INTO work_orders (type, priority, title, description, location, latitude, longitude, region, assigned_team, status, urgency_score, due_date) VALUES
  ('combined', 'critical', 'Kaneshie Road Flood + Power Line Risk', 'Road flooding on Kaneshie-Mallam Road will damage power line Y-23 in 48 hours. Combined urgency score: 92%', 'Kaneshie, Accra', 5.5500, -0.2167, 'Greater Accra', 'ECG Response Team + AMA Roads', 'in_progress', 0.92, NOW() + INTERVAL '1 day'),
  ('electricity', 'high', 'Osu Transformer Overhaul', 'Replace aging transformer at Osu substation. 3 outages in last month traced to this unit.', 'Osu, Accra', 5.5560, -0.1819, 'Greater Accra', 'ECG Maintenance', 'scheduled', 0.78, NOW() + INTERVAL '7 days'),
  ('roads', 'medium', 'N1 Pothole Repair', 'Large pothole on Accra-Tema Motorway near Tetteh Quarshie. Heavy traffic area.', 'Accra-Tema Motorway', 5.5913, -0.2229, 'Greater Accra', NULL, 'open', 0.65, NOW() + INTERVAL '14 days'),
  ('electricity', 'high', 'Tamale Pole Inspection', 'Harmattan-damaged poles need urgent inspection. 6 poles in cluster showing tilt.', 'Tamale', 9.4034, -0.8393, 'Northern', 'ECG Northern', 'scheduled', 0.72, NOW() + INTERVAL '5 days'),
  ('roads', 'low', 'Cape Coast Pothole Patch', 'Multiple small potholes on Cape Coast-Takoradi road. Schedule for next maintenance cycle.', 'Cape Coast', 5.1100, -1.2400, 'Central', NULL, 'open', 0.45, NOW() + INTERVAL '30 days');
