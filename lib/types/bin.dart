import 'package:equatable/equatable.dart';

class Bin extends Equatable{
  final String id;
  final String organization_id;
  final String franchise_id;
  final String service_id;
  final String created_at;
  final String? front_image;
  final String? back_image;
  final String? left_image;
  final String? right_image;
  final String? initial_fill_image;
  final String? final_fill_image;
  final int? initial_fill_level;
  final int? final_fill_level;
  final bool? ready_for_haul;
  final int? step;


  const Bin({
    required this.id,
    required this.organization_id,
    required this.franchise_id,
    required this.created_at,
    required this.service_id,
    required this.front_image,
    required this.back_image,
    required this.left_image,
    required this.right_image,
    required this.initial_fill_image,
    required this.final_fill_image,
    required this.initial_fill_level,
    required this.final_fill_level,
    required this.ready_for_haul,
    this.step,
  });

  @override
  List<dynamic> get props => [
    id,
    organization_id,
    franchise_id,
    service_id,
    created_at,
    front_image,
    back_image,
    left_image,
    right_image,
    initial_fill_image,
    final_fill_image,
    initial_fill_level,
    final_fill_level,
    ready_for_haul,
    step,
  ];

  @override
  bool get stringify => true;

  factory Bin.fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      throw StateError('missing data for work order model');
    }

    final id = data['id'] as String;
    final organization_id = data['organization_id'] as String;
    final service_id = data['service_id'] as String;
    final created_at = data['created_at'] as String;
    final franchise_id = data['franchise_id'] as String;
    final front_image = data['front_image'] as String?;
    final back_image = data['back_image'] as String?;
    final left_image = data['left_image'] as String?;
    final right_image = data['right_image'] as String?;
    final initial_fill_image = data['initial_fill_image'] as String?;
    final final_fill_image = data['final_fill_image'] as String?;
    final initial_fill_level = data['initial_fill_level'] as int?;
    final final_fill_level = data['final_fill_level'] as int?;
    final ready_for_haul = data['ready_for_haul'] as bool?;
    final step = data['step'] as int?;

    return Bin(
      id: id,
      organization_id: organization_id,
      franchise_id: franchise_id,
      service_id: service_id,
      created_at: created_at,
      front_image: front_image,
      back_image: back_image,
      left_image: left_image,
      right_image: right_image,
      initial_fill_image: initial_fill_image,
      final_fill_image: final_fill_image,
      initial_fill_level: initial_fill_level,
      final_fill_level: final_fill_level,
      ready_for_haul: ready_for_haul,
      step: step,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'organization_id': organization_id,
      'franchise_id': franchise_id,
      'service_id': service_id,
      'created_at': created_at,
      'front_image': front_image,
      'back_image': back_image,
      'left_image': left_image,
      'right_image': right_image,
      'before_image': initial_fill_image,
      'after_image': final_fill_image,
      'initial_fill_level': initial_fill_level,
      'final_fill_level': final_fill_level,
      'ready_for_haul': ready_for_haul,
      'step': step,
    };
  }
}