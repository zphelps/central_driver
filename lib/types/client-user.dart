import 'package:equatable/equatable.dart';

class ClientUser extends Equatable{
  final String id;
  final String client_id;
  final String first_name;
  final String last_name;
  final String email;
  final int phone_number;


  const ClientUser({
    required this.id,
    required this.client_id,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.phone_number,
  });

  @override
  List<dynamic> get props => [
    id,
    client_id,
    first_name,
    last_name,
    email,
    phone_number,
  ];

  @override
  bool get stringify => true;

  factory ClientUser.fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      throw StateError('missing data for work order model');
    }

    final id = data['id'] as String;
    final client_id = data['client_id'] as String;
    final first_name = data['first_name'] as String;
    final last_name = data['last_name'] as String;
    final email = data['email'] as String;
    final phone_number = data['phone_number'] as int;


    return ClientUser(
      id: id,
      client_id: client_id,
      first_name: first_name,
      last_name: last_name,
      email: email,
      phone_number: phone_number,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'client_id': client_id,
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'phone_number': phone_number,
    };
  }
}