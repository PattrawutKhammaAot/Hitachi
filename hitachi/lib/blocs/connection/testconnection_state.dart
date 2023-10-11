part of 'testconnection_bloc.dart';

abstract class TestconnectionState extends Equatable {
  const TestconnectionState();

  @override
  List<Object> get props => [];
}

class TestconnectionInitial extends TestconnectionState {}

class TestconnectionLoadingState extends TestconnectionState {
  const TestconnectionLoadingState();
  @override
  List<Object> get props => [];
}

class TestconnectionLoadedState extends TestconnectionState {
  const TestconnectionLoadedState(this.item);
  final ResponeDefault item;

  @override
  List<Object> get props => [item];
}

class TestconnectionErrorState extends TestconnectionState {
  const TestconnectionErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}

class TestconnectionWRDLoadingState extends TestconnectionState {
  const TestconnectionWRDLoadingState();
  @override
  List<Object> get props => [];
}

class TestconnectionWRDLoadedState extends TestconnectionState {
  const TestconnectionWRDLoadedState(this.item);
  final ResponeDefault item;

  @override
  List<Object> get props => [item];
}

class TestconnectionWRDErrorState extends TestconnectionState {
  const TestconnectionWRDErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
