import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:equatable/equatable.dart';
import 'package:hitachi/api.dart';
import 'package:hitachi/blocs/machineBreakDown/machine_break_down_bloc.dart';
import 'package:hitachi/models-Sqlite/materialtraceModel.dart';
import 'package:hitachi/models/ResponeDefault.dart';
import 'package:hitachi/models/materialTraces/materialTraceUpdateModel.dart';

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
          final mlist = await fetchMaterialTrace(event.items);
          emit(UpdateMaterialTraceLoadedState(mlist));
        } catch (e) {
          emit(UpdateMaterialTraceErrorState(e.toString()));
        }
      },
    );
  }
  Future<ResponeDefault> fetchMaterialTrace(
      MaterialTraceUpdateModel item) async {
    print(item.toJson());
    try {
      Response responese = await dio.post(ApiConfig.UPDATE_MATERIAL_TRACE,
          options: Options(
              headers: ApiConfig.HEADER(),
              sendTimeout: Duration(seconds: 3),
              receiveTimeout: Duration(seconds: 3)),
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
