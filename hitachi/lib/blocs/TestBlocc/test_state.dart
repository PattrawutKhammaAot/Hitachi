part of 'test_bloc.dart';

abstract class TestState extends Equatable {
  const TestState();
  @override
  List<Object> get props => [];
}

class TestInitial extends TestState {}

class TestLoadingState extends TestState {
  const TestLoadingState();
  List<Object> get props => [];
}

class TestSuccessState extends TestState {
  const TestSuccessState();
  List<Object> get props => [];
}

class TestErrorState extends TestState {
  const TestErrorState(this.error);
  final String error;
  List<Object> get props => [error];
}
