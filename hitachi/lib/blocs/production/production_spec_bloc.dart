import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:equatable/equatable.dart';
import 'package:hitachi/api.dart';
import 'package:hitachi/models/productions/productionsModel.dart';

part 'production_spec_event.dart';
part 'production_spec_state.dart';

class ProductionSpecBloc
    extends Bloc<ProductionSpecEvent, ProductionSpecState> {
  Dio dio = Dio();
  ProductionSpecBloc() : super(ProductionSpecInitial()) {
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
    on<ProductionSpecEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<GetProductionSpecEvent>(
      (event, emit) async {
        try {
          emit(GetProductionLoadingState());
          final mlist = await fetchIPEPRODPSEC();
          emit(GetProductionLoadedState(mlist));
        } catch (e) {
          emit(GetProductionErrorState(e.toString()));
        }
      },
    );
  }
  Future<List<ProductionModel>> fetchIPEPRODPSEC() async {
    try {
      Response responese = await dio.get(
        ApiConfig.GET_IPE_PRODUCTIONS,
        options: Options(
            headers: ApiConfig.HEADER(),
            sendTimeout: Duration(seconds: 3),
            receiveTimeout: Duration(seconds: 3)),
      );

      List<ProductionModel> ipeProdSpec = (responese.data['ProdSpec'] as List)
          .map((item) => ProductionModel.fromJson(item))
          .toList();

      return ipeProdSpec;
    } catch (e, s) {
      print(e);
      print(s);
      throw Exception();
    }
  }
}
