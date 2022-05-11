@JS()
library flgeetest;

import 'dart:async';
import 'dart:convert';
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'package:js/js.dart';
import 'dart:js_util';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'GeetestToken.dart';

@JS()
external geetest(String token);

String getGeetestJs(String token) {
  return '''
  initGeetest4({
    captchaId:  '$token',
    product: 'bind',
    language: "zho",
    riskType:'slide'
  },function (captcha) {
    captcha.onReady(function(){
      captcha.showCaptcha(); 
    }).onSuccess(function(){
      var result = captcha.getValidate();
      StarArkGeetest.postMessage(JSON.stringify({
        action: 'verify',
        token: result
      }));
    }).onError(function(err){
      StarArkGeetest.postMessage(JSON.stringify({
        action: 'error',
        error: err,
      }));
    }).onClose(function(){
      StarArkGeetest.postMessage(JSON.stringify({
        action: 'error',
        error: new Error('close'),
      }));
    });
  });
''';
}

/// A web implementation of the Flgeetest plugin.
class FlgeetestWeb {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'flgeetest',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = FlgeetestWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  /// Handles method calls over the MethodChannel of this plugin.
  /// Note: Check the "federated" architecture for a new way of doing this:
  /// https://flutter.dev/go/federated-plugins
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'check':
        print('check ${call.arguments}');
        return await check(call.arguments);
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'flgeetest for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  Future<Map> check(String token) async {
    var r = await promiseToFuture<String>(geetest(token));
    return jsonDecode(r)['token'];
  }
}
