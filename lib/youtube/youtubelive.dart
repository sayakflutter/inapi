import 'package:flutter/material.dart';

import 'package:webview_windows/webview_windows.dart';
import 'package:flutter/services.dart' show rootBundle;

class YoutubeLive extends StatefulWidget {
  @override
  _YoutubeLiveState createState() => _YoutubeLiveState();
}

class _YoutubeLiveState extends State<YoutubeLive> {
  final _controller = WebviewController();
  final String youtubeUrl =
      "https://www.youtube.com/watch?v=nZQVPOsd9ls"; // Replace with your YouTube URL

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  Future<void> _initWebView() async {
    await _controller.initialize();

    // Extract YouTube Video ID
    final videoId = _extractYouTubeId(youtubeUrl);

    // Load HTML content with the video ID
    final htmlContent =
        await rootBundle.loadString('assets/youtubehtml/video_player.html');
    final modifiedHtmlContent = htmlContent.replaceAll('{SOURCE_ID}', videoId);

    _controller.loadStringContent(
      modifiedHtmlContent,
    );
    setState(() {});
  }

  // Function to extract YouTube Video ID
  String _extractYouTubeId(String url) {
    final uri = Uri.parse(url);
    if (uri.host.contains('youtube.com')) {
      return uri.queryParameters['v'] ?? '';
    } else if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : '';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Webview(
        permissionRequested: (url, permissionKind, isUserInitiated) =>
            WebviewPermissionDecision.deny,
        _controller,
      ),
    );
  }
}
