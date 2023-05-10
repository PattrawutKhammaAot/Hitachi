import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:hitachi/api.dart';
import 'package:hitachi/models/SendWdFinish/sendWdsFinish_Input_Model.dart';
import 'package:hitachi/models/SendWdFinish/sendWdsFinish_output_Model.dart';
import 'package:hitachi/models/SendWds/SendWdsModel_Output.dart';
import 'package:hitachi/models/SendWds/sendWdsModel_input.dart';
import 'package:hitachi/models/checkPackNo_Model.dart';
import 'package:hitachi/models/materialInput/materialInputModel.dart';
import 'package:hitachi/models/materialInput/materialOutputModel.dart';
import 'package:hitachi/models/reportRouteSheet/reportRouteSheetModel.dart';
import 'package:hitachi/models/sendWdsReturnWeight/sendWdsReturnWeight_Input_Model.dart';
import 'package:hitachi/models/sendWdsReturnWeight/sendWdsReturnWeight_Output_Model.dart';

part 'line_element_event.dart';
part 'line_element_state.dart';

class LineElementBloc extends Bloc<LineElementEvent, LineElementState> {
  LineElementBloc() : super(LineElementInitial()) {
    on<LineElementEvent>((event, emit) {
      // TODO: implement event handler
    });
    //HOLD
    on<PostSendWindingStartEvent>(
      (event, emit) async {
        try {
          emit(PostSendWindingStartLoadingState());
          final mlist = await fetchSendWindingHold(event.items);
          emit(PostSendWindingStartLoadedState(mlist));
        } catch (e) {
          emit(PostSendWindingStartErrorState(e.toString()));
        }
      },
    );
    //SCAN
    on<PostSendWindingStartReturnWeightEvent>(
      (event, emit) async {
        try {
          emit(PostSendWindingStartReturnWeightLoadingState());
          final mlist = await fetchSendWindingReturnWeightScan(event.items);
          emit(PostSendWindingStartReturnWeightLoadedState(mlist));
        } catch (e) {
          emit(PostSendWindingStartReturnWeightErrorState(e.toString()));
        }
      },
    );
    on<PostSendWindingFinishEvent>(
      (event, emit) async {
        try {
          emit(PostSendWindingFinishLoadingState());
          final mlist = await fetchSendWindingFinish(event.items);
          emit(PostSendWindingFinishLoadedState(mlist));
        } catch (e) {
          emit(PostSendWindingFinishErrorState(e.toString()));
        }
      },
    );
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
    on<ReportRouteSheetEvenet>(
      (event, emit) async {
        try {
          emit(GetReportRuteSheetLoadingState());
          final mlist = await fetchReportRouteSheetModel(event.items);
          emit(GetReportRuteSheetLoadedState(mlist));
        } catch (e) {
          emit(GetReportRuteSheetErrorState(e.toString()));
        }
      },
    );
    on<MaterialInputEvent>(
      (event, emit) async {
        try {
          emit(MaterialInputLoadingState());
          final mlist = await fetchMaterial(event.items);
          emit(MaterialInputLoadedState(mlist));
        } catch (e) {
          emit(MaterialInputErrorState(e.toString()));
        }
      },
    );
  }
//Scan
  Future<sendWdsReturnWeightInputModel> fetchSendWindingReturnWeightScan(
      sendWdsReturnWeightOutputModel item) async {
    try {
      Response responese = await Dio().post(
          ApiConfig.LE_SEND_WINDING_START_WEIGHT,
          options: Options(headers: ApiConfig.HEADER()),
          data: jsonEncode(item));
      print(responese.data);
      sendWdsReturnWeightInputModel post =
          sendWdsReturnWeightInputModel.fromJson(responese.data);
      return post;
    } catch (e, s) {
      print("Exception occured: $e StackTrace: $s");
      return sendWdsReturnWeightInputModel();
    }
  }

  //Hold
  Future<SendWindingStartModelInput> fetchSendWindingHold(
      SendWindingStartModelOutput itemOutput) async {
    try {
      Response responese = await Dio().post(ApiConfig.LE_SEND_WINDING_START,
          options: Options(headers: ApiConfig.HEADER()),
          data: jsonEncode(itemOutput));
      print(responese.data);
      SendWindingStartModelInput post =
          SendWindingStartModelInput.fromJson(responese.data);
      print(post.PACK_NO);
      return post;
    } catch (e, s) {
      print("Exception occured: $e StackTrace: $s");
      return SendWindingStartModelInput();
    }
  }

  //Finish
  //Hold
  Future<SendWdsFinishInputModel> fetchSendWindingFinish(
      SendWdsFinishOutputModel itemOutput) async {
    try {
      Response responese = await Dio().post(ApiConfig.LE_SEND_WINDING_FINISH,
          options: Options(headers: ApiConfig.HEADER()),
          data: jsonEncode(itemOutput));
      print(responese.data);
      SendWdsFinishInputModel post =
          SendWdsFinishInputModel.fromJson(responese.data);

      return post;
    } catch (e, s) {
      print("catch Exception occured: $e StackTrace: $s");
      return SendWdsFinishInputModel();
    }
  }

  //Check packNO
  Future<CheckPackNoModel> fetchCheckPackNo(int number) async {
    print(ApiConfig.LE_CHECKPACK_NO);
    try {
      Response responese = await Dio().get(
          ApiConfig.LE_CHECKPACK_NO + "$number",
          options: Options(headers: ApiConfig.HEADER()));

      CheckPackNoModel post = CheckPackNoModel.fromJson(responese.data);

      return post;
    } catch (e, s) {
      print("$e" + "$s");
      return CheckPackNoModel();
    }
  }

  //Report Route Sheet
  Future<ReportRouteSheetModel> fetchReportRouteSheetModel(
      String number) async {
    try {
      Response response = await Dio().get(
        ApiConfig.LE_REPORT_ROUTE_SHEET + "$number",
        options: Options(
          headers: ApiConfig.HEADER(),
        ),
      );

      ReportRouteSheetModel tmp = ReportRouteSheetModel.fromJson(response.data);

      return tmp;
    } catch (e) {
      print(e);
      return ReportRouteSheetModel();
    }
  }

  //MaterialInput
  Future<MaterialInputModel> fetchMaterial(MaterialOutputModel items) async {
    try {
      Response response = await Dio().post(ApiConfig.LE_MATERIALINPUT + "12345",
          options: Options(
            headers: ApiConfig.HEADER(),
          ),
          data: jsonEncode(items));

      MaterialInputModel tmp = MaterialInputModel.fromJson(response.data);

      return tmp;
    } catch (e) {
      print(e);
      return MaterialInputModel();
    }
  }
}
