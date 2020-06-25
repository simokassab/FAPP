import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  final String _url = 'http://mediaworldiq.org:8008/fitness/public/api/';
  final String _url1 = 'https://fitapp.3q.to/api/invoke.php';

  postData(data, apiUrl) async {
    var fullUrl = _url + apiUrl + await _getToken();
    //print(fullUrl);
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  postData1(data) async {
    var fullUrl = _url1 + await _getToken();
   // print(fullUrl);
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  Future postData2(data) async {
    var fullUrl = _url1 + await _getToken();
   // print(fullUrl);
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl + await _getToken();
   // print(fullUrl);
    return await http.get(fullUrl, headers: _setHeaders());
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return '?token=$token';
  }
}
