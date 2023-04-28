part of 'line_element_bloc.dart';

abstract class LineElementState extends Equatable {
  const LineElementState();

  @override
  List<Object> get props => [];
}

class LineElementInitial extends LineElementState {}

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
