part of 'family_bloc.dart';

/// Базовое состояние.
final class FamilyState extends Equatable {
  const FamilyState({
    this.isLoading = false,
    this.error,
    this.isCreated = false,
  });

  final bool isLoading;

  final String? error;

  final bool isCreated;


  FamilyState copyWith({
    bool? isLoading,
    String? error,
    bool? isCreated,
  }) {
    return FamilyState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isCreated: isCreated ?? this.isCreated,
    );
  }


  @override
  List<Object?> get props => [
    isLoading,
    error,
    isCreated,
  ];
}
