import 'package:equatable/equatable.dart';

class Organization extends Equatable{
  final String id;
  final String name;
  final String country;


  const Organization({
    required this.id,
    required this.name,
    required this.country,
  });

  @override
  List<dynamic> get props => [
    id,
    name,
    country,
  ];

  @override
  bool get stringify => true;

  factory Organization.fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      throw StateError('missing data for work order model');
    }

    final id = data['id'] as String;
    final name = data['name'] as String;
    final country = data['country'] as String;


    return Organization(
      id: id,
      name: name,
      country: country,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'country': country,
    };
  }
}