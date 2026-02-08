import 'package:http/http.dart' as http;

Future<String?> fetchRemoteString(String url,
    {Map<String, String>? headers}) async {
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      return null;
    }

    return response.body;
  } catch (_) {
    return null;
  }
}

Future<String?> readLocalFile(String path) {
  throw UnsupportedError('Local file overrides are not supported on web.');
}
