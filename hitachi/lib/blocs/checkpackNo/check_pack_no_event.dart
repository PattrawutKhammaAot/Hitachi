part of 'check_pack_no_bloc.dart';

abstract class CheckPackNoEvent extends Equatable {
  const CheckPackNoEvent();

  @override
  List<Object> get props => [];
}

class GetCheckPackNoEvent extends CheckPackNoEvent {
  const GetCheckPackNoEvent(this.number);

  final int number;

  @override
  List<Object> get prop => [number];
}
