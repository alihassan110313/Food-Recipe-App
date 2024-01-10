import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart' as WebViewFlutter;
import 'package:webviewx/webviewx.dart';
class RecipeView extends StatefulWidget {

  String url;
  RecipeView(this.url);
  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  late  String finalUrl;
  final Completer<WebViewFlutter.WebViewController> controller = Completer<WebViewFlutter.WebViewController>();
  @override
  void initState() {
    if(widget.url.toString().contains("http://"))
    {
      finalUrl = widget.url.toString().replaceAll("http://", "https://");
    }
    else{
      finalUrl = widget.url;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black,
        title: Text("Foodie App"),
      ),
      body: Container(
        child: WebViewFlutter.WebView(
          initialUrl: finalUrl,
          javascriptMode: WebViewFlutter.JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewFlutter.WebViewController webViewController){
            setState(() {
              controller.complete(webViewController);
            });
          },
        ),
      ),
    );
  }
}
