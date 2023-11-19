import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:equatable/equatable.dart';
import 'package:hitachi/api.dart';
import 'package:hitachi/blocs/machineBreakDown/machine_break_down_bloc.dart';
import 'package:hitachi/config.dart';
import 'package:hitachi/models-Sqlite/materialtraceModel.dart';
import 'package:hitachi/models/ResponeDefault.dart';
import 'package:hitachi/models/materialTraces/deleteMaterialTraceModel.dart';
import 'package:hitachi/models/materialTraces/materialTraceUpdateModel.dart';
import 'package:hitachi/services/databaseHelper.dart';

part 'update_material_trace_event.dart';
part 'update_material_trace_state.dart';

class UpdateMaterialTraceBloc
    extends Bloc<UpdateMaterialTraceEvent, UpdateMaterialTraceState> {
  Dio dio = Dio();
  UpdateMaterialTraceBloc() : super(UpdateMaterialTraceInitial()) {
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
    on<UpdateMaterialTraceEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<PostUpdateMaterialTraceEvent>(
      (event, emit) async {
        try {
          emit(UpdateMaterialTraceLoadingState());
          final mlist = await fetchMaterialTrace(event.items, event.type!);
          emit(UpdateMaterialTraceLoadedState(mlist));
        } catch (e) {
          emit(UpdateMaterialTraceErrorState(e.toString()));
        }
      },
    );
    on<DeleteMaterialTraceTraceEvent>(
      (event, emit) async {
        try {
          emit(DeleteMaterialTraceLoadingState());
          final mlist = await fetchDeleteMaterialTrace(event.items);
          emit(DeleteMaterialTraceLoadedState(mlist));
        } catch (e) {
          emit(DeleteMaterialTraceErrorState(e.toString()));
        }
      },
    );
  }
  Future<ResponeDefault> fetchMaterialTrace(
      MaterialTraceUpdateModel item, String type) async {
    print(jsonEncode(item.toJson()));
    try {
      Response responese = await dio.post(
          BASE_API_URL + "LineElement/UpdateMaterialTrace",
          options: Options(
              headers: ApiConfig.HEADER(),
              sendTimeout: Duration(seconds: 5),
              receiveTimeout: Duration(seconds: 5)),
          data: jsonEncode(item.toJson()));

      print(responese.data);
      ResponeDefault post = ResponeDefault.fromJson(responese.data);
      return post;
    } catch (e, s) {
      print("testFalse");
      print(e);
      print(s);
      throw Exception();
    }
  }

  Future<ResponeDefault> fetchDeleteMaterialTrace(
      DeleteMaterialTraceUpdateModel item) async {
    try {
      Response responese = await dio.post(
          BASE_API_URL +
              "LineElement/DeleteMaterialTrace?batch=${item.BATCH}&process=${item.PROCESS}",
          options: Options(
              headers: ApiConfig.HEADER(),
              sendTimeout: Duration(seconds: 5),
              receiveTimeout: Duration(seconds: 5)),
          data: jsonEncode(item.toJson()));

      ResponeDefault post = ResponeDefault.fromJson(responese.data);

      return post;
    } catch (e, s) {
      print(e);
      print(s);
      throw Exception();
    }
  }
}
