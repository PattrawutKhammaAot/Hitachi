part of 'treatment_bloc.dart';

abstract class TreatmentEvent extends Equatable {
  const TreatmentEvent();

  @override
  List<Object> get props => [];
}

class TreatmentStartSendEvent extends TreatmentEvent {
  const TreatmentStartSendEvent(this.items);

  final TreatMentStartOutputModel items;

  @override
  List<Object> get prop => [items];
}

class TreatmentFinishSendEvent extends TreatmentEvent {
  const TreatmentFinishSendEvent(this.items);

  final TreatMentStartOutputModel items;

  @override
  List<Object> get prop => [items];
}
