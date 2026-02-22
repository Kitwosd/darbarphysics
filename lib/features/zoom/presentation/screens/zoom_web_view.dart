import 'package:durbar_physics/core/logger/app_logger.dart';
import 'package:durbar_physics/features/zoom/domain/use_cases/convert_zoom_url.dart';
import 'package:durbar_physics/features/zoom/presentation/controllers/zoom_webview_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ZoomWebView extends StatefulWidget {
  final String url;
  const ZoomWebView({super.key, required this.url});

  @override
  State<ZoomWebView> createState() => _ZoomWebViewState();
}

class _ZoomWebViewState extends State<ZoomWebView> {
  final ZoomWebviewController zoomController = ZoomWebviewController();

  @override
  void initState() {
    super.initState();
    logger.i(' 🚀 ZoomWebView initState');
  }

  @override
  void dispose() {
    logger.i('ZoomWebView dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final zoomUrl = convertZoomUrlToWebClient(widget.url);
    logger.i(' 🔗 Converted URL: $zoomUrl');

    return Scaffold(
      appBar: AppBar(
        title: Text('Zoom Debug'),
        actions: [
          IconButton(
            onPressed: () {
              logger.i('Manual Reload Trigger');
              zoomController.webViewController?.reload();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(zoomUrl)),
          onWebViewCreated: (controller) {
            logger.i('✅ onWebViewCreated callback');
            zoomController.setWebViewController(controller);
            zoomController.onWebViewCreated();
          },

          onLoadStart: (controller, url) {
            logger.i('▶️ onLoadStart: $url');
            setState(() {
              zoomController.onLoadStart();
            });
          },

          onProgressChanged: (controller, progress) {
            logger.d('📈 onProgressChanged: $progress%');
            setState(() {
              zoomController.onProgressChanged(progress);
            });
          },

          onLoadStop: (controller, url) async {
            logger.i('⏹️ onLoadStop: $url');

            // Check if page is interactive
            final isReady = await controller.evaluateJavascript(
              source: 'document.readyState',
            );
            logger.i('📄 Document readyState: $isReady');

            // Check for errors in DOM
            final hasErrors = await controller.evaluateJavascript(
              source: 'document.querySelector(".error, .alert") !== null',
            );
            logger.i('⚠️ Has error elements: $hasErrors');

            // Log page title
            final title = await controller.getTitle();
            logger.i('📰 Page title: $title');

            // ⬇️ ADD THIS: Inject touch event logger
            try {
              await controller.evaluateJavascript(
                source: '''
      console.log('🔧 Injecting touch listeners');
      
      ['click', 'touchstart', 'mousedown'].forEach(event => {
        document.addEventListener(event, (e) => {
          console.log('👆 ' + event + ' at (' + e.clientX + ',' + e.clientY + ')');
        }, true);
      });
    ''',
              );
              logger.i('✅ Touch listeners injected');
            } catch (e) {
              logger.e('❌ Failed to inject touch listeners: $e');
            }

            setState(() {
              zoomController.onLoadStop();
            });
          },

          onRenderProcessGone: (controller, detail) {
            logger.e('💥 onRenderProcessGone');
            zoomController.onRenderProcessGone(detail);
          },

          onReceivedError: (controller, request, error) {
            if (request.url.toString().contains('log-gateway.zoom.us')) {
              logger.w('⚠️ Ignoring Zoom analytics error (non-critical)');
              return;
            }
            logger.e('🔴 onReceivedError');
            logger.e('  isForMainFrame: ${request.isForMainFrame}');
            logger.e('  URL: ${request.url}');
            logger.e('  Type: ${error.type}');
            logger.e('  Description: ${error.description}');

            if (request.isForMainFrame == true) {
              zoomController.onLoadError(
                request.url,
                error.type.toNativeValue() ?? -1,
                error.description,
              );
            }
          },

          onReceivedHttpError: (controller, request, errorResponse) {
            logger.e('🌐 onReceivedHttpError');
            logger.e('  isForMainFrame: ${request.isForMainFrame}');
            logger.e('  URL: ${request.url}');
            logger.e('  Status Code: ${errorResponse.statusCode}');

            if (request.isForMainFrame == true) {
              zoomController.onLoadHttpError(
                request.url,
                errorResponse.statusCode ?? 0,
                errorResponse.reasonPhrase ?? 'Unknown',
              );
            }
          },

          onConsoleMessage: (controller, consoleMessage) {
            zoomController.onConsoleMessage(
              consoleMessage.message,
              consoleMessage.messageLevel.toNativeValue(),
              'Zoom',
            );
          },

          // Track all page events
          onTitleChanged: (controller, title) {
            logger.d('📝 Title changed: $title');
          },

          onUpdateVisitedHistory: (controller, url, isReload) {
            logger.d('🔄 History updated: $url (reload: $isReload)');
          },

          onPageCommitVisible: (controller, url) {
            logger.d('👁️ Page visible: $url');
          },

          // Permission requests
          onPermissionRequest: (controller, request) async {
            logger.w('🔐 Permission requested: ${request.resources}');
            return PermissionResponse(
              resources: request.resources,
              action: PermissionResponseAction.DENY,
            );
          },

          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            mediaPlaybackRequiresUserGesture: false,
            allowsInlineMediaPlayback: true,
            domStorageEnabled: true,
            useHybridComposition: false,
            hardwareAcceleration: false,

            // ⬇️ ADD THESE THREE LINES
            mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
            allowFileAccessFromFileURLs: true,
            allowUniversalAccessFromFileURLs: true,

            supportZoom: false,
            builtInZoomControls: false,
            cacheEnabled: false,
            clearCache: true,
          ),
        ),
      ),
    );
  }
}
