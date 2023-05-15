import 'config.dart';

class ApiConfig {
  static Map<String, dynamic> HEADER({String? Authorization}) {
    if (Authorization != null) {
      return {
        'Content-Type': 'application/json;charset=UTF-8',
        'Charset': 'utf-8',
        'Authorization': 'Bearer $Authorization'
      };
    } else {
      return {
        'Content-Type': 'application/json;charset=UTF-8',
        'Charset': 'utf-8',
      };
    }
  }

  //LineElement
  //GET
  static String LE_CHECKPACK_NO =
      "${BASE_API_URL}LineElement/WSCheckPackNo?packNo="; // Number
  //POST
  static String LE_SEND_WINDING_START =
      "${BASE_API_URL}LineElement/SendWindingStart";

  //Post
  static String LE_SEND_WINDING_START_WEIGHT =
      "${BASE_API_URL}LineElement/SendWindingStartReturnWeight";

  ///---------------------WINDING FINISH ----------------------///
  //Post
  static String LE_SEND_WINDING_FINISH =
      "${BASE_API_URL}LineElement/SendWindingFinish";

  ///---------------------REPORT ROUTE SHEET ----------------------///

  //Get
  static String LE_REPORT_ROUTE_SHEET =
      "${BASE_API_URL}LineElement/GetReportRouteSheet?batch=";

  ///---------------------MaterialInput ----------------------///

  //Get
  static String LE_MATERIALINPUT =
      "${BASE_API_URL}LineElement/SendMaterialInput";

  //POST MACHINE BREAKDOWN
  static String MACHINE_BREAKDOWN = "${BASE_API_URL}LineElement/SendMachine";

  ///---------------------ProcessInput ----------------------///

  //Get
  static String LE_PROCESSINPUT = "${BASE_API_URL}LineElement/SendProcessStart";

  //POST PROCESS BREAKDOWN
  static String PROCESS_BREAKDOWN =
      "${BASE_API_URL}LineElement/SendProcessStart";

  //POST SEND FILM IN
  static String FILM_RECEIVE = "${BASE_API_URL}LineElement/SendFilmIn";
  //POST SEND TreatmentStart
  static String TREAMTMENT_START = "${BASE_API_URL}LineElement/SendTreatStart";
  //POST SEND TreatmentFinish
  static String TREAMTMENT_FINISH =
      "${BASE_API_URL}LineElement/SendTreatFinish";
}
