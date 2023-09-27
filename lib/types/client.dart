import 'package:equatable/equatable.dart';

import 'client-type.dart';
import 'location.dart';
import 'organizational-user.dart';

class Client extends Equatable{
  final String id;
  final String organization_id;
  final String franchise_id;
  final String name;
  final String country;
  final String type;
  final String status;
  final OrganizationalUser? primary_contact;
  final Location? primary_location;
  final int default_monthly_charge;
  final int default_on_demand_charge;


  const Client({
    required this.id,
    required this.organization_id,
    required this.franchise_id,
    required this.name,
    required this.country,
    required this.type,
    required this.status,
    required this.primary_contact,
    required this.primary_location,
    required this.default_monthly_charge,
    required this.default_on_demand_charge,
  });

  @override
  List<dynamic> get props => [
    id,
    organization_id,
    franchise_id,
    name,
    country,
    type,
    status,
    primary_contact,
    primary_location,
    default_monthly_charge,
    default_on_demand_charge,
  ];

  @override
  bool get stringify => true;

  factory Client.fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      throw StateError('missing data for work order model');
    }

    final id = data['id'] as String;
    final organization_id = data['organization_id'] as String;
    final franchise_id = data['franchise_id'] as String;
    final name = data['name'] as String;
    final country = data['country'] as String;
    final type = data['type'];
    final status = data['status'] as String;
    final primary_contact = data['primary_contact'] != null ? OrganizationalUser.fromMap(data['primary_contact']) : null;
    final primary_location = data['primary_location'] != null ? Location.fromMap(data['primary_location']) : null;
    final default_monthly_charge = data['default_monthly_charge'] as int;
    final default_on_demand_charge = data['default_on_demand_charge'] as int;


    return Client(
      id: id,
      organization_id: organization_id,
      franchise_id: franchise_id,
      name: name,
      country: country,
      type: type,
      status: status,
      primary_contact: primary_contact,
      primary_location: primary_location,
      default_monthly_charge: default_monthly_charge,
      default_on_demand_charge: default_on_demand_charge,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'organization_id': organization_id,
      'franchise_id': franchise_id,
      'name': name,
      'country': country,
      'type_id': type,
      'status': status,
      'primary_contact_id': primary_contact?.id,
      'primary_location_id': primary_location?.id,
      'default_monthly_charge': default_monthly_charge,
      'default_on_demand_charge': default_on_demand_charge,
    };
  }
}