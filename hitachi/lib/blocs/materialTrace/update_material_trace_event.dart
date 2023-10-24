part of 'update_material_trace_bloc.dart';

class UpdateMaterialTraceEvent extends Equatable {
  const UpdateMaterialTraceEvent();

  @override
  List<Object> get props => [];
}

class PostUpdateMaterialTraceEvent extends UpdateMaterialTraceEvent {
  const PostUpdateMaterialTraceEvent(this.items);
  final MaterialTraceUpdateModel items;

  @override
  List<Object> get prop => [items];
}
