part of 'windingrecord_bloc.dart';

class WindingrecordEvent extends Equatable {
  const WindingrecordEvent();

  @override
  List<Object> get props => [];
}

class GetWindingRecordEvent extends WindingrecordEvent {
  const GetWindingRecordEvent(this.param);
  final String? param;
  @override
  List<Object> get props => [param!];
}

class SendWindingRecordEvent extends WindingrecordEvent {
  const SendWindingRecordEvent(this.param);
  final OutputWindingRecordModel? param;
  @override
  List<Object> get props => [param!];
}
