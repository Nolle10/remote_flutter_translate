import 'dart:html' as html;

Future<String?> fetchRemoteString(String url, {Map<String, String>? headers}) async
{
    try
    {
        final request = await html.HttpRequest.request(
            url,
            method: 'GET',
            requestHeaders: headers,
        );

        final status = request.status ?? 0;

        if (status < 200 || status >= 300)
        {
            return null;
        }

        return request.responseText;
    }
    catch (_) 
    {
        return null;
    }
}

Future<String?> readLocalFile(String path)
{
    throw UnsupportedError('Local file overrides are not supported on web.');
}
