import 'package:flutter/material.dart';
import 'package:hitachi/route/route_generator.dart';
import 'package:hitachi/route/router_list.dart';
import 'package:hitachi/widget/card_button.dart';

import 'widget/box_inputfield.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
        initialRoute: "/",
        onGenerateRoute: RouteGenerator.generateRoute);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CircularProgressIndicator(),
            ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, RouterList.TEST_SCREEN),
                child: Container()),
            const Text(
              'You have pushed the button this many times:',
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  BoxInputField(
                    controller: _controller1,
                    labelText: "Text",
                  ),
                  BoxInputField(
                    controller: _controller2,
                    labelText: "Text2",
                  ),
                  CardButton(
                    text: "Text1",
                    onPress: () => Navigator.pushNamed(
                        context, RouterList.PLAN_WINDING_PAGE),
                  ),
                  CardButton(
                    text: "Text2",
                    onPress: () => print("test2"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
