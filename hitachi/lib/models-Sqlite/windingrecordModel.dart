class WindingRecordModel {
  const WindingRecordModel(
      {this.BATCH_NO,
      this.START_TIME,
      this.FINISH_TIME,
      this.IPE_NO,
      this.THICKNESS,
      this.TURN,
      this.DIAMETER,
      this.CUSTOMER,
      this.UF,
      this.PPM_WEIGHT,
      this.PACK_NO,
      this.OUTPUT,
      this.GROSS,
      this.WIDTH_L,
      this.WIDHT_R,
      this.CB11,
      this.CB12,
      this.CB13,
      this.CB21,
      this.CB22,
      this.CB23,
      this.CB31,
      this.CB32,
      this.CB33,
      this.OF1,
      this.OF2,
      this.OF3,
      this.BURN_OFF,
      this.FS1,
      this.FS2,
      this.FS3,
      this.FS4,
      this.GRADE,
      this.TIME_PRESS,
      this.TIME_RELEASED,
      this.HEAT_TEMP,
      this.TENSION,
      this.NIP_ROLL_PRESS,
      this.CheckComplete,
      this.ID});
  final int? ID;
  final String? BATCH_NO;
  final String? START_TIME;
  final String? FINISH_TIME;
  final String? IPE_NO;
  final String? THICKNESS;
  final String? TURN;
  final String? DIAMETER;
  final String? CUSTOMER;
  final String? UF;
  final String? PPM_WEIGHT;
  final String? PACK_NO;
  final String? OUTPUT;
  final String? GROSS;
  final String? WIDTH_L;
  final String? WIDHT_R;
  final String? CB11;
  final String? CB12;
  final String? CB13;
  final String? CB21;
  final String? CB22;
  final String? CB23;
  final String? CB31;
  final String? CB32;
  final String? CB33;
  final String? OF1;
  final String? OF2;
  final String? OF3;
  final String? BURN_OFF;
  final String? FS1;
  final String? FS2;
  final String? FS3;
  final String? FS4;
  final String? GRADE;
  final String? TIME_PRESS;
  final String? TIME_RELEASED;
  final String? HEAT_TEMP;
  final String? TENSION;
  final String? NIP_ROLL_PRESS;
  final String? CheckComplete;
  List<Object> get props => [
        ID!,
        BATCH_NO!,
        START_TIME!,
        FINISH_TIME!,
        IPE_NO!,
        THICKNESS!,
        TURN!,
        DIAMETER!,
        CUSTOMER!,
        UF!,
        PPM_WEIGHT!,
        PACK_NO!,
        OUTPUT!,
        GROSS!,
        WIDTH_L!,
        WIDHT_R!,
        CB11!,
        CB12!,
        CB13!,
        CB21!,
        CB22!,
        CB23!,
        CB31!,
        CB32!,
        CB33!,
        OF1!,
        OF2!,
        OF3!,
        BURN_OFF!,
        FS1!,
        FS2!,
        FS3!,
        FS4!,
        GRADE!,
        TIME_PRESS!,
        TIME_RELEASED!,
        HEAT_TEMP!,
        TENSION!,
        NIP_ROLL_PRESS!,
        CheckComplete!,
      ];
  WindingRecordModel.fromMap(Map<String, dynamic> map)
      : ID = map['ID'],
        BATCH_NO = map['BATCH_NO'],
        START_TIME = map['START_TIME'],
        FINISH_TIME = map['FINISH_TIME'],
        IPE_NO = map['IPENO'],
        THICKNESS = map['THICKNESS'],
        TURN = map['TURN'],
        DIAMETER = map['DIAMETER'],
        CUSTOMER = map['CUSTOMER'],
        UF = map['UF'],
        PPM_WEIGHT = map['PPM_WEIGHT'],
        PACK_NO = map['PACK_NO'],
        OUTPUT = map['OUTPUT'],
        GROSS = map['GROSS'],
        WIDTH_L = map['WIDTH_L'],
        WIDHT_R = map['WIDHT_R'],
        CB11 = map['CB11'],
        CB12 = map['CB12'],
        CB13 = map['CB13'],
        CB21 = map['CB21'],
        CB22 = map['CB22'],
        CB23 = map['CB23'],
        CB31 = map['CB31'],
        CB32 = map['CB32'],
        CB33 = map['CB33'],
        OF1 = map['OF1'],
        OF2 = map['OF2'],
        OF3 = map['OF3'],
        BURN_OFF = map['Burnoff'],
        FS1 = map['FS1'],
        FS2 = map['FS2'],
        FS3 = map['FS3'],
        FS4 = map['FS4'],
        GRADE = map['GRADE'],
        TIME_PRESS = map['TIME_RESS'],
        TIME_RELEASED = map['TIME_RELEASED'],
        HEAT_TEMP = map['HEAT_TEMP'],
        TENSION = map['TENSION'],
        NIP_ROLL_PRESS = map['NIP_ROLL_PRESS'],
        CheckComplete = map['CheckComplete'];
}
