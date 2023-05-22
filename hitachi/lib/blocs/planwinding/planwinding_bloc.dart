import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:hitachi/api.dart';
import 'package:hitachi/models/ResponeDefault.dart';
import 'package:hitachi/models/planWinding/PlanWindingOutputModel.dart';
import 'package:hitachi/models/pmdailyModel/PMDailyOutputModel.dart';

part 'planwinding_event.dart';
part 'planwinding_state.dart';

class PlanWindingBloc extends Bloc<PlanWindingEvent, PlanWindingState> {
  PlanWindingBloc() : super(PlanWindingInitial()) {
    on<PlanWindingEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<PlanWindingSendEvent>(
      (event, emit) async {
        try {
          emit(PlanWindingLoadingState());
          final mlist = await fetchSendPlanWinding(event.items);
          emit(PlanWindingLoadedState(mlist));
        } catch (e) {
          emit(PlanWindingErrorState(e.toString()));
        }
      },
    );
  }

  Future<PlanWindingOutputModel> fetchSendPlanWinding(String number) async {
    try {
      Response response = await Dio().get(
        ApiConfig.PLAN_WINDING,
        options: Options(
            headers: ApiConfig.HEADER(),
            sendTimeout: Duration(seconds: 3),
            receiveTimeout: Duration(seconds: 3)),
      );

      PlanWindingOutputModel tmp =
          PlanWindingOutputModel.fromJson(response.data);

      return tmp;
    } catch (e) {
      print(e);
      return PlanWindingOutputModel();
    }
  }
}
