part of 'combobox_bloc.dart';

class ComboboxState extends Equatable {
  const ComboboxState();

  @override
  List<Object> get props => [];
}

class ComboboxInitial extends ComboboxState {}

class ComboboxLoadingState extends ComboboxState {
  const ComboboxLoadingState();
  @override
  List<Object> get props => [];
}

class ComboboxLoadedState extends ComboboxState {
  const ComboboxLoadedState(this.item);

  final List<ComboBoxModel> item;

  @override
  List<Object> get props => [item];
}

class ComboboxErrorState extends ComboboxState {
  const ComboboxErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
