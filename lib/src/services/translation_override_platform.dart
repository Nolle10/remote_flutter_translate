import 'translation_override_io.dart'
    if (dart.library.html) 'translation_override_web.dart' as platform;

Future<String?> fetchRemoteString(String url, {Map<String, String>? headers})
{
    return platform.fetchRemoteString(url, headers: headers);
}

Future<String?> readLocalFile(String path)
{
    return platform.readLocalFile(path);
}
