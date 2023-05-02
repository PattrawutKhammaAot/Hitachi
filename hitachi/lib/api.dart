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
}