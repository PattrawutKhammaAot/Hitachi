class ProcessCheckModel {
  const ProcessCheckModel({
    this.BATCH_NO,
    this.IPE_NO,
    this.MC_NO,
    this.ZN_Thickness,
    this.ZN_VC,
    this.CR_VC,
    this.CR_Voltage,
    this.SD_VC,
    this.TM_Curve,
    this.TM_Time,
    this.PU_Ratio,
    this.PU_Level,
    this.HV_Peak_Current,
    this.HV_HighVolt,
    this.ME_C_AVG,
    this.ME_TGD_AVG,
    this.ME_Batch,
    this.ME_Serial,
    this.ME_Appearance,
    this.ME_Quality_Check,
  });

  final String? BATCH_NO;
  final int? IPE_NO;
  final String? MC_NO;
  final num? ZN_Thickness;
  final String? ZN_VC;
  final String? CR_VC;
  final int? CR_Voltage;
  final String? SD_VC;
  final String? TM_Curve;
  final String? TM_Time;
  final String? PU_Ratio;
  final String? PU_Level;
  final int? HV_Peak_Current;
  final int? HV_HighVolt;
  final num? ME_C_AVG;
  final num? ME_TGD_AVG;
  final String? ME_Batch;
  final String? ME_Serial;
  final String? ME_Appearance;
  final String? ME_Quality_Check;

  ProcessCheckModel copyWith({
    String? BATCH_NO,
    int? IPE_NO,
    String? MC_NO,
    num? ZN_Thickness,
    String? ZN_VC,
    String? CR_VC,
    int? CR_Voltage,
    String? SD_VC,
    String? TM_Curve,
    String? TM_Time,
    String? PU_Ratio,
    String? PU_Level,
    int? HV_Peak_Current,
    int? HV_HighVolt,
    num? ME_C_AVG,
    num? ME_TGD_AVG,
    String? ME_Batch,
    String? ME_Serial,
    String? ME_Appearance,
    String? ME_Quality_Check,
  }) {
    return ProcessCheckModel(
      BATCH_NO: BATCH_NO ?? this.BATCH_NO,
      IPE_NO: IPE_NO ?? this.IPE_NO,
      MC_NO: MC_NO ?? this.MC_NO,
      ZN_Thickness: ZN_Thickness ?? this.ZN_Thickness,
      ZN_VC: ZN_VC ?? this.ZN_VC,
      CR_VC: CR_VC ?? this.CR_VC,
      CR_Voltage: CR_Voltage ?? this.CR_Voltage,
      SD_VC: SD_VC ?? this.SD_VC,
      TM_Curve: TM_Curve ?? this.TM_Curve,
      TM_Time: TM_Time ?? this.TM_Time,
      PU_Ratio: PU_Ratio ?? this.PU_Ratio,
      PU_Level: PU_Level ?? this.PU_Level,
      HV_Peak_Current: HV_Peak_Current ?? this.HV_Peak_Current,
      HV_HighVolt: HV_HighVolt ?? this.HV_HighVolt,
      ME_C_AVG: ME_C_AVG ?? this.ME_C_AVG,
      ME_TGD_AVG: ME_TGD_AVG ?? this.ME_TGD_AVG,
      ME_Batch: ME_Batch ?? this.ME_Batch,
      ME_Serial: ME_Serial ?? this.ME_Serial,
      ME_Appearance: ME_Appearance ?? this.ME_Appearance,
      ME_Quality_Check: ME_Quality_Check ?? this.ME_Quality_Check,
    );
  }

  @override
  Map toJson() => {
        'BATCH_NO': BATCH_NO,
        'IPE_NO': IPE_NO,
        'MC_NO': MC_NO,
        'ZN_Thickness': ZN_Thickness,
        'ZN_VC': ZN_VC,
        'CR_VC': CR_VC,
        'CR_Voltage': CR_Voltage,
        'SD_VC': SD_VC,
        'TM_Curve': TM_Curve,
        'TM_Time': TM_Time,
        'PU_Ratio': PU_Ratio,
        'PU_Level': PU_Level,
        'HV_Peak_Current': HV_Peak_Current,
        'HV_HighVolt': HV_HighVolt,
        'ME_C_AVG': ME_C_AVG,
        'ME_TGD_AVG': ME_TGD_AVG,
        'ME_Batch': ME_Batch,
        'ME_Serial': ME_Serial,
        'ME_Appearance': ME_Appearance,
        'ME_Quality_Check': ME_Quality_Check,
      };
}
