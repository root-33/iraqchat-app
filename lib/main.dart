import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const IraqChatApp());
}

class IraqChatApp extends StatelessWidget {
  const IraqChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'شات 1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0E1A22),
        primaryColor: const Color(0xFFD4AF37),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _requestInitialPermissions();
    _navigateToHome();
  }

  Future<void> _requestInitialPermissions() async {
    await [
      Permission.microphone,
      Permission.camera,
    ].request();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WebViewPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'logo',
              child: Image.asset(
                'assets/logo.png',
                width: 180,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.chat, size: 100, color: Color(0xFFD4AF37)),
              ),
            ),
            const SizedBox(height: 40),
            const SpinKitThreeBounce(
              color: Color(0xFFD4AF37),
              size: 30.0,
            ),
            const SizedBox(height: 20),
            const Text(
              'جاري التحميل...',
              style: TextStyle(
                color: Color(0xFFD4AF37),
                fontSize: 16,
                letterSpacing: 2,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF0E1A22))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            setState(() { _isLoading = true; });
          },
          onPageFinished: (String url) {
            setState(() { _isLoading = false; });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.iraqchat1.com/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              const Center(
                child: SpinKitFadingCircle(
                  color: Color(0xFFD4AF37),
                  size: 50.0,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
