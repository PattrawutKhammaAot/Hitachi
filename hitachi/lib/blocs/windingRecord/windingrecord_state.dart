part of 'windingrecord_bloc.dart';

class WindingrecordState extends Equatable {
  const WindingrecordState();

  @override
  List<Object> get props => [];
}

class WindingrecordInitial extends WindingrecordState {}

class GetWindingRecordLoadingState extends WindingrecordState {
  const GetWindingRecordLoadingState();
  @override
  List<Object> get props => [];
}

class GetWindingRecordLoadedState extends WindingrecordState {
  const GetWindingRecordLoadedState(this.item);
  final ResponeseWindingRecordModel item;

  @override
  List<Object> get props => [item];
}

class GetWindingRecordErrorState extends WindingrecordState {
  const GetWindingRecordErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}

class SendWindingRecordLoadingState extends WindingrecordState {
  const SendWindingRecordLoadingState();
  @override
  List<Object> get props => [];
}

class SendWindingRecordLoadedState extends WindingrecordState {
  const SendWindingRecordLoadedState(this.item);
  final ResponeDefault item;

  @override
  List<Object> get props => [item];
}

class SendWindingRecordErrorState extends WindingrecordState {
  const SendWindingRecordErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
