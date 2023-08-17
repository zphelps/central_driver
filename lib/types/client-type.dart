import 'package:equatable/equatable.dart';

class ClientType extends Equatable{
  final String id;
  final String name;
  final String organization_id;
  final String franchise_id;


  const ClientType({
    required this.id,
    required this.name,
    required this.organization_id,
    required this.franchise_id,
  });

  @override
  List<dynamic> get props => [
    id,
    name,
    organization_id,
    franchise_id,
  ];

  @override
  bool get stringify => true;

  factory ClientType.fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      throw StateError('missing data for work order model');
    }

    final id = data['id'] as String;
    final name = data['name'] as String;
    final organization_id = data['organization_id'] as String;
    final franchise_id = data['franchise_id'] as String;

    return ClientType(
      id: id,
      organization_id: organization_id,
      franchise_id: franchise_id,
      name: name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'organization_id': organization_id,
      'franchise_id': franchise_id,
      'name': name,
    };
  }
}