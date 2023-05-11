import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:hitachi/api.dart';
import 'package:hitachi/models/ResponeDefault.dart';
import 'package:hitachi/models/machineBreakdown/machinebreakdownOutputMode.dart';

part 'machine_break_down_event.dart';
part 'machine_break_down_state.dart';

class MachineBreakDownBloc
    extends Bloc<MachineBreakDownEvent, MachineBreakDownState> {
  MachineBreakDownBloc() : super(MachineBreakDownInitial()) {
    on<MachineBreakDownEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<MachineBreakDownSendEvent>(
      (event, emit) async {
        try {
          emit(PostMachineBreakdownLoadingState());
          final mlist = await fetchSendMachineBreakDown(event.items);
          emit(PostMachineBreakdownLoadedState(mlist));
        } catch (e) {
          emit(PostMachineBreakdownErrorState(e.toString()));
        }
      },
    );
  }

  Future<ResponeDefault> fetchSendMachineBreakDown(
      MachineBreakDownOutputModel item) async {
    try {
      Response responese = await Dio().post(ApiConfig.MACHINE_BREAKDOWN,
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
}
