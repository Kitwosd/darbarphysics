import 'package:durbar_physics/core/logger/app_logger.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ZoomWebviewController {
  InAppWebViewController? webViewController;
  bool isLoading = true;
  double progress = 0;

  ZoomWebviewController();

  void setWebViewController(InAppWebViewController controller) {
    logger.d('🎮 WebView Controller Set');
    webViewController = controller;
  }

  void onLoadStart() {
    logger.d('🟢 Load Start');
    isLoading = true;
    progress = 0;
  }

  void onProgressChanged(int progressPercent) {
    progress = progressPercent / 100;
    logger.d('📊 Progress: $progressPercent%');
  }

  void onLoadStop() {
    logger.d('🏁 Load Stop');
    isLoading = false;
  }

  void onRenderProcessGone(RenderProcessGoneDetail detail) {
    logger.e('💥 RENDER PROCESS CRASHED');
    logger.e('didCrash: ${detail.didCrash}');
    logger.e('rendererPriorityAtExit: ${detail.rendererPriorityAtExit}');
  }

  void onWebViewCreated() {
    logger.i('🌐 WebView Created Successfully');
  }

  void onLoadError(Uri? url, int code, String message) {
    logger.e('❌ Load Error:');
    logger.e('  URL: $url');
    logger.e('  Code: $code');
    logger.e('  Message: $message');
  }

  void onLoadHttpError(Uri? url, int statusCode, String description) {
    logger.e('🌐 HTTP Error:');
    logger.e('  URL: $url');
    logger.e('  Status: $statusCode');
    logger.e('  Description: $description');
  }

  void onConsoleMessage(String message, int lineNumber, String sourceId) {
    logger.w('📱 JS Console:');
    logger.w('  Message: $message');
    logger.w('  Line: $lineNumber');
    logger.w('  Source: $sourceId');
  }
}
