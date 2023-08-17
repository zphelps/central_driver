import 'package:equatable/equatable.dart';

class Location extends Equatable{
  final String id;
  final String? client_id;
  final String name;
  final String street_address;
  final String city;
  final String state;
  final int zip;


  const Location({
    required this.id,
    required this.client_id,
    required this.name,
    required this.street_address,
    required this.city,
    required this.state,
    required this.zip,
  });

  @override
  List<dynamic> get props => [
    id,
    client_id,
    name,
    street_address,
    city,
    state,
    zip,
  ];

  @override
  bool get stringify => true;

  factory Location.fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      throw StateError('missing data for work order model');
    }

    final id = data['id'] as String;
    final client_id = data['client_id'] as String?;
    final name = data['name'] as String;
    final street_address = data['street_address'] as String;
    final city = data['city'] as String;
    final state = data['state'] as String;
    final zip = data['zip'] as int;


    return Location(
      id: id,
      client_id: client_id,
      name: name,
      street_address: street_address,
      city: city,
      state: state,
      zip: zip,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'client_id': client_id,
      'name': name,
      'street_address': street_address,
      'city': city,
      'state': state,
      'zip': zip,
    };
  }
}