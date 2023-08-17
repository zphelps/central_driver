import 'package:equatable/equatable.dart';

import 'franchise.dart';
import 'organization.dart';

class OrganizationalUser extends Equatable{
  final String id;
  final String first_name;
  final String last_name;
  final String email;
  final int phone_number;
  final Franchise? franchise;
  final Organization? organization;
  final String? avatar_url;
  final String? current_service_id;


  const OrganizationalUser({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.phone_number,
    required this.franchise,
    required this.organization,
    required this.avatar_url,
    required this.current_service_id,
  });

  @override
  List<dynamic> get props => [
    id,
    first_name,
    last_name,
    email,
    phone_number,
    franchise,
    organization,
    avatar_url,
    current_service_id,
  ];

  @override
  bool get stringify => true;

  factory OrganizationalUser.fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      throw StateError('missing data for work order model');
    }

    final id = data['id'] as String;
    final first_name = data['first_name'] as String;
    final last_name = data['last_name'] as String;
    final email = data['email'] as String;
    final phone = data['phone_number'] as int;
    final franchise = data['franchise'] != null ? Franchise.fromMap(data['franchise']) : null;
    final organization = data['organization'] != null ? Organization.fromMap(data['organization']) : null;
    final avatar_url = data['avatar_url'] as String?;
    final current_service_id = data['current_service_id'] as String?;


    return OrganizationalUser(
      id: id,
      first_name: first_name,
      last_name: last_name,
      email: email,
      phone_number: phone,
      franchise: franchise,
      organization: organization,
      avatar_url: avatar_url,
      current_service_id: current_service_id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'phone': phone_number,
      'franchise_id': franchise?.id,
      'organization_id': organization?.id,
      'avatar_url': avatar_url,
      'current_service_id': current_service_id,
    };
  }
}