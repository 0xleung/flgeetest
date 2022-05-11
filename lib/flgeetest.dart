import 'dart:async';

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'GeetestToken.dart';

export 'GeetestToken.dart';

class GeetestPage extends StatefulWidget {
  const GeetestPage({Key? key, required this.token}) : super(key: key);
  final String token;

  @override
  State<GeetestPage> createState() => _GeetestPageState();
}

class _GeetestPageState extends State<GeetestPage> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  late WebViewController _controller;
  bool isShowLoading = true;

  @override
  Widget build(BuildContext context) {
    // 714ae136a3e16a0808e7d569290734d6
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          WebView(
            javascriptMode: JavascriptMode.unrestricted,
            javascriptChannels: {
              JavascriptChannel(
                  name: 'StarArkGeetest',
                  onMessageReceived: (message) {
                    Navigator.of(context).pop(message.message);
                  }),
            },
            backgroundColor: const Color(0x00000000),
            initialUrl: 'https://h5.stararknft.art/static/geetest4.html',
            onWebViewCreated: (WebViewController webViewController) =>
                _controller = webViewController,
            onPageFinished: (_) {
              setState(() {
                isShowLoading = false;
              });
              _controller.runJavascript(getGeetestJs(widget.token));
            },
          ),
          isShowLoading
              ? const SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

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

class Flgeetest {
  static const MethodChannel _channel = MethodChannel('flgeetest');

  Future<GeetestToken> check(BuildContext context, String token) async {
    if (kIsWeb) {
      var _token = await _channel.invokeMethod('check', token);

      return GeetestToken.fromJson(_token);
    }
    // String? rst = await Navigator.of(context).push<String>(
    //   MaterialPageRoute(
    //     builder: (context) => GeetestPage(
    //       token: token,
    //     ),
    //   ),
    // );
    String? rst = await showCheck(context, token);
    return GeetestToken.fromJson(json.decode(rst ?? '')['token']);
  }

  showCheck(BuildContext context, String token) async {
    String? rst = await showGeneralDialog<String>(
      context: context,
      barrierDismissible: false,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return SizedBox(
          child: GeetestPage(
            token: token,
          ),
          width: double.infinity,
          height: double.infinity,
        );
      },
    );
    return rst;
  }
}
