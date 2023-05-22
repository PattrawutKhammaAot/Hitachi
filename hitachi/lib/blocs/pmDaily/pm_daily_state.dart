part of 'pm_daily_bloc.dart';

@immutable
abstract class PmDailyState {
  const PmDailyState();

  @override
  List<Object> get props => [];
}

class PmDailyInitial extends PmDailyState {}

class PMDailyLoadingState extends PmDailyState {
  const PMDailyLoadingState();
  @override
  List<Object> get props => [];
}

class PMDailyLoadedState extends PmDailyState {
  const PMDailyLoadedState(this.item);
  final ResponeDefault item;

  @override
  List<Object> get props => [item];
}

class PMDailyErrorState extends PmDailyState {
  const PMDailyErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
