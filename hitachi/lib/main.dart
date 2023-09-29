import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hitachi/blocs/connection/testconnection_bloc.dart';
import 'package:hitachi/blocs/filmReceive/film_receive_bloc.dart';

import 'package:hitachi/blocs/lineElement/line_element_bloc.dart';
import 'package:hitachi/blocs/machineBreakDown/machine_break_down_bloc.dart';
import 'package:hitachi/blocs/network/bloc/network_bloc.dart';
import 'package:hitachi/blocs/planwinding/planwinding_bloc.dart';
import 'package:hitachi/blocs/pmDaily/pm_daily_bloc.dart';
import 'package:hitachi/blocs/treatment/treatment_bloc.dart';
import 'package:hitachi/blocs/zincthickness/zinc_thickness_bloc.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/route/route_generator.dart';
import 'package:hitachi/route/router_list.dart';
import 'package:hitachi/screens/auth/LoginScreen.dart';
import 'package:hitachi/screens/mainMenu/Homepage.dart';
import 'package:hitachi/screens/splash_screen.dart';
import 'package:hitachi/services/databaseHelper.dart';
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
                AppData.setMode("Online");
                AlertSnackBar.show(
                    title: 'Connection Successful',
                    message: 'You\'re Online Now',
                    type: AlertType.success,
                    duration: const Duration(seconds: 5));
              }
            },
            child: child,
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
