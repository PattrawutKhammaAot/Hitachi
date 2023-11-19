import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:equatable/equatable.dart';
import 'package:hitachi/api.dart';
import 'package:hitachi/config.dart';

import 'package:hitachi/models/combobox/comboboxModel.dart';

part 'combobox_event.dart';
part 'combobox_state.dart';

class ComboboxBloc extends Bloc<ComboboxEvent, ComboboxState> {
  Dio dio = Dio();
  ComboboxBloc() : super(ComboboxInitial()) {
    dio.httpClientAdapter = IOHttpClientAdapter(
      onHttpClientCreate: (_) {
        final HttpClient client =
            HttpClient(context: SecurityContext(withTrustedRoots: false));

        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      },
    );
    on<ComboboxEvent>((event, emit) {});
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
        BASE_API_URL + "LineElement/GetCombobox",
        options: Options(
            headers: ApiConfig.HEADER(),
            sendTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10)),
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
