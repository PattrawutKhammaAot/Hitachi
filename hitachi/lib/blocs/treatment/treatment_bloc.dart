import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:equatable/equatable.dart';
import 'package:hitachi/api.dart';
import 'package:hitachi/models/treatmentModel/treatmentOutputModel.dart';

import '../../models/ResponeDefault.dart';

part 'treatment_event.dart';
part 'treatment_state.dart';

class TreatmentBloc extends Bloc<TreatmentEvent, TreatmentState> {
  Dio dio = Dio();
  TreatmentBloc() : super(TreatmentInitial()) {
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
    on<TreatmentEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<TreatmentStartSendEvent>(
      (event, emit) async {
        try {
          emit(TreatmentStartSendLoadingState());
          final mlist = await fetchTreatmentSendStart(event.items);
          emit(TreatmentStartSendLoadedState(mlist));
        } catch (e) {
          emit(TreatmentStartSendErrorState(e.toString()));
        }
      },
    );
    on<TreatmentFinishSendEvent>(
      (event, emit) async {
        try {
          emit(TreatmentFinishSendLoadingState());
          final mlist = await fetchTreatmentSendFinish(event.items);
          emit(TreatmentFinishSendLoadedState(mlist));
        } catch (e) {
          emit(TreatmentFinishSendErrorState(e.toString()));
        }
      },
    );
  }
  Future<ResponeDefault> fetchTreatmentSendStart(
      TreatMentOutputModel item) async {
    try {
  
      Response responese = await dio.post(ApiConfig.TREAMTMENT_START,
          options: Options(
              headers: ApiConfig.HEADER(),
              sendTimeout: Duration(seconds: 60),
              receiveTimeout: Duration(seconds: 60)),
          data: jsonEncode(item));
    
      ResponeDefault post = ResponeDefault.fromJson(responese.data);
      return post;
    } catch (e, s) {
      print("Exception occured: $e StackTrace: $s");
      return ResponeDefault();
    }
  }

  Future<ResponeDefault> fetchTreatmentSendFinish(
      TreatMentOutputModel item) async {
    try {
      Response responese = await dio.post(ApiConfig.TREAMTMENT_FINISH,
          options: Options(
              headers: ApiConfig.HEADER(),
              sendTimeout: Duration(minutes: 60),
              receiveTimeout: Duration(minutes: 60)),
          data: jsonEncode(item));
    
      ResponeDefault post = ResponeDefault.fromJson(responese.data);
      return post;
    } catch (e, s) {
      print("Exception occured: $e StackTrace: $s");
      return ResponeDefault();
    }
  }
}
