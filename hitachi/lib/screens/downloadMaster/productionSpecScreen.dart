import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hitachi/blocs/combobox/combobox_bloc.dart';
import 'package:hitachi/blocs/production/production_spec_bloc.dart';
import 'package:hitachi/helper/background/bg_white.dart';
import 'package:hitachi/helper/colors/colors.dart';
import 'package:hitachi/helper/text/label.dart';
import 'package:hitachi/models/combobox/comboboxModel.dart';
import 'package:hitachi/models/productions/productionsModel.dart';
import 'package:hitachi/services/databaseHelper.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ProductionSpecScreen extends StatefulWidget {
  const ProductionSpecScreen({super.key});

  @override
  State<ProductionSpecScreen> createState() => _ProductionSpecScreenState();
}

class _ProductionSpecScreenState extends State<ProductionSpecScreen> {
  Map<String, double> columnWidths = {
    'server': double.nan,
    'pda': double.nan,
  };
  productionSpecDataSource? dataSource;
  int pdalength = 0;
  int serverlength = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<ProductionModel> itemProdSpec = [];

  @override
  void initState() {
    BlocProvider.of<ProductionSpecBloc>(context).add(GetProductionSpecEvent());
    super.initState();
  }

  Future<int> _getLengthDataFromPda() async {
    try {
      var row = await databaseHelper.queryAllRows('PRODSPEC');

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

  Future _saveDropdownOnPda(List<ProductionModel> items) async {
    await DatabaseHelper().deleteDataAllFromSQLite(tableName: 'PRODSPEC');

    for (var prod in items) {
      await DatabaseHelper().insertSqlite('PRODSPEC', {
        'JUMET': prod.JUMET,
        'IPE': prod.IPE,
        'Film': prod.Film,
        'Wind_Min': prod.Wind_Min,
        'Wind_Avg': prod.Wind_Avg,
        'Wind_Max': prod.Wind_Max,
        'Wind_Dia': prod.Wind_Dia,
        'Wind_Turn': prod.Wind_Turn,
        'Clearing': prod.Clearing,
        'Treatment': prod.Treatment,
        'Ipeak': prod.Ipeak,
        'HighVolt': prod.HighVolt,
        'Reactor': prod.Reactor,
        'Measure_Min': prod.Measure_Min,
        'Measure_Max': prod.Measure_Max,
        'Tangent': prod.Tangent,
        'BomP': prod.BomP,
        'SM': prod.SM,
        'S1': prod.S1,
        'S2': prod.S2,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProductionSpecBloc, ProductionSpecState>(
            listener: (context, state) async {
          if (state is GetProductionLoadingState) {
            EasyLoading.show(status: "Loading ...");
          } else if (state is GetProductionLoadedState) {
            itemProdSpec = state.item;
            _getLengthDataFromPda().then((value) {
              setState(() {
                dataSource = productionSpecDataSource(
                    pda: pdalength, server: itemProdSpec.length);
              });
            });
            setState(() {});
            EasyLoading.dismiss();
          } else if (state is GetProductionErrorState) {
            EasyLoading.showError("Please Check Connection");
            _getLengthDataFromPda().then((value) {
              setState(() {
                dataSource =
                    productionSpecDataSource(pda: pdalength, server: 0);
              });
            });
          }
        })
      ],
      child: BgWhite(
          textTitle: Label("Productions Spec."),
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
                            if (itemProdSpec.isNotEmpty) {
                              await _saveDropdownOnPda(itemProdSpec);
                              await _getLengthDataFromPda().then((value) {
                                setState(() {
                                  dataSource = productionSpecDataSource(
                                      pda: pdalength,
                                      server: itemProdSpec.length);
                                });
                              });
                              EasyLoading.showSuccess("Success !");
                            } else {
                              EasyLoading.showError("Please Check Connection");
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

class productionSpecDataSource extends DataGridSource {
  productionSpecDataSource({int? server, int? pda}) {
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
