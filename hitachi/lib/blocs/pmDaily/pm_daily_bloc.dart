import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:hitachi/api.dart';
import 'package:hitachi/models/ResponeDefault.dart';
import 'package:hitachi/models/pmdailyModel/PMDailyOutputModel.dart';
import 'package:meta/meta.dart';

part 'pm_daily_event.dart';
part 'pm_daily_state.dart';

class PmDailyBloc extends Bloc<PmDailyEvent, PmDailyState> {
  PmDailyBloc() : super(PmDailyInitial()) {
    on<PmDailyEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<PMDailySendEvent>(
      (event, emit) async {
        try {
          emit(PMDailyLoadingState());
          final mlist = await fetchSendPMDaily(event.items);
          emit(PMDailyLoadedState(mlist));
        } catch (e) {
          emit(PMDailyErrorState(e.toString()));
        }
      },
    );
  }
  Future<ResponeDefault> fetchSendPMDaily(PMDailyOutputModel item) async {
    try {
      Response responese = await Dio().post(ApiConfig.PM_DAILY,
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

// import 'dart:convert';
//
// import 'package:bloc/bloc.dart';
// import 'package:dio/dio.dart';
// import 'package:equatable/equatable.dart';
// import 'package:hitachi/api.dart';
// import 'package:hitachi/models/ResponeDefault.dart';
// import 'package:hitachi/models/pmdailyModel/PMDailyOutputModel.dart';
//
// part 'pm_daily_event.dart';
// part 'pm_daily_state.dart';
//
// class PMDailyBloc extends Bloc<PMDailyEvent, PMDailyState> {
//   PMDailyBloc() : super(PMDailyInitial()) {
//     on<PMDailyEvent>((event, emit) {
//       // TODO: implement event handler
//     });
//     on<PMDailySendEvent>(
//           (event, emit) async {
//         try {
//           emit(PMDailyLoadingState());
//           final mlist = await fetchSendPMDaily(event.items);
//           emit(PMDailyLoadedState(mlist));
//         } catch (e) {
//           emit(PMDailyErrorState(e.toString()));
//         }
//       },
//     );
//   }
//   Future<ResponeDefault> fetchSendPMDaily(PMDailyOutputModel item) async {
//     try {
//       Response responese = await Dio().post(ApiConfig.PM_DAILY,
//           options: Options(
//               headers: ApiConfig.HEADER(),
//               sendTimeout: Duration(seconds: 3),
//               receiveTimeout: Duration(seconds: 3)),
//           data: jsonEncode(item));
//       print(responese.data);
//       ResponeDefault post = ResponeDefault.fromJson(responese.data);
//       return post;
//     } catch (e, s) {
//       print("Exception occured: $e StackTrace: $s");
//       return ResponeDefault();
//     }
//   }
// }
