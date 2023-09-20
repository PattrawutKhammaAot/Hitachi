import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get_utils/get_utils.dart';

import 'package:hitachi/models/ResponeDefault.dart';
import 'package:hitachi/models/planWinding/PlanWindingOutputModel.dart';
import 'package:hitachi/models/pmdailyModel/PMDailyOutputModel.dart';

import '../../api.dart';

part 'planwinding_event.dart';
part 'planwinding_state.dart';

class PlanWindingBloc extends Bloc<PlanWindingEvent, PlanWindingState> {
  Dio dio = Dio();

  PlanWindingBloc() : super(PlanWindingInitial()) {
    dio.httpClientAdapter = IOHttpClientAdapter(
      onHttpClientCreate: (_) {
        // Don't trust any certificate just because their root cert is trusted.
        final HttpClient client =
            HttpClient(context: SecurityContext(withTrustedRoots: false));
        // You can test the intermediate / root cert here. We just ignore it.
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      },
    );
    on<PlanWindingEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<PlanWindingSendEvent>(
      (event, emit) async {
        try {
          emit(PlanWindingLoadingState());
          final mlist = await fetchSendPlanWinding();
          emit(PlanWindingLoadedState(mlist));
        } catch (e) {
          emit(PlanWindingErrorState(e.toString()));
        }
      },
    );
  }

  Future<PlanWindingOutputModel> fetchSendPlanWinding() async {
    printInfo(info: "${ApiConfig.PLAN_WINDING}");
    try {
      Response response = await dio.get(
        ApiConfig.PLAN_WINDING,
        options: Options(
            headers: ApiConfig.HEADER(),
            sendTimeout: Duration(seconds: 60),
            receiveTimeout: Duration(seconds: 60)),
      );

      PlanWindingOutputModel tmp =
          PlanWindingOutputModel.fromJson(response.data);

      return tmp;
    } catch (e) {
      print("Exception");
      print(e);
      return PlanWindingOutputModel();
    }
  }
}
