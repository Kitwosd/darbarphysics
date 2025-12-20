import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:durbar_physics/common/widgets/button_widget.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class BasicWebviewScreen extends StatefulWidget {
  final String url;
  const BasicWebviewScreen({super.key, required this.url});

  @override
  State<BasicWebviewScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<BasicWebviewScreen> {
  InAppWebViewController? webViewController;
  bool isLoading = true;
  double progress = 0;
  bool isWebViewError = false;
  bool isConnectivityError = false;
  String errorMessage = '';
  Timer? loadingTimer;
  final int timeoutSeconds = 40;

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool isOnline = true;

  @override
  void initState() {
    super.initState();
    _requestPermissionOSLevel();
    _setupConnectivityStatus();

    //prevent screen from turning off during live classes
    WakelockPlus.enable();

    //allow landscape and portrait both
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    WakelockPlus.disable();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    loadingTimer?.cancel();

    _connectivitySubscription.cancel();
  }

  Future<void> _requestPermissionOSLevel() async {
    await [Permission.camera, Permission.microphone].request();
  }

  String _convertToWebClientUrl(String url) {
    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments;
    String? meetingId;

    for (int i = 0; i < pathSegments.length; i++) {
      if (pathSegments[i] == 'j' && i + 1 < pathSegments.length) {
        meetingId = pathSegments[i + 1];
        break;
      }
    }
    if (meetingId != null) {
      String webClientUrl = 'https://app.zoom.us/wc/join/$meetingId';
      if (uri.queryParameters.containsKey('pwd')) {
        webClientUrl += '?pwd=${uri.queryParameters['pwd']}';
      }
      return webClientUrl;
    }
    return url;
  }

  void _retryLoading() async {
    bool online = await checkInternet();
    if (!online) {
      setState(() {
        isConnectivityError = true;
        isWebViewError = false;
        isLoading = false;
        errorMessage = 'No internet Connection';
      });
      return;
    }

    setState(() {
      isConnectivityError = false;
      isWebViewError = false;

      isLoading = true;
      progress = 0;
    });

    webViewController?.reload();
  }

  String getLoadingState() {
    if (progress < 0.3) {
      return 'Connecting to the meeting';
    } else if (progress < 0.7) {
      return 'Loading meeting, Almost there';
    } else {
      return 'Almost there';
    }
  }

  Future<bool> checkInternet() async {
    final results = await Connectivity().checkConnectivity();
    return results.any((result) => result != ConnectivityResult.none);
  }

  void _setupConnectivityStatus() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      resultList,
    ) {
      final online = resultList.any((r) => r != ConnectivityResult.none);
      setState(() {
        isOnline = online;

        if (!isOnline) {
          isConnectivityError = true;
          isWebViewError = false;
          errorMessage = 'No internet connection';
          isLoading = false;
        } else if (isConnectivityError) {
          // Automatically retry if connection comes back
          _retryLoading();
        }
      });
    });
  }

  // ✅ HELPER: unified check to show error overlay
  bool get showError => isWebViewError || isConnectivityError;

  @override
  Widget build(BuildContext context) {
    if (showError) {
      log('The error is this : $errorMessage');
    }
    final zoomLink = _convertToWebClientUrl(widget.url);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(zoomLink)),

              //this is the controller that gives us the control of webview
              onWebViewCreated: (controller) {
                webViewController = controller;
              },

              initialSettings: InAppWebViewSettings(
                javaScriptEnabled:
                    true, //yo nagarey if default js isnot enabled then shows only white screen
                mediaPlaybackRequiresUserGesture:
                    true, // rightnow no bugs for on other devices manual clicking may require so
                allowsInlineMediaPlayback: true, // same as before
                domStorageEnabled:
                    true, // zoom stores meeting tokens, session state -> prevents reload loop
                useHybridComposition: true, // same as before
                cacheEnabled: true, //improves -> reload speed, less cpu usage
              ),

              //imp methods if you wanna show and all
              onLoadStart: (controller, url) {
                setState(() {
                  isLoading = true;
                  isWebViewError = false;
                  isConnectivityError = false;
                });
                loadingTimer?.cancel();

                loadingTimer = Timer(Duration(seconds: timeoutSeconds), () {
                  if (mounted && isLoading) {
                    setState(() {
                      isWebViewError = true;
                      errorMessage =
                          'Connection timeout. Please check your internet and retry.';
                      isLoading = false;
                    });
                    controller.stopLoading();
                  }
                });

                // working on timer to not let user stuck on the loading page infinitely due to webRTC handshake
              },
              onLoadStop: (controller, url) {
                loadingTimer?.cancel();

                setState(() {
                  isLoading = false;
                });
                // setState(() {
                //   if (isConnectivityError && !isWebViewError) {
                //     isLoading = false;
                //   }
                // });
              },
              onProgressChanged: (controller, progressPercent) => {
                setState(() {
                  progress = progressPercent / 100;
                }),
              },

              onReceivedHttpError: (controller, request, errorResponse) {
                log(
                  'HTTP Error: ${errorResponse.statusCode} (isForMainFrame: ${request.isForMainFrame})',
                );
                // Only handle main frame HTTP errors
                if (request.isForMainFrame != true) {
                  return;
                }

                // Only show error for serious HTTP errors (4xx, 5xx)
                final statusCode = errorResponse.statusCode;

                if (statusCode != null && statusCode >= 400) {
                  setState(() {
                    isConnectivityError = true;
                    errorMessage = 'HTTP error: ${errorResponse.statusCode}';
                    isLoading = false;
                  });
                  loadingTimer?.cancel();
                }
                return;
              },

              //Fix: Only handle MainFrame erros, ignore subresources
              onReceivedError: (controller, request, error) {
                // added later to see what will happen to check network error specifically

                //log all the erros for debugging
                log(
                  'WebView Error: ${error.description} (isForMainFrame: ${request.isForMainFrame})',
                );

                //only show error UI for MAIN FRAME failures
                if (request.isForMainFrame != true) {
                  log('Ignoring subresources error');
                  return; // Ignore errors form subresources like images, scripts etc.
                }
                //check if it's a critical network error on main frame
                final isNetworkError =
                    error.type == WebResourceErrorType.HOST_LOOKUP ||
                    error.type == WebResourceErrorType.CONNECTION_ABORTED ||
                    error.type == WebResourceErrorType.TIMEOUT;
                setState(() {
                  isConnectivityError = true;
                  if (isNetworkError) {
                    errorMessage = 'Network connection failed';
                  } else {
                    errorMessage = 'Web Error: ${error.description}';
                  }
                  isLoading = false;
                });
                loadingTimer?.cancel();
              },

              //granting permission if asked to webview
              onPermissionRequest: (controller, request) async {
                return PermissionResponse(
                  resources: request.resources,
                  action: PermissionResponseAction.GRANT,
                );
              },

              shouldOverrideUrlLoading: (controller, navigationAction) async {
                final url = navigationAction.request.url.toString();

                if (url.startsWith('zoommtg://') ||
                    url.startsWith('zoomus://') ||
                    url.startsWith('intent://')) {
                  return NavigationActionPolicy.CANCEL;
                }

                return NavigationActionPolicy.ALLOW;
              },
            ),
            if (isLoading && !showError && progress < 1.0)
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        appColors.primary,
                      ),
                      minHeight: 3.h,
                    ),

                    if (progress < 0.5)
                      Container(
                        color: Colors.white.withValues(alpha: 0.9),
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 16.w,
                              height: 16.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  appColors.primary,
                                ),
                              ),
                            ),
                            12.verticalSpace,
                            TextWidget(
                              word: 'Connecting to meeting... ',
                              size: 14,
                              weight: FontWeight.w500,
                              textColor: Colors.grey.shade700,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            if (isLoading && !showError)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        appColors.primary,
                      ),
                      minHeight: 3,
                    ),
                    // Optional: subtle loading text (can be removed)
                    if (progress < 0.5)
                      Container(
                        color: Colors.white.withValues(alpha: 0.9),
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 16.w,
                              height: 16.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  appColors.primary,
                                ),
                              ),
                            ),
                            12.horizontalSpace,
                            TextWidget(
                              word: 'Connecting to meeting...',
                              size: 14,
                              weight: FontWeight.w500,
                              textColor: Colors.grey.shade700,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

            // ✅ Clean error overlay
            if (showError)
              Container(
                color: Colors.white,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Error icon with animation
                        Container(
                          padding: EdgeInsets.all(20.r),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isConnectivityError
                                ? Icons.wifi_off
                                : Icons.error_outline,
                            size: 64.sp,
                            color: Colors.red.shade400,
                          ),
                        ),

                        32.verticalSpace,

                        // Error title
                        TextWidget(
                          word: isConnectivityError
                              ? 'No Internet Connection'
                              : 'Connection Failed',
                          weight: FontWeight.w700,
                          size: 22,
                          textColor: Colors.grey.shade900,
                        ),

                        12.verticalSpace,

                        // Error message
                        TextWidget(
                          word: errorMessage,
                          textColor: Colors.grey.shade600,
                          size: 15,
                          align: TextAlign.center,
                        ),

                        40.verticalSpace,

                        // Retry button
                        ButtonWidget(
                          width: double.infinity,
                          height: 50.h,
                          textWidget: TextWidget(
                            word: 'Try Again',
                            weight: FontWeight.w600,
                            size: 16,
                            textColor: Colors.white,
                          ),
                          onPressed: _retryLoading,
                        ),

                        16.verticalSpace,

                        // Close button
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: TextWidget(
                            word: 'Go Back',
                            size: 15,
                            weight: FontWeight.w500,
                            textColor: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
