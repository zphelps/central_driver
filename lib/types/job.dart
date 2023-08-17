import 'package:equatable/equatable.dart';

import 'client-user.dart';
import 'client.dart';
import 'location.dart';

class Job extends Equatable{
  final String id;
  final String organization_id;
  final String franchise_id;
  final Location? location;
  final ClientUser? on_site_contact;
  final String driver_notes;
  final String summary;
  final String status;
  final String created_at;
  final String updated_on;
  final String? origin;
  final String service_type;
  final Client? client;
  final String? timestamp;
  final String? start_time_window;
  final String? end_time_window;
  final int duration;
  final int? services_per_week;
  final List<dynamic>? days_of_week;
  final int? charge_per_unit;
  final String? charge_unit;

  const Job({
    required this.id,
    required this.organization_id,
    required this.franchise_id,
    required this.location,
    required this.on_site_contact,
    required this.driver_notes,
    required this.summary,
    required this.status,
    required this.created_at,
    required this.updated_on,
    required this.origin,
    required this.service_type,
    required this.client,
    required this.timestamp,
    required this.start_time_window,
    required this.end_time_window,
    required this.duration,
    required this.services_per_week,
    required this.days_of_week,
    required this.charge_per_unit,
    required this.charge_unit,
  });

  @override
  List<dynamic> get props => [
    id,
    organization_id,
    franchise_id,
    location,
    on_site_contact,
    driver_notes,
    summary,
    status,
    created_at,
    updated_on,
    origin,
    service_type,
    client,
    timestamp,
    start_time_window,
    end_time_window,
    duration,
    services_per_week,
    days_of_week,
    charge_per_unit,
    charge_unit,
  ];

  @override
  bool get stringify => true;

  factory Job.fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      throw StateError('missing data for work order model');
    }

    final id = data['id'] as String;
    final organization_id = data['organization_id'] as String;
    final franchise_id = data['franchise_id'] as String;
    final location = data['location'] != null ? Location.fromMap(data['location']) : null;
    final on_site_contact = data['on_site_contact'] != null ? ClientUser.fromMap(data['on_site_contact']) : null;
    final driver_notes = data['driver_notes'] as String;
    final summary = data['summary'] as String;
    final status = data['status'] as String;
    final created_at = data['created_at'] as String;
    final updated_at = data['updated_on'] as String;
    final origin = data['origin'] as String?;
    final service_type = data['service_type'] as String;
    final client = data['client'] != null ? Client.fromMap(data['client']) : null;
    final timestamp = data['timestamp'] as String?;
    final start_time_window = data['start_time_window'] as String?;
    final end_time_window = data['end_time_window'] as String?;
    final duration = data['duration'] as int;
    final services_per_week = data['services_per_week'] as int?;
    final days_of_week = data['days_of_week'] as List<dynamic>?;
    final charge_per_unit = data['charge_per_unit'] as int?;
    final charge_unit = data['charge_unit'] as String?;


    return Job(
      id: id,
      organization_id: organization_id,
      franchise_id: franchise_id,
      location: location,
      on_site_contact: on_site_contact,
      driver_notes: driver_notes,
      summary: summary,
      status: status,
      created_at: created_at,
      updated_on: updated_at,
      origin: origin,
      service_type: service_type,
      client: client,
      timestamp: timestamp,
      start_time_window: start_time_window,
      end_time_window: end_time_window,
      duration: duration,
      services_per_week: services_per_week,
      days_of_week: days_of_week,
      charge_per_unit: charge_per_unit,
      charge_unit: charge_unit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'organization_id': organization_id,
      'franchise_id': franchise_id,
      'location_id': location?.id,
      'on_site_contact_id': on_site_contact?.id,
      'driver_notes': driver_notes,
      'summary': summary,
      'status': status,
      'created_at': created_at,
      'updated_at': updated_on,
      'origin': origin,
      'service_type': service_type,
      'client_id': client?.id,
      'timestamp': timestamp,
      'start_time_window': start_time_window,
      'end_time_window': end_time_window,
      'duration': duration,
      'services_per_week': services_per_week,
      'days_of_week': days_of_week,
      'charge_per_unit': charge_per_unit,
      'charge_unit': charge_unit,
    };
  }
}