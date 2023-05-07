part of 'line_element_bloc.dart';

abstract class LineElementEvent extends Equatable {
  const LineElementEvent();

  @override
  List<Object> get props => [];
}

class PostSendWindingStartEvent extends LineElementEvent {
  const PostSendWindingStartEvent(this.items);

  final SendWindingStartModelOutput items;

  @override
  List<Object> get prop => [items];
}

class PostSendWindingStartReturnWeightEvent extends LineElementEvent {
  const PostSendWindingStartReturnWeightEvent(this.items);

  final sendWdsReturnWeightOutputModel items;

  @override
  List<Object> get prop => [items];
}

class PostSendWindingFinishEvent extends LineElementEvent {
  const PostSendWindingFinishEvent(this.items);

  final SendWdsFinishOutputModel items;

  @override
  List<Object> get prop => [items];
}

///////////////////////-----Report Route Sheet Event-----//////////////////////////////
class ReportRouteSheetEvenet extends LineElementEvent {
  const ReportRouteSheetEvenet(this.items);

  final String items;

  @override
  List<Object> get prop => [items];
}
