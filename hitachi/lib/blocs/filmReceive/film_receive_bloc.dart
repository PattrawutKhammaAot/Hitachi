import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:hitachi/api.dart';
import 'package:hitachi/models/ResponeDefault.dart';
import 'package:hitachi/models/filmReceiveModel/filmreceiveOutputModel.dart';

part 'film_receive_event.dart';
part 'film_receive_state.dart';

class FilmReceiveBloc extends Bloc<FilmReceiveEvent, FilmReceiveState> {
  FilmReceiveBloc() : super(FilmReceiveInitial()) {
    on<FilmReceiveEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<FilmReceiveSendEvent>(
      (event, emit) async {
        try {
          emit(FilmReceiveLoadingState());
          final mlist = await fetchSendFilmReceive(event.items);
          emit(FilmReceiveLoadedState(mlist));
        } catch (e) {
          emit(FilmReceiveErrorState(e.toString()));
        }
      },
    );
  }
  Future<ResponeDefault> fetchSendFilmReceive(
      FilmReceiveOutputModel item) async {
    try {
      Response responese = await Dio().post(ApiConfig.FILM_RECEIVE,
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
