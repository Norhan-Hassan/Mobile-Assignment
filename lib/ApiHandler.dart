import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiHandler {
  final String baseUrl = "http://ema.somee.com/api/Student";

  Future<void> sendPostRequest({
    required String name,
    required String email,
    required String studentId,
    required String password,
    required String confirmPassword,
    String? gender,
    String? level,
  }) async {
    try {
      const String endpoint = "/signup";
      final Map<String, dynamic> data = {
        "name": name,
        "gender": gender,
        "email": email,
        "studentId": studentId,
        "level": level,
        "password": password,
        "confirmPassword": confirmPassword
      };

      final http.Response response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print("Successfully posted data to API");
      } else {
        print("Failed to post data to API");
        print("Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");
      }
    } catch (e) {
      print("Error sending POST request: $e");
    }
  }

  //Log in
  Future<void> sendLoginRequest({
    required String name,
    required String password,
  }) async {
    try {
      final String endpoint = "/signin";
      final Map<String, dynamic> data = {
        'name': name,
        'password': password,
      };

      final http.Response response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print("Logged in Successfully");
      } else {
        print("Failed To Log In");
      }
    } catch (e) {
      print("Error sending sign-in request: $e");
    }
  }

  Future<Map<String, dynamic>> getUserInfo(String name) async {
    final String url = '$baseUrl/GetStudInfo/$name';
    final http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user info');
    }
  }

  // Update user data via API
  Future<void> updateUser(String name, Map<String, dynamic> updatedData) async {
  try {
    final String url = '$baseUrl/update/$name';
    final http.Response response = await http.put( // Use PUT method for updating
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updatedData),
    );

    if (response.statusCode == 200) {
      print("User data updated successfully");
    } else {
      print("Failed to update user data");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      throw Exception('Failed to update user data');
    }
  } catch (e) {
    print("Error updating user data: $e");
    throw Exception('Error updating user data: $e');
  }
}


}

