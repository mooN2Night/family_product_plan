import 'package:equatable/equatable.dart';

class CreateCardEntity extends Equatable {
  const CreateCardEntity({required this.name, required this.number});

  final String name;
  final String number;

  @override
  List<Object?> get props => [name, number];
}
