import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/combobox/combobox_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models/combobox/comboboxModel.dart';
import 'package:hitachi/services/databaseHelper.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DropdownScreen extends StatefulWidget {
  const DropdownScreen({super.key});

  @override
  State<DropdownScreen> createState() => _DropdownScreenState();
}

class _DropdownScreenState extends State<DropdownScreen> {
  Map<String, double> columnWidths = {
    'server': double.nan,
    'pda': double.nan,
  };
  dropdownDataSource? dataSource;
  int pdalength = 0;
  int serverlength = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<ComboBoxModel> itemCombo = [];

  @override
  void initState() {
    BlocProvider.of<ComboboxBloc>(context).add(
      ComboboxGroupEvent(),
    );
    super.initState();
  }

  Future<int> _getLengthDataFromPda() async {
    try {
      var row = await databaseHelper.queryAllRows('COMBOBOX');

      setState(() {
        pdalength = row.length;
      });
      return pdalength;
    } catch (e, s) {
      print(e);
      print(s);
      throw Exception();
    }
  }

  Future _saveDropdownOnPda(List<ComboBoxModel> items) async {
    await DatabaseHelper().deleteDataAllFromSQLite(tableName: 'COMBOBOX');

    for (var combobox in items) {
      await DatabaseHelper().insertSqlite('COMBOBOX', {
        'nameGroup': '${combobox.GROUP}',
        'valueMember': '${combobox.VALUEMEMBER}',
        'IsActive': combobox.IS_ACTIVE,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ComboboxBloc, ComboboxState>(
            listener: (context, state) async {
          if (state is ComboboxLoadingState) {
            EasyLoading.show(status: "Loading ...");
          } else if (state is ComboboxLoadedState) {
            itemCombo = state.item;
            _getLengthDataFromPda().then((value) {
              setState(() {
                dataSource = dropdownDataSource(
                    pda: pdalength, server: itemCombo.length);
              });
            });

            setState(() {});
            EasyLoading.dismiss();
          } else if (state is ComboboxErrorState) {
            _getLengthDataFromPda().then((value) {
              setState(() {
                dataSource = dropdownDataSource(pda: pdalength, server: 0);
              });
            });
            setState(() {});
            EasyLoading.showError("Please Check Connection");
          }
        })
      ],
      child: BgWhite(
          textTitle: Label("Download dropdown"),
          body: Column(
            children: [
              dataSource != null
                  ? Container(
                      height: 125,
                      child: SfDataGrid(
                        gridLinesVisibility: GridLinesVisibility.both,
                        headerGridLinesVisibility: GridLinesVisibility.both,
                        source: dataSource!,
                        columnWidthMode: ColumnWidthMode.fill,
                        allowPullToRefresh: true,
                        allowColumnsResizing: true,
                        columnResizeMode: ColumnResizeMode.onResizeEnd,
                        columns: [
                          GridColumn(
                            columnName: 'server',
                            label: Container(
                              color: COLOR_BLUE_DARK,
                              child: Center(
                                child: Label(
                                  'on Server.',
                                  color: COLOR_WHITE,
                                ),
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'pda',
                            label: Container(
                              color: COLOR_BLUE_DARK,
                              child: Center(
                                child: Label(
                                  'on PDA.',
                                  color: COLOR_WHITE,
                                ),
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'diff',
                            label: Container(
                              color: COLOR_BLUE_DARK,
                              child: Center(
                                child: Label(
                                  'diff',
                                  color: COLOR_WHITE,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(COLOR_BLUE_DARK)),
                          onPressed: () async {
                            if (itemCombo.isNotEmpty) {
                              await _saveDropdownOnPda(itemCombo);
                              await _getLengthDataFromPda().then((value) {
                                setState(() {
                                  dataSource = dropdownDataSource(
                                      pda: pdalength, server: itemCombo.length);
                                });
                              });
                              EasyLoading.showSuccess("Success !");
                            } else {
                              EasyLoading.showError("Check Connection");
                            }
                          },
                          child: Label(
                            "Download",
                            color: COLOR_WHITE,
                          )),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class dropdownDataSource extends DataGridSource {
  dropdownDataSource({int? server, int? pda}) {
    int total = server! - pda!;
    _employees.add(DataGridRow(
      cells: [
        DataGridCell<int>(columnName: 'server', value: server),
        DataGridCell<int>(columnName: 'pda', value: pda),
        DataGridCell<int>(
            columnName: 'diff', value: server != 0 ? server - pda : 0),
      ],
    ));
  }

  List<DataGridRow> _employees = [];

  @override
  List<DataGridRow> get rows => _employees;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>(
        (dataGridCell) {
          return Container(
            alignment: (dataGridCell.columnName == 'id' ||
                    dataGridCell.columnName == 'qty')
                ? Alignment.center
                : Alignment.center,
            child: Text(dataGridCell.value.toString()),
          );
        },
      ).toList(),
    );
  }
}
