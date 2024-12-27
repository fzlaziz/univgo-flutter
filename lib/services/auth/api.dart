import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Api {
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8000';
  String awsUrl = dotenv.env['AWS_URL'] ?? 'http://localhost:8000';

  String? _token;

  Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
  }

  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String name,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'name': name,
              'password': password,
              'password_confirmation': passwordConfirmation,
            }),
          )
          .timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } on TimeoutException {
      return {'message': 'Request timed out. Please try again.'};
    } catch (e) {
      return {'message': 'Failed to connect to the server: $e'};
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 10));

      final result = _handleLoginResponse(response);
      if (result.containsKey('token')) {
        await setToken(result['token']);
      }
      return result;
    } on TimeoutException {
      return {'message': 'Request timed out. Please try again.'};
    } catch (e) {
      return {'message': 'Failed to connect to the server: $e'};
    }
  }

  Future<Map<String, dynamic>> uploadProfileImage(File imageFile) async {
    await loadToken();
    if (_token == null) {
      return {'message': 'User is not logged in.'};
    }

    try {
      final uri = Uri.parse('$baseUrl/api/upload-profile-image');
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $_token'
        ..headers['Accept'] = 'application/json'
        ..files.add(await http.MultipartFile.fromPath(
          'profile_image',
          imageFile.path,
        ));

      final response =
          await request.send().timeout(const Duration(seconds: 10));

      final responseBody = await http.Response.fromStream(response);
      return _handleResponse(responseBody);
    } on TimeoutException {
      return {'message': 'Request timed out. Please try again.'};
    } catch (e) {
      return {'message': 'Failed to connect to the server: $e'};
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    await loadToken();
    if (_token == null) {
      return {'message': 'User is not logged in.'};
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      ).timeout(const Duration(seconds: 10));

      debugPrint('Response body: ${response.body}');
      return _handleResponseProfile(response);
    } on TimeoutException {
      return {'message': 'Request timed out. Please try again.'};
    } catch (e) {
      return {'message': 'Failed to connect to the server: $e'};
    }
  }

  Future<void> resendVerificationEmail(String email) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/resend-verification-email'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to send verification email: ${response.body}');
      }
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String
        confirmPassword, // Tambahkan parameter untuk konfirmasi password
  }) async {
    // Memastikan token telah dimuat
    await loadToken();
    if (_token == null) {
      return {'message': 'User is not logged in.', 'status_code': 401};
    }

    try {
      // Request ke endpoint API untuk mengganti password
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/change-password'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_token',
            },
            body: jsonEncode({
              'current_password': currentPassword,
              'new_password': newPassword,
              'new_password_confirmation':
                  confirmPassword, // Kirim data confirm_password
            }),
          )
          .timeout(const Duration(seconds: 10)); // Timeout setelah 10 detik

      // Debug response (opsional, untuk mempermudah debugging)
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Menggunakan fungsi _handleResponse untuk parsing
      return _handleResponse(response);
    } on TimeoutException {
      return {
        'message': 'Request timed out. Please try again.',
        'status_code': 408
      };
    } catch (e) {
      return {
        'message': 'Failed to connect to the server: $e',
        'status_code': 500,
      };
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String email,
    Map<String, dynamic>? additionalFields,
  }) async {
    await loadToken();
    if (_token == null) {
      return {'message': 'User is not logged in.'};
    }

    try {
      final payload = {
        'name': name,
        'email': email,
        // Include additional fields if provided
        ...?additionalFields,
      };

      final response = await http
          .post(
            Uri.parse('$baseUrl/api/profile'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_token',
              'Accept': 'application/json',
            },
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 10));

      print('Response body: ${response.body}');
      return _handleResponse(response);
    } on TimeoutException {
      return {'message': 'Request timed out. Please try again.'};
    } catch (e) {
      return {'message': 'Failed to connect to the server: $e'};
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    try {
      final responseBody = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (responseBody is Map<String, dynamic>) {
          return responseBody;
        } else {
          return {
            'message': 'Unexpected response format: Not a JSON object',
            'status_code': response.statusCode,
          };
        }
      } else {
        return {
          'message': responseBody['message'] ?? 'Unknown error occurred',
          'status_code': response.statusCode,
        };
      }
    } catch (e) {
      print('Non-JSON response received: ${response.body}');
      return {
        'message': 'Unexpected response format',
        'raw_response': response.body,
        'status_code': response.statusCode,
      };
    }
  }

  Map<String, dynamic> _handleLoginResponse(http.Response response) {
    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    try {
      final responseBody = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (responseBody is Map<String, dynamic>) {
          return responseBody;
        } else {
          return {
            'message': 'Unexpected response format: Not a JSON object',
            'status_code': response.statusCode,
          };
        }
      } else if (response.statusCode == 403 &&
          responseBody['message'] ==
              "Please verify your email before logging in.") {
        return {
          'message': 'Email Belum Di verifikasi',
          'status_code': response.statusCode,
        };
      } else {
        return {
          'message': responseBody['message'] ?? 'Unknown error occurred',
          'status_code': response.statusCode,
        };
      }
    } catch (e) {
      print('Non-JSON response received: ${response.body}');
      return {
        'message': 'Unexpected response format',
        'raw_response': response.body,
        'status_code': response.statusCode,
      };
    }
  }

  Map<String, dynamic> _handleResponseProfile(http.Response response) {
    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success' &&
            responseData['user'] != null) {
          return responseData['user'];
        } else {
          return {
            'message': responseData['message'] ?? 'Unknown error occurred.'
          };
        }
      } catch (e) {
        return {'message': 'Failed to parse server response: $e'};
      }
    } else if (response.statusCode == 401) {
      return {'message': 'Unauthorized. Please log in again.'};
    } else if (response.statusCode == 404) {
      return {'message': 'Profile not found.'};
    } else {
      return {
        'message':
            'Server error. Status code: ${response.statusCode}. Please try again later.'
      };
    }
  }

  Future<Map<String, dynamic>> logout() async {
    await loadToken();
    try {
      // Make a call to your backend logout endpoint
      final response = await http.post(
        Uri.parse(
            '$baseUrl/api/logout'), // Replace with your actual logout endpoint
        headers: {
          'Authorization': 'Bearer $_token', // Assuming you store the token
          'Content-Type': 'application/json',
        },
      );

      // Remove the token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      print('LOGOUT RESPONSE');
      print(response);
      return {
        'status_code': response.statusCode,
        'message': 'Logged out successfully',
      };
    } catch (e) {
      return {
        'status_code': 500,
        'message': 'Logout failed: ${e.toString()}',
      };
    }
  }
}
