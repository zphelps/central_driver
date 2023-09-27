import 'package:central_driver/types/client.dart';
import 'package:central_driver/types/truck.dart';
import 'package:equatable/equatable.dart';

import 'client-user.dart';
import 'job.dart';
import 'location.dart';

class Service extends Equatable{
  final String id;
  final String organization_id;
  final String franchise_id;
  final Client client;
  final Location location;
  final String summary;
  final String? driver_notes;
  final Job job;
  final String status;
  final issued_on;
  final timestamp;
  final String? start_time_window;
  final String? end_time_window;
  final int duration;
  final ClientUser on_site_contact;
  final Truck truck;
  final String? invoice_id;
  final String? completed_on;
  final double? num_units_to_charge;
  final String? current_bin_id;
  final int? step;

  const Service({
    required this.id,
    required this.organization_id,
    required this.franchise_id,
    required this.client,
    required this.location,
    required this.summary,
    required this.driver_notes,
    required this.job,
    required this.status,
    required this.issued_on,
    required this.timestamp,
    required this.start_time_window,
    required this.end_time_window,
    required this.duration,
    required this.on_site_contact,
    required this.truck,
    required this.invoice_id,
    required this.completed_on,
    required this.num_units_to_charge,
    this.current_bin_id,
    this.step,
  });

  @override
  List<dynamic> get props => [
    id,
    organization_id,
    franchise_id,
    client,
    location,
    summary,
    driver_notes,
    job,
    status,
    issued_on,
    timestamp,
    start_time_window,
    end_time_window,
    duration,
    on_site_contact,
    truck,
    invoice_id,
    completed_on,
    num_units_to_charge,
    current_bin_id,
    step,
  ];

  @override
  bool get stringify => true;

  factory Service.fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      throw StateError('missing data for work order model');
    }

    final id = data['id'] as String;
    final organization_id = data['organization_id'] as String;
    final franchise_id = data['franchise_id'] as String;
    final client = Client.fromMap(data['client']);
    final location = Location.fromMap(data['location']);
    final summary = data['summary'] as String;
    final driver_notes = data['driver_notes'] as String?;
    final job = Job.fromMap(data['job']);
    final status = data['status'] as String;
    final issued_on = data['issued_on'] as String;
    final timestamp = data['timestamp'] as String;
    final start_time_window = data['start_time_window'] as String?;
    final end_time_window = data['end_time_window'] as String?;
    final duration = data['duration'] as int;
    final on_site_contact = ClientUser.fromMap(data['on_site_contact']);
    final truck = Truck.fromMap(data['truck']);
    final invoice_id = data['invoice_id'] as String?;
    final completed_on = data['completed_on'] as String?;
    final num_units_to_charge = data['num_units_to_charge']?.toDouble();
    final current_bin_id = data['current_bin_id'] as String?;
    final step = data['step'] as int?;


    return Service(
      id: id,
      organization_id: organization_id,
      franchise_id: franchise_id,
      client: client,
      location: location,
      summary: summary,
      driver_notes: driver_notes,
      job: job,
      status: status,
      issued_on: issued_on,
      timestamp: timestamp,
      start_time_window: start_time_window,
      end_time_window: end_time_window,
      duration: duration,
      on_site_contact: on_site_contact,
      truck: truck,
      invoice_id: invoice_id,
      completed_on: completed_on,
      num_units_to_charge: num_units_to_charge,
      current_bin_id: current_bin_id,
      step: step,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'organization_id': organization_id,
      'franchise_id': franchise_id,
      'client_id': client.id,
      'location': location.toMap(),
      'summary': summary,
      'driver_notes': driver_notes,
      'job_id': job.id,
      'status': status,
      'issued_on': issued_on,
      'timestamp': timestamp,
      'start_time_window': start_time_window,
      'end_time_window': end_time_window,
      'duration': duration,
      'on_site_contact_id': on_site_contact.id,
      'truck_id': truck.id,
      'invoice_id': invoice_id,
      'completed_on': completed_on,
      'num_units_to_charge': num_units_to_charge,
      'current_bin_id': current_bin_id,
      'step': step,
    };
  }
}