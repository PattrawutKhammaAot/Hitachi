import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:hitachi/api.dart';
import 'package:hitachi/config.dart';
import 'package:hitachi/models/ResponeDefault.dart';
import 'package:hitachi/models/SendWdFinish/checkWdsFinishModel.dart';
import 'package:hitachi/models/SendWdFinish/sendWdsFinish_Input_Model.dart';
import 'package:hitachi/models/SendWdFinish/sendWdsFinish_output_Model.dart';
import 'package:hitachi/models/SendWds/SendWdsModel_Output.dart';
import 'package:hitachi/models/SendWds/sendWdsModel_input.dart';
import 'package:hitachi/models/checkPackNo_Model.dart';
import 'package:hitachi/models/getIPEProdSpecByBatch/getIpeProdSpecByBatch.dart';
import 'package:hitachi/models/materialInput/materialInputModel.dart';
import 'package:hitachi/models/materialInput/materialOutputModel.dart';
import 'package:hitachi/models/pmdailyModel/PMDailyOutputModel.dart';
import 'package:hitachi/models/processCheck/processCheckModel.dart';
import 'package:hitachi/models/processFinish/processFinishInputModel.dart';
import 'package:hitachi/models/processFinish/processFinishOutput.dart';
import 'package:hitachi/models/processStart/processInputModel.dart';
import 'package:hitachi/models/processStart/processOutputModel.dart';
import 'package:hitachi/models/reportRouteSheet/reportRouteSheetModel.dart';
import 'package:hitachi/models/sendWdsReturnWeight/sendWdsReturnWeight_Input_Model.dart';
import 'package:hitachi/models/sendWdsReturnWeight/sendWdsReturnWeight_Output_Model.dart';
import 'package:hitachi/services/databaseHelper.dart';

import '../../models/materialInput/loadMaterialInput/materialLoadModel.dart';

part 'line_element_event.dart';
part 'line_element_state.dart';

class LineElementBloc extends Bloc<LineElementEvent, LineElementState> {
  Dio dio = Dio();

  LineElementBloc() : super(LineElementInitial()) {
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
    on<CheckWindingFinishEvent>(
      (event, emit) async {
        try {
          emit(CheckWindingFinishLoadingState());
          final mlist = await fetchCheckWindingFinish(event.items);
          emit(CheckWindingFinishLoadedState(mlist));
        } catch (e) {
          emit(CheckWindingFinishErrorState(e.toString()));
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
    on<CheckMaterialInputEvent>(
      (event, emit) async {
        try {
          emit(CheckMaterialInputLoadingState());
          final mlist = await fetchCheckMaterial(event.items);
          emit(CheckMaterialInputLoadedState(mlist));
        } catch (e) {
          emit(CheckMaterialInputErrorState(e.toString()));
        }
      },
    );
    on<MaterialLoadEvent>(
      (event, emit) async {
        try {
          emit(MaterialLoadDataLoadingState());
          final mlist = await fetchLoadMaterial();
          emit(MaterialLoadDataLoadedState(mlist));
        } catch (e) {
          emit(MaterialLoadDataErrorState(e.toString()));
        }
      },
    );
    on<ProcessCheckEvent>(
      (event, emit) async {
        try {
          emit(ProcessCheckLoadingState());
          final mlist = await fetchProcessCheck(event.item);
          emit(ProcessCheckLoadedState(mlist));
        } catch (e) {
          emit(ProcessCheckErrorState(e.toString()));
        }
      },
    );

//ProcessStart
    on<ProcessStartEvent>(
      (event, emit) async {
        try {
          emit(ProcessStartLoadingState());
          final mlist = await fetchProcessStart(event.items);
          emit(ProcessStartLoadedState(mlist));
        } catch (e) {
          emit(ProcessStartErrorState(e.toString()));
        }
      },
    );
    //ProcessFinish
    on<ProcessFinishInputEvent>(
      (event, emit) async {
        try {
          emit(ProcessFinishLoadingState());
          final mlist = await fetchProcessFinish(event.items);
          emit(ProcessFinishLoadedState(mlist));
        } catch (e) {
          emit(ProcessFinishErrorState(e.toString()));
        }
      },
    );
    on<GetIPEProdSpecByBatchEvent>(
      (event, emit) async {
        try {
          emit(GetIPEProdSpecByBatchLoadingState());
          final mlist = await fetchGetIpeProdSpecByBatch(event.batch);
          emit(GetIPEProdSpecByBatchLoadedState(mlist));
        } catch (e) {
          emit(GetIPEProdSpecByBatchErrorState(e.toString()));
        }
      },
    );
    on<GetThicknessZincBatchEvent>(
      (event, emit) async {
        try {
          emit(GetThincknessZincLoadingState());
          final mlist = await fetchGetThicknessZincBatch(event.batch);
          emit(GetThincknessZincLoadedState(mlist));
        } catch (e) {
          emit(GetThincknessZincErrorState(e.toString()));
        }
      },
    );
  }
//Scan
  Future<sendWdsReturnWeightInputModel> fetchSendWindingReturnWeightScan(
      sendWdsReturnWeightOutputModel item) async {
    try {
      Response responese = await dio.post(
          ApiConfig.LE_SEND_WINDING_START_WEIGHT,
          options: Options(
              headers: ApiConfig.HEADER(),
              sendTimeout: Duration(seconds: 120),
              receiveTimeout: Duration(seconds: 120)),
          data: jsonEncode(item));

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
      Response responese = await dio.post(ApiConfig.LE_SEND_WINDING_START,
          options: Options(
              headers: ApiConfig.HEADER(),
              sendTimeout: Duration(seconds: 60),
              receiveTimeout: Duration(seconds: 60)),
          data: jsonEncode(itemOutput));

      SendWindingStartModelInput post =
          SendWindingStartModelInput.fromJson(responese.data);

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
      Response responese = await dio.post(
        ApiConfig.LE_SEND_WINDING_FINISH,
        options: Options(
            headers: ApiConfig.HEADER(),
            sendTimeout: Duration(seconds: 60),
            receiveTimeout: Duration(seconds: 60)),
        data: jsonEncode(itemOutput),
      );

      SendWdsFinishInputModel post =
          SendWdsFinishInputModel.fromJson(responese.data);

      return post;
    } catch (e, s) {
      print("catch Exception occured: $e StackTrace: $s");
      return SendWdsFinishInputModel();
    }
  }

  //CheckWindingFinish
  Future<CheckWdsFinishInputModel> fetchCheckWindingFinish(
      String itemOutput) async {
    try {
      Response responese = await dio.get(
        ApiConfig.LE_CHECK_SEND_WINDING_FINISH + itemOutput,
        options: Options(
            headers: ApiConfig.HEADER(),
            sendTimeout: Duration(seconds: 60),
            receiveTimeout: Duration(seconds: 60)),
      );

      CheckWdsFinishInputModel post =
          CheckWdsFinishInputModel.fromJson(responese.data);

      // if (post.RESULT == true && post.MESSAGE == 'Success') {
      //   var sql = await DatabaseHelper()
      //       .queryIPESHEET("IPE_SHEET", [post.BATCHNO ?? "0"]);
      //   if (sql.isEmpty) {
      //     await DatabaseHelper().insertSqlite('IPE_SHEET', {
      //       'BatchNo': post.BATCHNO,
      //       'IPE_NO': post.IPE_NO,
      //     });
      //   } else {
      //     await DatabaseHelper().updateIPESHEET('IPE_SHEET', {
      //       'BatchNo': post.BATCHNO,
      //       'IPE_NO': post.IPE_NO,
      //     }, [
      //       post.BATCHNO ?? "0"
      //     ]);
      //   }
      // }
     
      return post;
    } on Exception {
      throw Exception();
    }
  }

  //Check packNO
  Future<CheckPackNoModel> fetchCheckPackNo(int number) async {
    printInfo(info: "${ApiConfig.LE_CHECKPACK_NO}");
    try {
      Response responese = await dio.get(ApiConfig.LE_CHECKPACK_NO + "$number",
          options: Options(
              headers: ApiConfig.HEADER(),
              sendTimeout: Duration(seconds: 5),
              receiveTimeout: Duration(seconds: 5)));
 
      CheckPackNoModel post = CheckPackNoModel.fromJson(responese.data);

      return post;
    } on Exception {
      throw Exception();
    }
  }

  //Report Route Sheet
  Future<ReportRouteSheetModel> fetchReportRouteSheetModel(
      String number) async {
    try {
      Response response = await dio.get(
        ApiConfig.LE_REPORT_ROUTE_SHEET + "$number",
        options: Options(
            headers: ApiConfig.HEADER(),
            sendTimeout: Duration(seconds: 60),
            receiveTimeout: Duration(seconds: 60)),
      );
   

      ReportRouteSheetModel tmp = ReportRouteSheetModel.fromJson(response.data);

      return tmp;
    } on Exception {
      throw Exception();
    }
  }

  //MaterialInput
  Future<MaterialInputModel> fetchMaterial(MaterialOutputModel items) async {
    try {
      Response response = await dio.post(ApiConfig.LE_MATERIALINPUT,
          options: Options(
              headers: ApiConfig.HEADER(),
              sendTimeout: Duration(seconds: 60),
              receiveTimeout: Duration(seconds: 60)),
          data: jsonEncode(items));

      MaterialInputModel tmp = MaterialInputModel.fromJson(response.data);

      return tmp;
    } catch (e) {
      print(e);
      return MaterialInputModel();
    }
  }

  //CheckMaterialInput
  Future<ResponeDefault> fetchCheckMaterial(String items) async {
    try {
      Response response = await dio.get(
        ApiConfig.LE_CHECK_MATERIAL_INPUT + "${items}",
        options: Options(
            headers: ApiConfig.HEADER(),
            sendTimeout: Duration(seconds: 60),
            receiveTimeout: Duration(seconds: 60)),
      );
 

      ResponeDefault tmp = ResponeDefault.fromJson(response.data);

      return tmp;
    } on Exception {
      throw Exception();
    }
  }

  //LoadMaterialInput
  Future<MaterialInputLoadModel> fetchLoadMaterial() async {
    try {
      Response response = await dio.get(
        ApiConfig.LE_LOAD_MATERIAL_INPUT,
        options: Options(
            headers: ApiConfig.HEADER(),
            sendTimeout: Duration(seconds: 60),
            receiveTimeout: Duration(seconds: 60)),
      );
  

      MaterialInputLoadModel tmp =
          MaterialInputLoadModel.fromJson(response.data);

      return tmp;
    } on Exception catch (e, s) {
      print(e);
      print(s);
      throw Exception();
    }
  }

  //ProcessStart
  Future<ProcessInputModel> fetchProcessStart(ProcessOutputModel items) async {
    try {
      Response response = await dio.post(ApiConfig.LE_PROCESSSTARTINPUT,
          options: Options(
              headers: ApiConfig.HEADER(),
              sendTimeout: Duration(seconds: 60),
              receiveTimeout: Duration(seconds: 60)),
          data: jsonEncode(items));

      ProcessInputModel tmp = ProcessInputModel.fromJson(response.data);
   
      return tmp;
    } on Exception {
      throw (Exception);
      // return ProcessInputModel();
    }
  }

  //ProcessFinish
  Future<ProcessFinishInputModel> fetchProcessFinish(
      ProcessFinishOutputModel items) async {

    try {
      Response response = await dio.post(ApiConfig.LE_PROCESSFINISHINPUT,
          options: Options(
              headers: ApiConfig.HEADER(),
              sendTimeout: Duration(seconds: 60),
              receiveTimeout: Duration(seconds: 60)),
          data: jsonEncode(items));

      ProcessFinishInputModel tmp =
          ProcessFinishInputModel.fromJson(response.data);

      return tmp;
    } catch (e) {
      print(e);
      return ProcessFinishInputModel();
    }
  }

  //ProcessCheck
  Future<ResponeDefault> fetchProcessCheck(ProcessCheckModel items) async {
 
    try {
      Response response = await dio.post(ApiConfig.UPDATE_CHECK_PROCESS,
          options: Options(
              headers: ApiConfig.HEADER(),
              sendTimeout: Duration(seconds: 5),
              receiveTimeout: Duration(seconds: 5)),
          data: jsonEncode(items));


      ResponeDefault tmp = ResponeDefault.fromJson(response.data);

      return tmp;
    } catch (e, s) {
      print(e);
      print(s);
      throw Exception();
    }
  }

  Future<GetIPEProdSpecByBatchModel> fetchGetIpeProdSpecByBatch(
      String batch) async {
    try {
      Response responese = await dio.get(
        BASE_API_URL + "LineElement/GetIPEProdSpecByBatch?batch=" + batch,
        options: Options(
            headers: ApiConfig.HEADER(),
            sendTimeout: Duration(seconds: 60),
            receiveTimeout: Duration(seconds: 60)),
      );

      GetIPEProdSpecByBatchModel post =
          GetIPEProdSpecByBatchModel.fromJson(responese.data);
     
      return post;
    } on Exception {
      throw Exception();
    }
  }

  Future<String> fetchGetThicknessZincBatch(String batch) async {
    try {
      Response responese = await dio.get(
        BASE_API_URL + "LineElement/GetThicknessZinc?batch=" + batch,
        options: Options(
            headers: ApiConfig.HEADER(),
            sendTimeout: Duration(seconds: 60),
            receiveTimeout: Duration(seconds: 60)),
      );

      return responese.data;
    } catch (e, s) {
      print(e);
      print(s);
      throw Exception();
    }
  }
}
