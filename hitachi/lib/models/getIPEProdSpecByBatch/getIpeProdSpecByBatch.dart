class GetIPEProdSpecByBatchModel {
  const GetIPEProdSpecByBatchModel({
    this.BATCH_NO,
    this.IPE_NO,
    this.I_PEAK,
    this.HIGH_VOLT,
    this.CLEARING,
  });
  final String? BATCH_NO;
  final String? IPE_NO;
  final String? I_PEAK;
  final String? HIGH_VOLT;
  final String? CLEARING;

  List<Object> get props => [
        BATCH_NO!,
        IPE_NO!,
        I_PEAK!,
        HIGH_VOLT!,
        CLEARING!,
      ];

  static GetIPEProdSpecByBatchModel fromJson(dynamic json) {
    return GetIPEProdSpecByBatchModel(
      BATCH_NO: json['BatchNo'],
      IPE_NO: json['IpeNo'],
      I_PEAK: json['Ipeak'],
      HIGH_VOLT: json['HighVolt'],
      CLEARING: json['Clearing'],
    );
  }
}
