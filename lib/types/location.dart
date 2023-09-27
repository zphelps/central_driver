import 'package:equatable/equatable.dart';

class Location extends Equatable{
  final String id;
  final String? client_id;
  final String name;
  final String formatted_address;


  const Location({
    required this.id,
    required this.client_id,
    required this.name,
    required this.formatted_address,
  });

  @override
  List<dynamic> get props => [
    id,
    client_id,
    name,
    formatted_address,
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
    final formatted_address = data['formatted_address'] as String;


    return Location(
      id: id,
      client_id: client_id,
      name: name,
      formatted_address: formatted_address,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'client_id': client_id,
      'name': name,
      'formatted_address': formatted_address,
    };
  }
}