class ResponeseWindingRecordModel {
  const ResponeseWindingRecordModel({
    this.BATCH_NO,
    this.START_DATE,
    this.END_DATE,
    this.START_TIME,
    this.FINISH_TIME,
    this.MACHINE,
    this.OPERATOR,
    this.OUTPUT,
    this.IPE_NO,
    this.THICKNESS,
    this.PACK_NO,
    this.PPM_WEIGHT,
    this.TURN,
    this.DIAMETER,
    this.CUSTOMER,
    this.UF,
    this.GROSS,
    this.WIDTHL,
    this.WIDTHR,
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
    this.BURNOFF,
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
    this.RESULT,
    this.MESSAGE,
  });

  List<Object> get props => [
        BATCH_NO!,
        START_DATE!,
        END_DATE!,
        START_TIME!,
        FINISH_TIME!,
        MACHINE!,
        OPERATOR!,
        OUTPUT!,
        IPE_NO!,
        THICKNESS!,
        PACK_NO!,
        PPM_WEIGHT!,
        TURN!,
        DIAMETER!,
        CUSTOMER!,
        UF!,
        GROSS!,
        WIDTHL!,
        WIDTHR!,
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
        BURNOFF!,
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
        RESULT!,
        MESSAGE!,
      ];
  final String? BATCH_NO;
  final String? START_DATE;
  final String? END_DATE;
  final String? START_TIME;
  final String? FINISH_TIME;
  final String? MACHINE;
  final String? OPERATOR;
  final int? OUTPUT;
  final int? IPE_NO;
  final String? THICKNESS;
  final String? PACK_NO;
  final num? PPM_WEIGHT;
  final int? TURN;
  final num? DIAMETER;
  final String? CUSTOMER;
  final num? UF;
  final num? GROSS;
  final num? WIDTHL;
  final num? WIDTHR;
  final num? CB11;
  final num? CB12;
  final num? CB13;
  final num? CB21;
  final num? CB22;
  final num? CB23;
  final num? CB31;
  final num? CB32;
  final num? CB33;
  final num? OF1;
  final num? OF2;
  final num? OF3;
  final num? BURNOFF;
  final num? FS1;
  final num? FS2;
  final num? FS3;
  final num? FS4;
  final String? GRADE;
  final num? TIME_PRESS;
  final num? TIME_RELEASED;
  final num? HEAT_TEMP;
  final int? TENSION;
  final String? NIP_ROLL_PRESS;
  final bool? RESULT;
  final String? MESSAGE;

  static ResponeseWindingRecordModel fromJson(dynamic json) {
    return ResponeseWindingRecordModel(
      BATCH_NO: json['batch_no'],
      START_DATE: json['start_date'],
      END_DATE: json['end_date'],
      START_TIME: json['start_time'],
      FINISH_TIME: json['finish_time'],
      MACHINE: json['machine'],
      OPERATOR: json['Operator'],
      OUTPUT: json['output'],
      IPE_NO: json['ipe_no'],
      THICKNESS: json['thickness'],
      PACK_NO: json['pack_no'],
      PPM_WEIGHT: json['ppm_weight'],
      TURN: json['Turn'],
      DIAMETER: json['Diameter'],
      CUSTOMER: json['Customer'],
      UF: json['UF'],
      GROSS: json['Gross'],
      WIDTHL: json['WidthL'],
      WIDTHR: json['WidthR'],
      CB11: json['CB11'],
      CB12: json['CB12'],
      CB13: json['CB13'],
      CB21: json['CB21'],
      CB22: json['CB22'],
      CB23: json['CB23'],
      CB31: json['CB31'],
      CB32: json['CB32'],
      CB33: json['CB33'],
      OF1: json['OF1'],
      OF2: json['OF2'],
      OF3: json['OF3'],
      BURNOFF: json['Burnoff'],
      FS1: json['FS1'],
      FS2: json['FS2'],
      FS3: json['FS3'],
      FS4: json['FS4'],
      GRADE: json['Grade'],
      TIME_PRESS: json['Time_Press'],
      TIME_RELEASED: json['Time_Released'],
      HEAT_TEMP: json['Heat_temp'],
      TENSION: json['Tension'],
      NIP_ROLL_PRESS: json['Nip_roll_press'],
      RESULT: json['result'],
      MESSAGE: json['message'],
    );
  }

  Map toJson() => {
        'batch_no': BATCH_NO,
        'start_date': START_DATE,
        'end_date': END_DATE,
        'start_time': START_TIME,
        'finish_time': FINISH_TIME,
        'machine': MACHINE,
        'Operator': OPERATOR,
        'output': OUTPUT,
        'ipe_no': IPE_NO,
        'thickness': THICKNESS,
        'pack_no': PACK_NO,
        'ppm_weight': PPM_WEIGHT,
        'Turn': TURN,
        'Diameter': DIAMETER,
        'Customer': CUSTOMER,
        'UF': UF,
        'Gross': GROSS,
        'WidthL': WIDTHL,
        'WidthR': WIDTHR,
        'CB11': CB11,
        'CB12': CB12,
        'CB13': CB13,
        'CB21': CB21,
        'CB22': CB22,
        'CB23': CB23,
        'CB31': CB31,
        'CB32': CB32,
        'CB33': CB33,
        'OF1': OF1,
        'OF2': OF2,
        'OF3': OF3,
        'Burnoff': BURNOFF,
        'FS1': FS1,
        'FS2': FS2,
        'FS3': FS3,
        'FS4': FS4,
        'Grade': GRADE,
        'Time_Press': TIME_PRESS,
        'Time_Released': TIME_RELEASED,
        'Heat_temp': HEAT_TEMP,
        'Tension': TENSION,
        'Nip_roll_press': NIP_ROLL_PRESS,
        'result': RESULT,
        'message': MESSAGE
      };
}
