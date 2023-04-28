import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class WindingJobStart_Screen_Hold extends StatefulWidget {
  const WindingJobStart_Screen_Hold({Key? key}) : super(key: key);


  @override
  State<WindingJobStart_Screen_Hold> createState() =>
      _WindingJobStart_Screen_HoldState();
}

class _WindingJobStart_Screen_HoldState
    extends State<WindingJobStart_Screen_Hold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Syncfusion DataGrid'),
        ),
        body: Center(
          child: Expanded(
            child: SfDataGrid(
              source: _employeeDataSource, columns: [],
            ),
          ),
        ));
  };
  }
}
