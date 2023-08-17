import 'package:equatable/equatable.dart';

class Franchise extends Equatable{
  final String id;
  final String name;
  final String organization_id;
  final String status;


  const Franchise({
    required this.id,
    required this.organization_id,
    required this.name,
    required this.status,
  });

  @override
  List<dynamic> get props => [
    id,
    organization_id,
    name,
    status,
  ];

  @override
  bool get stringify => true;

  factory Franchise.fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      throw StateError('missing data for work order model');
    }

    final id = data['id'] as String;
    final organization_id = data['organization_id'] as String;
    final name = data['name'] as String;
    final status = data['status'] as String;


    return Franchise(
      id: id,
      organization_id: organization_id,
      name: name,
      status: status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'organization_id': organization_id,
      'name': name,
      'status': status,
    };
  }
}