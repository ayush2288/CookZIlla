import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeView extends StatefulWidget {
  final String url;
  RecipeView(this.url);

  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  late String finalUrl;
  final Completer<WebViewController> controller = Completer<WebViewController>();
  bool isLoading = true;

  @override
  void initState() {
    if (widget.url.startsWith("http://")) {
      finalUrl = widget.url.replaceFirst("http://", "https://");
    } else {
      finalUrl = widget.url;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Food Recipe App"),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              shareRecipe(widget.url);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
         WebView(
  initialUrl: finalUrl,
  javascriptMode: JavascriptMode.unrestricted,
  onWebViewCreated: (WebViewController webViewController) {
    setState(() {
      controller.complete(webViewController);
    });
  },
  onPageFinished: (String url) {
    setState(() {
      isLoading = false;
    });
  },
  navigationDelegate: (NavigationRequest request) {
    // Load the URL within the WebView
    if (request.url.startsWith('http') || request.url.startsWith('https')) {
      return NavigationDecision.navigate;
    } else {
      // Prevent all other URLs from being opened
      return NavigationDecision.prevent;
    }
  },
),

          if (isLoading)
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(const Color.fromARGB(255, 43, 43, 43)),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> shareRecipe(String recipeUrl) async {
    try {
      await Share.share(recipeUrl);  // Use Share from share_plus directly
    } catch (e) {
      print('Error sharing URL: $e');
    }
  }
}
