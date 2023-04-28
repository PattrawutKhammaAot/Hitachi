import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:hitachi/api.dart';
import 'package:hitachi/models/checkPackNo_Model.dart';

part 'check_pack_no_event.dart';
part 'check_pack_no_state.dart';

class CheckPackNoBloc extends Bloc<CheckPackNoEvent, CheckPackNoState> {
  CheckPackNoBloc() : super(CheckPackNoInitial()) {
    on<CheckPackNoEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<GetCheckPackNoEvent>(
      (event, emit) async {
        try {
          emit(GetCheckPackLoadingState());
          final mlist = await fetchCheckPackNo(event.number);
          emit(GetCheckPackLoadedState(mlist));
        } catch (e) {
          emit(GetCheckPackErrorState(e.toString()));
        }
      },
    );
  }

  Future<CheckPackNoModel> fetchCheckPackNo(int number) async {
    print(ApiConfig.LE_CHECKPACK_NO);
    try {
      Response responese = await Dio().get(
          ApiConfig.LE_CHECKPACK_NO + "$number",
          options: Options(headers: ApiConfig.HEADER()));

      print(responese.data);
      CheckPackNoModel post = CheckPackNoModel.fromJson(responese.data);
      print("Model Info ${post}");
      return post;
    } catch (e, s) {
      // throw StateError("Exception occured: $e StackTrace: $s");
      print("$e" + "$s");
      return CheckPackNoModel();
    }
  }
}
