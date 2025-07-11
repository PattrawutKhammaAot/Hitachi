class WindingSheetModel {
  const WindingSheetModel(
      {this.MACHINE_NO,
      this.OPERATOR_NAME,
      this.BATCH_NO,
      this.PRODUCT,
      this.PACK_NO,
      this.PAPER_CORE,
      this.PP_CORE,
      this.FOIL_CORE,
      this.BATCH_START_DATE,
      this.BATCH_END_DATE,
      this.ELEMENT,
      this.STATUS,
      this.START_END,
      this.CHECK_COMPLETE,
      this.FILM_SERIAL_NO,
      this.ID});
  final int? ID;
  final String? MACHINE_NO;
  final String? OPERATOR_NAME;
  final String? BATCH_NO;
  final String? PRODUCT;
  final String? PACK_NO;
  final String? PAPER_CORE;
  final String? PP_CORE;
  final String? FOIL_CORE;
  final String? BATCH_START_DATE;
  final String? BATCH_END_DATE;
  final String? FILM_SERIAL_NO;
  final String? ELEMENT;
  final String? STATUS;
  final String? START_END;
  final String? CHECK_COMPLETE;

  List<Object> get props => [
        MACHINE_NO!,
        OPERATOR_NAME!,
        BATCH_NO!,
        PRODUCT!,
        PACK_NO!,
        PAPER_CORE!,
        PP_CORE!,
        FOIL_CORE!,
        BATCH_START_DATE!,
        BATCH_END_DATE!,
        ELEMENT!,
        STATUS!,
        START_END!,
        FILM_SERIAL_NO!,
        CHECK_COMPLETE!,
      ];
  WindingSheetModel.fromMap(Map<String, dynamic> map)
      : ID = map['ID'],
        MACHINE_NO = map['MachineNo'],
        OPERATOR_NAME = map['OperatorName'],
        BATCH_NO = map['BatchNo'],
        PRODUCT = map['Product'],
        PACK_NO = map['PackNo'],
        FILM_SERIAL_NO = map['FilmSerialNo'],
        PAPER_CORE = map['PaperCore'],
        PP_CORE = map['PPCore'],
        FOIL_CORE = map['FoilCore'],
        BATCH_START_DATE = map['BatchStartDate'],
        BATCH_END_DATE = map['BatchEndDate'],
        ELEMENT = map['Element'],
        STATUS = map['Status'],
        START_END = map['start_end'],
        CHECK_COMPLETE = map['checkComplete'];
}
