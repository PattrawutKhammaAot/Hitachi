import 'dart:async';

import 'package:bot_toast/bot_toast.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:hitachi/blocs/combobox/combobox_bloc.dart';
import 'package:hitachi/blocs/connection/testconnection_bloc.dart';
import 'package:hitachi/blocs/filmReceive/film_receive_bloc.dart';

import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/blocs/machineBreakDown/machine_break_down_bloc.dart';
import 'package:hitachi/blocs/materialTrace/update_material_trace_bloc.dart';
import 'package:hitachi/blocs/network/bloc/network_bloc.dart';
import 'package:hitachi/blocs/planwinding/planwinding_bloc.dart';
import 'package:hitachi/blocs/pmDaily/pm_daily_bloc.dart';
import 'package:hitachi/blocs/production/production_spec_bloc.dart';
import 'package:hitachi/blocs/treatment/treatment_bloc.dart';
import 'package:hitachi/blocs/windingRecord/windingrecord_bloc.dart';
import 'package:hitachi/blocs/zincthickness/zinc_thickness_bloc.dart';

import 'package:hitachi/route/route_generator.dart';

import 'package:hitachi/screens/splash_screen.dart';

import 'package:hitachi/widget/alertSnackBar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'appdata.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final easyLoading = EasyLoading.init();
  final botToastBuilder = BotToastInit();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LineElementBloc>(
          create: (_) => LineElementBloc(),
        ),
        BlocProvider<MachineBreakDownBloc>(
          create: (_) => MachineBreakDownBloc(),
        ),
        BlocProvider<FilmReceiveBloc>(
          create: (_) => FilmReceiveBloc(),
        ),
        BlocProvider<TreatmentBloc>(
          create: (_) => TreatmentBloc(),
        ),
        BlocProvider<ZincThicknessBloc>(
          create: (_) => ZincThicknessBloc(),
        ),
        BlocProvider<TestconnectionBloc>(
          create: (_) => TestconnectionBloc(),
        ),
        BlocProvider<PmDailyBloc>(
          create: (_) => PmDailyBloc(),
        ),
        BlocProvider<PlanWindingBloc>(
          create: (_) => PlanWindingBloc(),
        ),
        BlocProvider<WindingrecordBloc>(
          create: (_) => WindingrecordBloc(),
        ),
        BlocProvider<ComboboxBloc>(
          create: (_) => ComboboxBloc(),
        ),
        BlocProvider<ProductionSpecBloc>(
          create: (_) => ProductionSpecBloc(),
        ),
        BlocProvider<UpdateMaterialTraceBloc>(
          create: (_) => UpdateMaterialTraceBloc(),
        ),
        BlocProvider(create: (_) => NetworkBloc()..add(NetworkObserve())),
      ],
      child: MaterialApp(
        builder: (context, child) {
          child = BlocListener<NetworkBloc, NetworkState>(
            listener: (context, state) async {
              if (state is NetworkFailure) {
                AppData.setMode("Offline");
                AlertSnackBar.show(
                    title: 'Connection Failed',
                    message: 'Check your internet connection and try again ',
                    type: AlertType.error,
                    duration: const Duration(seconds: 10));
              } else if (state is NetworkSuccess) {
                BlocProvider.of<TestconnectionBloc>(context)
                    .add(Test_ConnectionOnWindingRecordEvent());
              }
            },
            child: BlocListener<TestconnectionBloc, TestconnectionState>(
              listener: (context, state) async {
                if (state is TestconnectionWRDErrorState) {
                  AppData.setMode("Offline");
                  AlertSnackBar.show(
                      title: 'Connection Failed',
                      message: 'Check your internet connection and try again ',
                      type: AlertType.error,
                      duration: const Duration(seconds: 10));
                } else if (state is TestconnectionWRDLoadedState) {
                  if (state.item.RESULT == true) {
                    AppData.setMode("Online");
                    AlertSnackBar.show(
                        title: 'Connection Successful',
                        message: 'You\'re Online Now',
                        type: AlertType.success,
                        duration: const Duration(seconds: 5));
                  } else {
                    AppData.setMode("Offline");
                    AlertSnackBar.show(
                        title: 'Connection Failed',
                        message:
                            'Check your internet connection and try again ',
                        type: AlertType.error,
                        duration: const Duration(seconds: 10));
                  }
                }
              },
              child: child,
            ),
          );
          child = botToastBuilder(context, child);
          child = easyLoading(context, child);
          return child;
        },
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
        initialRoute: "/",
        onGenerateRoute: RouteGenerator.generateRoute,
        navigatorObservers: [BotToastNavigatorObserver()],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
