import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';

Future<String?> fetchRemoteString(String url, {Map<String, String>? headers}) async
{
    final uri = Uri.parse(url);
    final client = HttpClient();

    try
    {
        final request = await client.getUrl(uri);
        headers?.forEach((key, value) => request.headers.set(key, value));

        final response = await request.close();

        if (response.statusCode < 200 || response.statusCode >= 300)
        {
            return null;
        }

        return await utf8.decoder.bind(response).join();
    }
    finally
    {
        client.close();
    }
}

Future<String?> readLocalFile(String path) async
{
    final file = File(path);

    if (!await file.exists())
    {
        if (!path.startsWith('/') && !path.contains(':'))
        {
            try
            {
                return await rootBundle.loadString(path);
            }
            catch (_)
            {
                return null;
            }
        }

        return null;
    }

    return file.readAsString();
}
