import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> getData() async {
  print('Try to connect to DB');
  List<dynamic> data = [];
  try {
    final response = await http.get(
        Uri.parse('http://localhost:8080/records'));
    if (response.statusCode == 200) {
      data=jsonDecode(response.body);
      {
        print("📦 Received: $data");
      } }
    else {
      print("❌ Failed to load records: ${response.body}");
    }
  } catch (e) {
    print("❌ Exception while fetching: $e");
  }
  return data;
}

Future<void> clearHistory() async
{
  try {
    final response = await http.post(
        Uri.parse('http://localhost:8080/clearHistory'));
    if (response.statusCode == 200) {
      print('✅ Records deleted successfully');
    } else {
      print('❌ Server error: ${response.body}');
    }
  } catch (e) {
    print('❌ HTTP request failed: $e');
  }
}

Future<void> addRecord(String strValue) async {
  try {
    final response = await http.post(
      Uri.parse('http://localhost:8080/addRecord'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'str': strValue}),
    );
    if (response.statusCode == 200) {
      print('✅ Record sent successfully');
    } else {
      print('❌ Server error: ${response.body}');
    }
  } catch (e) {
    print('❌ HTTP request failed: $e');
  }
}
