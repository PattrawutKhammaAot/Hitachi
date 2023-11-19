part of 'update_material_trace_bloc.dart';

class UpdateMaterialTraceState extends Equatable {
  const UpdateMaterialTraceState();

  @override
  List<Object> get props => [];
}

class UpdateMaterialTraceInitial extends UpdateMaterialTraceState {}

class UpdateMaterialTraceLoadingState extends UpdateMaterialTraceState {
  const UpdateMaterialTraceLoadingState();
  @override
  List<Object> get props => [];
}

class UpdateMaterialTraceLoadedState extends UpdateMaterialTraceState {
  const UpdateMaterialTraceLoadedState(this.item);

  final ResponeDefault item;

  @override
  List<Object> get props => [item];
}

class UpdateMaterialTraceErrorState extends UpdateMaterialTraceState {
  const UpdateMaterialTraceErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}

class DeleteMaterialTraceLoadingState extends UpdateMaterialTraceState {
  const DeleteMaterialTraceLoadingState();
  @override
  List<Object> get props => [];
}

class DeleteMaterialTraceLoadedState extends UpdateMaterialTraceState {
  const DeleteMaterialTraceLoadedState(this.item);

  final ResponeDefault item;

  @override
  List<Object> get props => [item];
}

class DeleteMaterialTraceErrorState extends UpdateMaterialTraceState {
  const DeleteMaterialTraceErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
