import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../bloc/zoom_bloc.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// PUBLIC entry point — wraps everything in a BlocProvider
// ═══════════════════════════════════════════════════════════════════════════════
class ZoomWebViewPage extends StatelessWidget {
  final String zoomUrl;

  const ZoomWebViewPage({super.key, required this.zoomUrl});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Create the bloc and immediately fire the initialise event
      create: (_) => ZoomBloc()..add(InitializeZoomEvent(zoomUrl)),
      child: const _ZoomWebViewView(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// PRIVATE stateful widget — owns the InAppWebViewController reference
// ═══════════════════════════════════════════════════════════════════════════════
class _ZoomWebViewView extends StatefulWidget {
  const _ZoomWebViewView();

  @override
  State<_ZoomWebViewView> createState() => _ZoomWebViewViewState();
}

class _ZoomWebViewViewState extends State<_ZoomWebViewView> {
  InAppWebViewController? _webViewController;

  // ─── URL patterns that indicate the meeting has ended ───────────────────────
  // Confirmed from debug logs: Zoom navigates to /wc/leave when user clicks "Leave"
  // *Dev* - So yo chai incase use le leave garda, or meet end huda Zoom le redirect garne pages hun, but we don't want that to happen
  // So if the web page is directly to these endpoints we make the user go back to the live detail class or form where they joined.
  static const _postMeetingPatterns = [
    '/wc/leave', // ← Confirmed: fired by shouldOverrideUrlLoading on leave
    'zoom.us/postattendee', // Safety net: post-meeting summary page
    '/wc/goodbye', // Safety net: explicit goodbye route
    'zoom.us/wc/leave', // Standard leave
    'app.zoom.us/wc', // Confirmed in your latest logs
    'zoom.us/wc?meetingNumber', // Catching the query param version
    'feedback=', // Strong indicator of meeting end
    'postattendee', // Thank you page
    'postmeeting', // Custom survey page
    '/wc/goodbye', // Legacy cleanup
  ];

  /// Returns true when the navigated URL is a Zoom post-meeting/promo page.
  bool _isPostMeetingUrl(String url) {
    // Still inside the active web-client session → not done
    if (url.contains('/wc/join/') || url.contains('/wc/meeting/')) return false;
    return _postMeetingPatterns.any((p) => url.contains(p));
  }

  // ─── Trigger Zoom's own Leave button via JS ───────────────────────────────
  // We click Zoom's own toolbar "Leave" button → Zoom signals the server →
  // Zoom navigates to /wc/leave → our onLoadStart catches it → auto-pop.
  // This ensures the server knows the participant left (not just a Flutter pop).

  //*Dev* So yo chai hamle le js ko use garerw user le back garda pani pop up dekhaunu paryo if they wanna leave or what ?
  // So tyo garda just navigator.pop garey 5 min ghost participant vayerw yo id rakhirakhxa zoom le thinking the use accidently went off or lost connectino
  // So hamle js use garerw if user clicks leave on popup, we press the leave button ourselves.
  Future<void> _triggerZoomLeaveButton() async {
    if (_webViewController == null) return;
    await _webViewController!.evaluateJavascript(
      source: '''
      (function() {
        // Step 1: Click Zoom's toolbar "Leave" button
        
        var leaveBtn = 
        document.querySelector('.meeting-header__leave-btn') || // Target the specific class you found
        document.querySelector('[aria-label="Leave"]') || 
        document.querySelector('.zm-btn--error'); // Zoom usually colors the leave button with this error class
        if (leaveBtn) {
          leaveBtn.click();
        } else {
          return; // Button not found – timeout fallback will handle
        }

        // Step 2: After Zoom shows its own leave-confirmation dialog,
        // click "Leave Meeting" (not "End Meeting for All")
        setTimeout(function() {
          var buttons = document.querySelectorAll("button, [role='button']");
          for (var i = 0; i < buttons.length; i++) {
            var txt = (buttons[i].innerText || buttons[i].textContent).trim();
            if (txt === "Leave Meeting" || txt === "Leave meeting") {
              buttons[i].click();
              break;
            }
          }
        }, 800);
      })();
    ''',
    );
  }

  // ─── Confirmation dialog for accidental back presses ────────────────────────
  Future<bool> _confirmExit() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Leave Meeting?'),
        content: const Text(
          'You are still in the meeting. Do you want to leave?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false), // Stay
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true), // Leave
            child: const Text('Leave', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // ─── Exit meeting via Zoom's own leave flow (back-button path) ─────────────
  // We do NOT pop immediately. Instead we trigger Zoom's own leave button,
  // which makes Zoom notify its server, then navigate to /wc/leave,
  // which our onLoadStart catches → ZoomMeetingEndedEvent → auto-pop.
  // A timeout ensures the user is never stuck if JS fails.
  void _exitMeetingViaZoomLeave() {
    _triggerZoomLeaveButton();

    // Fallback: if Zoom hasn't navigated away within 8 seconds, force pop.
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  // ═══════════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return PopScope(
      // canPop: false  →  we intercept every back gesture so we can confirm
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return; // Already handled elsewhere

        final shouldLeave = await _confirmExit();
        if (shouldLeave && mounted) {
          // Trigger Zoom's own leave button → server is notified → /wc/leave fires → auto-pop
          _exitMeetingViaZoomLeave();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocListener<ZoomBloc, ZoomState>(
            // Only react to meaningful state changes (not progress ticks)
            listenWhen: (prev, curr) =>
                prev.status != curr.status || prev.webUrl != curr.webUrl,
            listener: (context, state) async {
              // Load the processed Web-Client URL once the BLoC is ready
              if (state.status == ZoomStatus.success &&
                  state.webUrl.isNotEmpty &&
                  _webViewController != null) {
                await _webViewController!.loadUrl(
                  urlRequest: URLRequest(url: WebUri(state.webUrl)),
                );
              }

              // meetingEnded is fired when /wc/leave is detected by onLoadStart
              // or shouldOverrideUrlLoading. Just pop — Zoom already notified the server.
              if (state.status == ZoomStatus.meetingEnded && mounted) {
                Navigator.of(context).pop();
              }
            },
            child: Stack(
              children: [
                // ── 1. WebView — always in the widget tree ──────────────────
                _buildWebView(context),

                // ── 2. Loading overlay ───────────────────────────────────────
                BlocBuilder<ZoomBloc, ZoomState>(
                  // Only rebuild for loading / progress changes
                  buildWhen: (prev, curr) =>
                      prev.status != curr.status ||
                      prev.progress != curr.progress,
                  builder: (context, state) {
                    final showLoading =
                        state.status == ZoomStatus.loading ||
                        (state.status == ZoomStatus.success &&
                            state.progress < 1.0);
                    if (!showLoading) return const SizedBox.shrink();
                    return _buildLoading(state.progress);
                  },
                ),

                // ── 3. Error overlay ─────────────────────────────────────────
                BlocBuilder<ZoomBloc, ZoomState>(
                  buildWhen: (prev, curr) => prev.status != curr.status,
                  builder: (context, state) {
                    final isError =
                        state.status == ZoomStatus.error ||
                        state.status == ZoomStatus.connectivityError;
                    if (!isError) return const SizedBox.shrink();
                    return _buildError(context, state.errorMessage);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Widget helpers
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildWebView(BuildContext context) {
    return InAppWebView(
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        mediaPlaybackRequiresUserGesture: false, // Auto-play mic/camera streams
        allowsInlineMediaPlayback: true,
        domStorageEnabled: true, // Zoom caches session tokens here
        useHybridComposition: true, // Fixes keyboard/input on Android
        hardwareAcceleration: true,
        userAgent:
            'Mozilla/5.0 (Linux; Android 10; Mobile; rv:89.0) Gecko/89.0 Firefox/89.0',
      ),
      onWebViewCreated: (controller) {
        _webViewController = controller;
        // BLoC may have already resolved the URL before the WebView was ready
        final state = context.read<ZoomBloc>().state;
        if (state.status == ZoomStatus.success && state.webUrl.isNotEmpty) {
          controller.loadUrl(urlRequest: URLRequest(url: WebUri(state.webUrl)));
        }
      },
      onLoadStart: (controller, url) {
        // Safety net: catches JS-triggered navigations that bypass shouldOverrideUrlLoading
        if (url != null && _isPostMeetingUrl(url.toString())) {
          context.read<ZoomBloc>().add(ZoomMeetingEndedEvent());
          controller.stopLoading();
        }
      },
      onProgressChanged: (_, progress) {
        context.read<ZoomBloc>().add(ZoomProgressUpdated(progress / 100));
      },
      onReceivedError: (_, request, error) {
        // Only show error UI for main-frame failures (ignore sub-resource errors)
        if (request.isForMainFrame ?? true) {
          context.read<ZoomBloc>().add(
            ZoomWebResourceErrorEvent(error.type.toString(), error.description),
          );
        }
      },
      onReceivedHttpError: (_, request, error) {
        if (request.isForMainFrame ?? true) {
          context.read<ZoomBloc>().add(
            ZoomWebResourceErrorEvent(
              error.statusCode.toString(),
              error.reasonPhrase ?? 'HTTP Error',
            ),
          );
        }
      },
      onPermissionRequest: (_, request) async {
        // Auto-grant camera/mic so Zoom doesn't show a second native prompt
        return PermissionResponse(
          resources: request.resources,
          action: PermissionResponseAction.GRANT,
        );
      },
      shouldOverrideUrlLoading: (_, navigationAction) async {
        final uri = navigationAction.request.url;
        if (uri == null) return NavigationActionPolicy.ALLOW;

        final urlStr = uri.toString();

        // ① Block native Zoom app deep-links (zoommtg:// / zoomus://)
        if (uri.scheme == 'zoommtg' || uri.scheme == 'zoomus') {
          return NavigationActionPolicy.CANCEL;
        }

        // ② Detect post-meeting / promo pages → trigger meetingEnded state
        //    The BlocListener will call _exitMeeting() → auto-pop
        if (_isPostMeetingUrl(urlStr)) {
          context.read<ZoomBloc>().add(ZoomMeetingEndedEvent());
          return NavigationActionPolicy.CANCEL; // Don't render the promo page
        }

        return NavigationActionPolicy.ALLOW;
      },
    );
  }

  Widget _buildLoading(double progress) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Loading Meeting… ${(progress * 100).toInt()}%',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Connection Failed',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.read<ZoomBloc>().add(ZoomRetryEvent()),
              child: const Text('Retry'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
