import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:hitachi/api.dart';
import 'package:hitachi/config.dart';
import 'package:hitachi/models/ResponeDefault.dart';

part 'testconnection_event.dart';
part 'testconnection_state.dart';

class TestconnectionBloc
    extends Bloc<TestconnectionEvent, TestconnectionState> {
  TestconnectionBloc() : super(TestconnectionInitial()) {
    on<TestconnectionEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<Test_ConnectionEvent>(
      (event, emit) async {
        try {
          emit(TestconnectionLoadingState());
          final mlist = await fetchTestConnection();
          emit(TestconnectionLoadedState(mlist));
        } catch (e) {
          emit(TestconnectionErrorState(e.toString()));
        }
      },
    );
  }

  Future<bool> fetchTestConnection() async {
    try {
      Response responese = await Dio().get(
        TEMP_API_URL,
        options: Options(
            headers: ApiConfig.HEADER(),
            sendTimeout: Duration(seconds: 3),
            receiveTimeout: Duration(seconds: 3)),
      );
      if (responese.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      print("${e}${s}");
      throw Exception();
    }
  }
}
