import 'package:patientapp/classes/enumerations.dart';
import 'package:dio/dio.dart' as dioHttp;
import 'package:dio/adapter_browser.dart';

final dioHttp.Dio _dio = dioHttp.Dio();

Future<dioHttp.Response> executeRequest(
  String url,
  HttpMethod method,
  String body,
) async {
  dioHttp.Response response;

  try {
    _dio.options.headers['content-Type'] = 'application/json';
    _dio.options.headers["accept"] = 'application/json';
    _dio.options.headers["Access-Control-Allow-Origin"] = '*';
    _dio.options.headers["Access-Control-Allow-Credentials"] = 'true';

    BrowserHttpClientAdapter adapter = BrowserHttpClientAdapter();
    adapter.withCredentials = true;
    _dio.httpClientAdapter = adapter;

    switch (method) {
      case HttpMethod.GET:
        response = await _dio.get(url);
        break;

      case HttpMethod.POST:
        response = await _dio.post(url, data: body);
        break;

      case HttpMethod.PUT:
        response = await _dio.put(url, data: body);
        break;

      case HttpMethod.DELETE:
        response = await _dio.delete(url, data: body);
        break;
    }
  } on dioHttp.DioError catch (e) {
    throw Exception(e);
  }

  return response;
}
