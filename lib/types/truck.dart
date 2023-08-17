import 'package:equatable/equatable.dart';

import 'organizational-user.dart';

class Truck extends Equatable{
  final String id;
  final String organization_id;
  final String franchise_id;
  final String name;
  final OrganizationalUser driver;
  final double latitude;
  final double longitude;

  const Truck({
    required this.id,
    required this.organization_id,
    required this.franchise_id,
    required this.name,
    required this.driver,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<dynamic> get props => [
    id,
    organization_id,
    franchise_id,
    name,
    driver,
    latitude,
    longitude,
  ];

  @override
  bool get stringify => true;

  factory Truck.fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      throw StateError('missing data for work order model');
    }

    final id = data['id'] as String;
    final organization_id = data['organization_id'] as String;
    final franchise_id = data['franchise_id'] as String;
    final name = data['name'] as String;
    final driver = OrganizationalUser.fromMap(data['driver']);
    final latitude = data['latitude'] as double;
    final longitude = data['longitude'] as double;


    return Truck(
      id: id,
      organization_id: organization_id,
      franchise_id: franchise_id,
      name: name,
      driver: driver,
      latitude: latitude,
      longitude: longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'organization_id': organization_id,
      'franchise_id': franchise_id,
      'name': name,
      'driver': driver,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}