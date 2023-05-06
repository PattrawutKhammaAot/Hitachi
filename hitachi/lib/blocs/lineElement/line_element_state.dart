part of 'line_element_bloc.dart';

abstract class LineElementState extends Equatable {
  const LineElementState();

  @override
  List<Object> get props => [];
}

class LineElementInitial extends LineElementState {}

//Hold
class PostSendWindingStartLoadingState extends LineElementState {
  const PostSendWindingStartLoadingState();
  @override
  List<Object> get props => [];
}

class PostSendWindingStartLoadedState extends LineElementState {
  const PostSendWindingStartLoadedState(this.item);
  final SendWindingStartModelInput item;

  @override
  List<Object> get props => [item];
}

class PostSendWindingStartErrorState extends LineElementState {
  const PostSendWindingStartErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}

//ReturnWeight
class PostSendWindingStartReturnWeightLoadingState extends LineElementState {
  const PostSendWindingStartReturnWeightLoadingState();
  @override
  List<Object> get props => [];
}

class PostSendWindingStartReturnWeightLoadedState extends LineElementState {
  const PostSendWindingStartReturnWeightLoadedState(this.item);
  final sendWdsReturnWeightInputModel item;

  @override
  List<Object> get props => [item];
}

class PostSendWindingStartReturnWeightErrorState extends LineElementState {
  const PostSendWindingStartReturnWeightErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}

class PostSendWindingFinishLoadingState extends LineElementState {
  const PostSendWindingFinishLoadingState();
  @override
  List<Object> get props => [];
}
//Finish

class PostSendWindingFinishLoadedState extends LineElementState {
  const PostSendWindingFinishLoadedState(this.item);
  final SendWdsFinishInputModel item;

  @override
  List<Object> get props => [item];
}

class PostSendWindingFinishErrorState extends LineElementState {
  const PostSendWindingFinishErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
