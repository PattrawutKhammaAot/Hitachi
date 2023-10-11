import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:equatable/equatable.dart';
import 'package:hitachi/api.dart';
import 'package:hitachi/config.dart';
import 'package:hitachi/models/combobox/comboboxModel.dart';
import 'package:hitachi/services/databaseHelper.dart';

part 'combobox_event.dart';
part 'combobox_state.dart';

class ComboboxBloc extends Bloc<ComboboxEvent, ComboboxState> {
  Dio dio = Dio();
  ComboboxBloc() : super(ComboboxInitial()) {
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
    on<ComboboxEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<ComboboxGroupEvent>(
      (event, emit) async {
        try {
          emit(ComboboxLoadingState());
          final mlist = await fetchCombobox();
          emit(ComboboxLoadedState(mlist));
        } catch (e) {
          emit(ComboboxErrorState(e.toString()));
        }
      },
    );
  }
  Future<List<ComboBoxModel>> fetchCombobox() async {
    try {
      Response responese = await dio.get(
        ApiConfig.GET_COMBOBOX,
        options: Options(
            headers: ApiConfig.HEADER(),
            sendTimeout: Duration(seconds: 3),
            receiveTimeout: Duration(seconds: 3)),
      );

      List<ComboBoxModel> comboBoxList = (responese.data['Combobox'] as List)
          .map((item) => ComboBoxModel.fromJson(item))
          .toList();

      return comboBoxList;
    } catch (e, s) {
      print(e);
      print(s);
      throw Exception();
    }
  }
}
