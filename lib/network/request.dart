import 'package:flutter/services.dart';

httpGet(url, headers) async {
  var httpClient = createHttpClient();
  return await httpClient.get(url, headers: headers);
}

httpPost(url, headers, payload) async {
  var httpClient = createHttpClient();
  return await httpClient.post(url, headers: headers, body: payload);
}
