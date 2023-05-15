import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:hitachi/api.dart';
import 'package:hitachi/models/treatmentStartModel/treatmentStartOutputModel.dart';

import '../../models/ResponeDefault.dart';

part 'treatment_event.dart';
part 'treatment_state.dart';

class TreatmentBloc extends Bloc<TreatmentEvent, TreatmentState> {
  TreatmentBloc() : super(TreatmentInitial()) {
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
      TreatMentStartOutputModel item) async {
    try {
      Response responese = await Dio().post(ApiConfig.TREAMTMENT_START,
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

  Future<ResponeDefault> fetchTreatmentSendFinish(
      TreatMentStartOutputModel item) async {
    try {
      Response responese = await Dio().post(ApiConfig.TREAMTMENT_FINISH,
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
