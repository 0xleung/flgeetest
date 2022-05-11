class GeetestToken {
  GeetestToken({
    required this.captchaId,
    required this.lotNumber,
    required this.passToken,
    required this.genTime,
    required this.captchaOutput,
  });
  final String captchaId;
  final String lotNumber;
  final String passToken;
  final String genTime;
  final String captchaOutput;
  static GeetestToken fromJson(dynamic json) {
    return GeetestToken(
      captchaId: json['captcha_id'] as String,
      lotNumber: json['lot_number'] as String,
      passToken: json['pass_token'] as String,
      genTime: json['gen_time'] as String,
      captchaOutput: json['captcha_output'] as String,
    );
  }

  Map<String, String> toMap() {
    return {
      'captcha_id': captchaId,
      'lot_number': lotNumber,
      'pass_token': passToken,
      'gen_time': genTime,
      'captcha_output': captchaOutput,
    };
  }
}
