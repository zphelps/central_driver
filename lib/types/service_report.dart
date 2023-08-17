import 'package:equatable/equatable.dart';

class ServiceReport extends Equatable{
  final String id;
  final String? frontImage;
  final String? leftImage;
  final String? rightImage;
  final String? backImage;
  final String? initialFillImage;
  final String? finalFillImage;
  final bool? smashPerformed;
  final int? initialFill;
  final int? finalFill;
  final bool? readyToHaul;
  final int? step;

  const ServiceReport({
    required this.id,
    required this.frontImage,
    required this.leftImage,
    required this.rightImage,
    required this.backImage,
    required this.initialFillImage,
    required this.finalFillImage,
    required this.smashPerformed,
    required this.initialFill,
    required this.finalFill,
    required this.readyToHaul,
    required this.step,
  });

  @override
  List<dynamic> get props => [
    id,
    frontImage,
    leftImage,
    rightImage,
    backImage,
    initialFillImage,
    finalFillImage,
    smashPerformed,
    initialFill,
    finalFill,
    readyToHaul,
    step,
  ];

  @override
  bool get stringify => true;

  factory ServiceReport.fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      throw StateError('missing data for client model');
    }

    final id = data['id'] as String?;
    if (id == null) {
      throw StateError('missing id for client model');
    }

    final frontImage = data['front_image'] as String?;
    final leftImage = data['left_image'] as String?;
    final rightImage = data['right_image'] as String?;
    final backImage = data['back_image'] as String?;
    final initialFillImage = data['initial_fill_image'] as String?;
    final finalFillImage = data['final_fill_image'] as String?;
    final smashPerformed = data['smash_performed'] as bool?;
    final initialFill = data['initial_fill'] as int?;
    final finalFill = data['final_fill'] as int?;
    final readyToHaul = data['ready_to_haul'] as bool?;
    final step = data['step'] as int?;

    return ServiceReport(
      id: id,
      frontImage: frontImage,
      leftImage: leftImage,
      rightImage: rightImage,
      backImage: backImage,
      initialFillImage: initialFillImage,
      finalFillImage: finalFillImage,
      smashPerformed: smashPerformed ?? false,
      initialFill: initialFill,
      finalFill: finalFill,
      readyToHaul: readyToHaul ?? false,
      step: step,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'front_image': frontImage,
      'left_image': leftImage,
      'right_image': rightImage,
      'back_image': backImage,
      'initial_fill_image': initialFillImage,
      'final_fill_image': finalFillImage,
      'smash_performed': smashPerformed,
      'initial_fill': initialFill,
      'final_fill': finalFill,
      'ready_to_haul': readyToHaul,
      'step': step,
    };
  }
}