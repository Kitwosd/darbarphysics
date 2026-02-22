import 'package:durbar_physics/common/widgets/button_widget.dart';
import 'package:durbar_physics/common/widgets/custom_appbar_widget.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/features/zoom/presentation/screens/zoom_web_view.dart';
import 'package:flutter/material.dart';

class ZoomTestScreen extends StatelessWidget {
  const ZoomTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbarWidget(title: 'Zoom Test'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: ButtonWidget(
            textWidget: TextWidget(word: 'Random BUtton to text'),
            onPressed: () {
              // final url = convertZoomUrlToWebClient(
              //   'https://us04web.zoom.us/j/3117772972?pwd=oQOKC681rjGaeyA8ZiixJe8T2sW9pN.1',
              // );
              // logger.f(url);
              // ZoomPermissionService.requestPermission();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ZoomWebView(
                    url:
                        'https://us04web.zoom.us/j/3117772972?pwd=oQOKC681rjGaeyA8ZiixJe8T2sW9pN.1',
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
