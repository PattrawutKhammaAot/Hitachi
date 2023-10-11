part of 'production_spec_bloc.dart';

class ProductionSpecState extends Equatable {
  const ProductionSpecState();

  @override
  List<Object> get props => [];
}

class ProductionSpecInitial extends ProductionSpecState {}

class GetProductionLoadingState extends ProductionSpecState {
  const GetProductionLoadingState();
  @override
  List<Object> get props => [];
}

class GetProductionLoadedState extends ProductionSpecState {
  const GetProductionLoadedState(this.item);

  final List<ProductionModel> item;

  @override
  List<Object> get props => [item];
}

class GetProductionErrorState extends ProductionSpecState {
  const GetProductionErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
