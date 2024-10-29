import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'utils.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arcade Arena',
      debugShowCheckedModeBanner: false,
      theme: buildThemeData(),
      home: const MyAboutPage(title: 'Arcade Arena'),
    );
  }
}

class MyAboutPage extends StatefulWidget {
  const MyAboutPage({super.key, required this.title});

  final String title;

  @override
  State<MyAboutPage> createState() => _MyAboutPageState();
}

class _MyAboutPageState extends State<MyAboutPage> {
  final Pages currentPage = Pages.about;

  final WebViewController controller = WebViewController()
    ..loadFlutterAsset("assets/documentation/index.html")
    ..setNavigationDelegate(
      NavigationDelegate(
        onNavigationRequest: (NavigationRequest request) {
          // Open external links in browser
          if (request.url.startsWith('file:')) {
            return NavigationDecision.navigate;
          }
          launchUrl(Uri.parse(request.url));
          return NavigationDecision.prevent;
        },
      )
    );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, currentPage),
      body: WebViewWidget(
        controller: controller,
      ),
      bottomNavigationBar: buildBottomNav(context, currentPage),
    );
  }
}
