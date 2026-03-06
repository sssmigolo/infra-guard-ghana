// MIT License - Copyright (c) 2026 InfraGuard AI Contributors
// InfraGuard AI - Data Models

import 'package:flutter/material.dart';

// ==========================================
// User / Profile Model
// ==========================================
enum UserRole {
  citizen,
  fieldTechnician,
  utilityEngineer,
  municipalOfficer,
  industrialUser,
  admin,
}

extension UserRoleExtension on UserRole {
  String get label {
    switch (this) {
      case UserRole.citizen:
        return 'Citizen';
      case UserRole.fieldTechnician:
        return 'Field Technician';
      case UserRole.utilityEngineer:
        return 'ECG / Utility Engineer';
      case UserRole.municipalOfficer:
        return 'Municipal Officer';
      case UserRole.industrialUser:
        return 'Industrial / SME';
      case UserRole.admin:
        return 'Administrator';
    }
  }

  IconData get icon {
    switch (this) {
      case UserRole.citizen:
        return Icons.person;
      case UserRole.fieldTechnician:
        return Icons.engineering;
      case UserRole.utilityEngineer:
        return Icons.electrical_services;
      case UserRole.municipalOfficer:
        return Icons.account_balance;
      case UserRole.industrialUser:
        return Icons.factory;
      case UserRole.admin:
        return Icons.admin_panel_settings;
    }
  }
}

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final UserRole role;
  final String? avatarUrl;
  final String region;
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    this.avatarUrl,
    required this.region,
    required this.createdAt,
  });
}

// ==========================================
// Outage / Electricity Models
// ==========================================
enum OutageStatus { predicted, active, resolved }

enum OutageSeverity { low, medium, high, critical }

class Outage {
  final String id;
  final String area;
  final double latitude;
  final double longitude;
  final OutageStatus status;
  final OutageSeverity severity;
  final DateTime startTime;
  final DateTime? endTime;
  final DateTime? predictedEnd;
  final int affectedCustomers;
  final String? cause;
  final double confidenceScore;

  const Outage({
    required this.id,
    required this.area,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.severity,
    required this.startTime,
    this.endTime,
    this.predictedEnd,
    required this.affectedCustomers,
    this.cause,
    required this.confidenceScore,
  });
}

class OutagePrediction {
  final String id;
  final String area;
  final double probability;
  final DateTime predictedStart;
  final Duration estimatedDuration;
  final String reason;
  final List<String> contributingFactors;
  final double confidenceScore;

  const OutagePrediction({
    required this.id,
    required this.area,
    required this.probability,
    required this.predictedStart,
    required this.estimatedDuration,
    required this.reason,
    required this.contributingFactors,
    required this.confidenceScore,
  });
}

class MaintenanceTask {
  final String id;
  final String assetId;
  final String assetType;
  final String description;
  final String location;
  final DateTime scheduledDate;
  final String priority;
  final String? assignedTo;
  final bool isCompleted;

  const MaintenanceTask({
    required this.id,
    required this.assetId,
    required this.assetType,
    required this.description,
    required this.location,
    required this.scheduledDate,
    required this.priority,
    this.assignedTo,
    this.isCompleted = false,
  });
}

// ==========================================
// Road Report Models
// ==========================================
enum RoadCondition { good, fair, poor, critical }

enum DefectType { pothole, crack, erosion, flooding, other }

class RoadReport {
  final String id;
  final double latitude;
  final double longitude;
  final String address;
  final DefectType defectType;
  final RoadCondition condition;
  final String? photoUrl;
  final double aiConfidence;
  final String? aiAnalysis;
  final double? estimatedRepairCost;
  final int? timeToFailureDays;
  final String reportedBy;
  final DateTime reportedAt;
  final String status;

  const RoadReport({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.defectType,
    required this.condition,
    this.photoUrl,
    required this.aiConfidence,
    this.aiAnalysis,
    this.estimatedRepairCost,
    this.timeToFailureDays,
    required this.reportedBy,
    required this.reportedAt,
    required this.status,
  });
}

// ==========================================
// Work Order Model
// ==========================================
enum WorkOrderType { electricity, roads, combined }

enum WorkOrderPriority { low, medium, high, critical }

class WorkOrder {
  final String id;
  final WorkOrderType type;
  final WorkOrderPriority priority;
  final String title;
  final String description;
  final String location;
  final double latitude;
  final double longitude;
  final String? assignedTeam;
  final DateTime createdAt;
  final DateTime? dueDate;
  final String status;
  final double? urgencyScore;
  final String? relatedOutageId;
  final String? relatedRoadReportId;

  const WorkOrder({
    required this.id,
    required this.type,
    required this.priority,
    required this.title,
    required this.description,
    required this.location,
    required this.latitude,
    required this.longitude,
    this.assignedTeam,
    required this.createdAt,
    this.dueDate,
    required this.status,
    this.urgencyScore,
    this.relatedOutageId,
    this.relatedRoadReportId,
  });
}

// ==========================================
// Asset Model (Grid & Road assets)
// ==========================================
class InfraAsset {
  final String id;
  final String type; // 'substation', 'transformer', 'pole', 'cable', 'road_segment'
  final String name;
  final double latitude;
  final double longitude;
  final double riskScore;
  final String condition;
  final DateTime lastInspected;
  final String? forecast7Day;

  const InfraAsset({
    required this.id,
    required this.type,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.riskScore,
    required this.condition,
    required this.lastInspected,
    this.forecast7Day,
  });
}
