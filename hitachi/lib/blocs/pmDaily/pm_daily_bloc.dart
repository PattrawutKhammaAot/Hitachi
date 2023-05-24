import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:equatable/equatable.dart';
import 'package:hitachi/api.dart';
import 'package:hitachi/models/ResponeDefault.dart';
import 'package:hitachi/models/pmdailyModel/PMDailyCheckpointOutputModel.dart';
import 'package:hitachi/models/pmdailyModel/PMDailyOutputModel.dart';
import 'package:meta/meta.dart';

part 'pm_daily_event.dart';
part 'pm_daily_state.dart';

class PmDailyBloc extends Bloc<PmDailyEvent, PmDailyState> {
  Dio dio = Dio();
  PmDailyBloc() : super(PmDailyInitial()) {
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
    on<PmDailyEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<PMDailySendEvent>(
      (event, emit) async {
        try {
          emit(PMDailyLoadingState());
          final mlist = await fetchSendPMDaily(event.items);
          emit(PMDailyLoadedState(mlist));
        } catch (e) {
          emit(PMDailyErrorState(e.toString()));
        }
      },
    );
    // on<PMDailyGetSendEvent>(
    //   (event, emit) async {
    //     try {
    //       emit(PMDailyGetLoadingState());
    //       final mlist = await fetchPMDailyStatusModel(event.items);
    //       emit(PMDailyGetLoadedState(mlist));
    //     } catch (e) {
    //       emit(PMDailyGetErrorState(e.toString()));
    //     }
    //   },
    // );
  }
  Future<ResponeDefault> fetchSendPMDaily(PMDailyOutputModel item) async {
    try {
      Response responese = await dio.post(ApiConfig.PM_DAILY,
          options: Options(
              headers: ApiConfig.HEADER(),
              sendTimeout: Duration(seconds: 3),
              receiveTimeout: Duration(seconds: 3)),
          data: jsonEncode(item));
      print(responese.data);
      ResponeDefault post = ResponeDefault.fromJson(responese.data);
      return post;
    } catch (e, s) {
      print("Exception occured: $e StackTrace: $s");
      return ResponeDefault();
    }
  }

  Future<ResponeDefault> fetchPMDailyStatusModel(
      PMDailyOutputModel item, String number) async {
    try {
      Response response = await dio.get(
        ApiConfig.LE_REPORT_ROUTE_SHEET + "$number",
        options: Options(
            headers: ApiConfig.HEADER(),
            sendTimeout: Duration(seconds: 3),
            receiveTimeout: Duration(seconds: 3)),
      );

      ResponeDefault tmp = ResponeDefault.fromJson(response.data);

      return tmp;
    } on Exception {
      throw Exception();
    }
  }
}
