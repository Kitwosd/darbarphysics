/// Converts Zoom meeting URLs into Zoom Web Client URLs
/// Example:
/// https://us04web.zoom.us/j/123456789?pwd=abc
/// → https://app.zoom.us/wc/join/123456789?pwd=abc

String convertZoomUrlToWebClient(String url) {
  try {
    final uri = Uri.parse(url);
    final segments = uri.pathSegments;

    String? meetingId;

    for (int i = 0; i < segments.length; i++) {
      if (segments[i] == 'j' && i + 1 < segments.length) {
        meetingId = segments[i + 1];
        break;
      }
    }

    if (meetingId == null) {
      return url;
    }
    final pwd = uri.queryParameters['pwd'];

    return pwd != null
        ? 'https://app.zoom.us/wc/join/$meetingId?pwd=$pwd'
        : 'https://app.zoom.us/wc/join/$meetingId';
  } catch (e) {
    //app never crashed because of url parsing https://us04web.zoom.us/j/3117772972?pwd=oQOKC681rjGaeyA8ZiixJe8T2sW9pN.1
    return url;
  }
}
