import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String?> getLeaflet(String drugName) async {
  final http.Response data = await http.get(Uri.parse(
      "https://leaflet-alpha-six.vercel.app/api/medicine/" + drugName));

  final leafletData = await json.decode(data.body);

  return leafletData['pdf_url'];
}
