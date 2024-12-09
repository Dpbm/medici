import 'package:http/http.dart' as http;
import 'dart:convert';

String getApiURL(String drugName) {
  return "https://leaflet-alpha-six.vercel.app/api/medicine/$drugName";
}

Future<String?> getLeaflet(String drugName) async {
  final http.Response data = await http.get(Uri.parse(getApiURL(drugName)));
  final leafletData = await json.decode(data.body);
  return leafletData['pdf_url'];
}
