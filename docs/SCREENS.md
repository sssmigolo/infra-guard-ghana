# MIT License - Copyright (c) 2026 InfraGuard AI Contributors

# InfraGuard AI – Screen & Component Descriptions

All screens follow the Ghana-themed design system: gold (#FCD116), green (#006B3F), red (#CE1126), black (#000000) with glassmorphism cards and Outfit typography.

---

## 1. Splash / Onboarding Screen
- **Purpose**: Brand introduction and onboarding
- **Elements**: Animated InfraGuard shield logo with gold gradient, Ghana flag accent strip at bottom, loading proverb in Twi/English
- **Animation**: Logo scales in with spring effect, transitions to home screen after 2s
- **Background**: Deep navy gradient (#0A0E1A → #0D1526)

## 2. Login Screen
- **Purpose**: Authentication entry point
- **Elements**: Glass card containing email/phone input (+233 prefix), password with toggle visibility, "Sign In" gold button, Google SSO button, forgot password link, Ghana flag accent strip
- **Layout**: Centered vertically with fade+slide entrance animation
- **Notes**: Support for Ghana phone numbers, biometric auth placeholder

## 3. Register Screen
- **Purpose**: Account creation with role selection
- **Elements**: Full name, email, phone (+233), password fields inside glass card. Role selector with 6 animated chips (Citizen through Admin) with icons. Region dropdown with all 16 Ghana regions.
- **Design**: Scrollable form with back navigation to Login

## 4. Home – Unified Ghana Resilience Map
- **Purpose**: Primary overview of all Ghana infrastructure
- **Elements**: Full-screen map (Google Maps placeholder with grid painter), floating search bar with voice input toggle (Twi/Ga/Ewe), layer toggle chips (Power Grid, Roads, Outage Heatmap, Flood Risk), gradient fade bottom panel with scrollable alert cards, floating camera FAB for quick reports
- **Interactions**: Tap asset → bottom sheet with AI risk score + 7-day forecast; long-press → create work order
- **Map Markers**: Color-coded dots for Accra, Kumasi, Tamale, and other cities

## 5. Electricity Dashboard (Dumsor AI)
- **Purpose**: Power grid overview and management
- **Elements**: Gradient header with bolt icon, 4 quick-stat pills (Active Outages, Predicted, Grid Uptime, Affected Users), action buttons (View Predictions, Tech Workflow), active outage cards with confidence bar, prediction cards with contributing factor tags, maintenance schedule with priority color bars
- **Data**: Live from Supabase `outages` and `outage_predictions` tables

## 6. Outage Prediction Detail
- **Purpose**: Deep-dive into AI predictions
- **Elements**: Summary card with 24h/48h/72h breakdown, detailed forecast cards per region with probability percentage badge, contributing factors bullet list, Set Alert and Create Work Order action buttons
- **AI Info**: Model version, training data source, confidence explanation

## 7. Technician Photo Workflow
- **Purpose**: Field technician equipment diagnosis
- **Elements**: Camera capture area with dashed gold border, AI analysis overlay (loading spinner → classification results), result card with Equipment/Fault/Severity/Cost fields, interactive repair checklist with numbered steps and tap-to-complete checkboxes, Share Report and Create Work Order buttons
- **AI Flow**: Photo → TFLite inference → classification in ~2s → auto-generated checklist

## 8. Roads Dashboard (CV AI)
- **Purpose**: Road condition overview and reporting
- **Elements**: Gradient header with road icon, 4 quick-stat pills (Open Reports, In Progress, Fixed This Month, Monitored km), action buttons (Report Issue, Priority List), condition overview bars (Good/Fair/Poor/Critical with percentages), road report cards with defect badges and cost estimates, climate vulnerability alert card
- **Ghana-specific**: GH₵ currency, rainfall-based predictions

## 9. Road Report Screen (Photo + AI)
- **Purpose**: Citizen/technician road issue reporting
- **Elements**: Large photo capture area, AI detection overlay (CNN analysis progress → POTHOLE DETECTED badge), results card with Defect Type, Severity, Condition, Time-to-Failure, Climate Risk, Est. Repair Cost, GPS auto-detected location card, optional description textarea, Submit Report gold button
- **Feedback**: Success snackbar with Ghana flag message

## 10. Repair Priority List
- **Purpose**: Ranked repair queue for municipal officers
- **Elements**: Numbered priority cards sorted by urgency, each with address, defect type, AI analysis, cost estimate in GH₵, and Assign Contractor button; PDF export and filter actions in app bar
- **Color Coding**: Red (<7d), Orange (<30d), Green (>30d) urgency indicators

## 11. Analytics & Reports Dashboard
- **Purpose**: KPIs and cross-module intelligence
- **Elements**: 4 metric cards (Downtime Saved, Roads Fixed, CO₂ Reduced, Reports Filed) with trend percentages, Grid Uptime trend chart (custom painter with gold gradient fill), Regional Breakdown table (5 regions × outages/roads/health score), AI Correlation Engine section with urgency-scored cross-module alerts
- **Export**: PDF report generation button

## 12. Settings & Profile
- **Purpose**: User preferences and app configuration
- **Elements**: Profile card with initials avatar and role badge, Appearance section (dark mode toggle), Voice Input language picker (Twi/Ga/Ewe/English), Offline & Data section (offline mode toggle, low-data mode, last sync info), Notifications toggle, About section (version, privacy, license), random Ghanaian proverb display, Sign Out button
- **Accessibility**: Large font toggle, high contrast option

## 13. Work Orders Screen
- **Purpose**: Cross-module work order management
- **Elements**: List of work order cards with type icons (⚡/🛣️/🔀), priority badges (Critical/High/Medium/Low), description, location with GPS, urgency score circle indicator, assigned team info, status badge
- **Key Feature**: Combined work orders linking electricity + roads issues

---

## Shared Components

| Component | Description |
|-----------|-------------|
| `GlassCard` | Frosted glass container with backdrop blur, optional colored border |
| `StatusBadge` | Compact pill with icon + label, color-coded |
| `RiskScoreIndicator` | Circular progress with percentage, color transitions at 50%/80% |
| `MetricCard` | KPI display with icon, value, title, trend percentage |
| `MapLayerToggle` | Animated chip for map layer on/off |
| `AppShell` | Bottom navigation with 5 tabs, gold active indicator |
