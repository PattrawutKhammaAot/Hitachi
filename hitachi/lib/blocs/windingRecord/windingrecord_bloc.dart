import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:equatable/equatable.dart';
import 'package:hitachi/api.dart';
import 'package:hitachi/config.dart';
import 'package:hitachi/models-Sqlite/windingrecordModel.dart';
import 'package:hitachi/models/ResponeDefault.dart';
import 'package:hitachi/models/windingRecordModel/ResponeseWindingRecordModel.dart';
import 'package:hitachi/models/windingRecordModel/output_windingRecordModel.dart';

part 'windingrecord_event.dart';
part 'windingrecord_state.dart';

class WindingrecordBloc extends Bloc<WindingrecordEvent, WindingrecordState> {
  Dio dio = Dio();
  WindingrecordBloc() : super(WindingrecordInitial()) {
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
    on<WindingrecordEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<GetWindingRecordEvent>(
      (event, emit) async {
        try {
          emit(GetWindingRecordLoadingState());
          final mlist = await fetchGetWindingRecord(event.param!);
          emit(GetWindingRecordLoadedState(mlist));
        } catch (e) {
          emit(GetWindingRecordErrorState(e.toString()));
        }
      },
    );
    on<SendWindingRecordEvent>(
      (event, emit) async {
        try {
          emit(SendWindingRecordLoadingState());
          final mlist = await fetchSendWindingRecord(event.param!);
          emit(SendWindingRecordLoadedState(mlist));
        } catch (e) {
          emit(SendWindingRecordErrorState(e.toString()));
        }
      },
    );
  }
  Future<ResponeseWindingRecordModel> fetchGetWindingRecord(
      String batch) async {
    try {
      Response responese = await dio.get(
        ApiConfig.GET_WINDING_RECORD + batch,
        options: Options(
            headers: ApiConfig.HEADER(),
            sendTimeout: Duration(seconds: 60),
            receiveTimeout: Duration(seconds: 60)),
      );
    

      ResponeseWindingRecordModel post =
          ResponeseWindingRecordModel.fromJson(responese.data);

      return post;
    } catch (e, s) {
      print("catch Exception occured: $e StackTrace: $s");
      throw Exception();
    }
  }

  Future<ResponeDefault> fetchSendWindingRecord(
      OutputWindingRecordModel itemOutput) async {
 
    try {
      Response responese = await dio.post(
        ApiConfig.SEND_WINDING_RECORD,
        options: Options(
            headers: ApiConfig.HEADER(),
            sendTimeout: Duration(seconds: 60),
            receiveTimeout: Duration(seconds: 60)),
        data: jsonEncode(itemOutput),
      );

      ResponeDefault post = ResponeDefault.fromJson(responese.data);

      return post;
    } catch (e, s) {
      print("catch Exception occured: $e StackTrace: $s");
      throw Exception();
    }
  }
}
