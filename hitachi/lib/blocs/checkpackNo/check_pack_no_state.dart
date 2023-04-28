part of 'check_pack_no_bloc.dart';

abstract class CheckPackNoState extends Equatable {
  const CheckPackNoState();

  @override
  List<Object> get props => [];
}

class CheckPackNoInitial extends CheckPackNoState {}

class GetCheckPackLoadingState extends CheckPackNoState {
  const GetCheckPackLoadingState();
  @override
  List<Object> get props => [];
}

class GetCheckPackLoadedState extends CheckPackNoState {
  const GetCheckPackLoadedState(this.item);
  final CheckPackNoModel item;

  @override
  List<Object> get props => [item];
}

class GetCheckPackErrorState extends CheckPackNoState {
  const GetCheckPackErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
