import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:hitachi/api.dart';
import 'package:hitachi/models/SendWds/SendWdsModel_Output.dart';
import 'package:hitachi/models/SendWds/sendWdsModel_input.dart';

part 'line_element_event.dart';
part 'line_element_state.dart';

class LineElementBloc extends Bloc<LineElementEvent, LineElementState> {
  LineElementBloc() : super(LineElementInitial()) {
    on<LineElementEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<PostSendWindingStartEvent>(
      (event, emit) async {
        try {
          emit(PostSendWindingStartLoadingState());
          final mlist = await fetchSendWinding(event.items);
          emit(PostSendWindingStartLoadedState(mlist));
        } catch (e) {
          emit(PostSendWindingStartErrorState(e.toString()));
        }
      },
    );
  }

  Future<SendWindingStartModelInput> fetchSendWinding(
      SendWindingStartModelOutput itemOutput) async {
    print(ApiConfig.LE_SEND_WINDING_START);
    try {
      Response responese = await Dio().post(ApiConfig.LE_SEND_WINDING_START,
          options: Options(headers: ApiConfig.HEADER()),
          data: jsonEncode(itemOutput));

      SendWindingStartModelInput post =
          SendWindingStartModelInput.fromJson(responese.data);

      return post;
    } catch (e, s) {
      // throw StateError();
      print("Exception occured: $e StackTrace: $s");
      return SendWindingStartModelInput();
    }
  }
}
