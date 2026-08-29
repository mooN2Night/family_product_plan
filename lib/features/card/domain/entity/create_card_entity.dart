import 'package:equatable/equatable.dart';

class CreateCardEntity extends Equatable {
  const CreateCardEntity({
    required this.name,
    required this.number,
    required this.barcodeFormat,
    required this.code,
  });

  final String name;
  final String number;
  final String barcodeFormat;
  final String code;

  @override
  List<Object?> get props => [name, number, barcodeFormat, code];
}
