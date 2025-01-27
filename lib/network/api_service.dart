import 'package:dio/dio.dart';
import 'package:flutter_base/models/response/get_user_model.dart';
import 'package:flutter_base/models/user_model.dart';

class ApiService {
  final Dio _dio;
  static const String baseUrl = 'http://localhost:3000/api';
  static const String wsUrl = 'ws://localhost:3000';

  ApiService() : _dio = Dio() {
    _dio.options.baseUrl = baseUrl;
  }

  void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  Future<GetUsersModel> getUsers() async {
    try {
      final response = await _dio.get(
        '/users',
        queryParameters: {
          'page': 1,
          'limit': 10,
        },
      );
      return GetUsersModel.fromJson(
        response.data,
      );
    } catch (e) {
      throw Exception('Kullanıcılar alınamadı: ${e.toString()}');
    }
  }

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/users/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      print(response.data);
      UserModel user = UserModel.fromJson(response.data);
      setToken(user.data.token);
      return user;
    } catch (e) {
      throw Exception('Giriş başarısız: ${e.toString()}');
    }
  }

  Future<List<dynamic>> getConversation(String userId) async {
    try {
      final response = await _dio.get('/messages/conversation/$userId');
      return response.data['data'] as List;
    } catch (e) {
      throw Exception('Konuşma geçmişi alınamadı: ${e.toString()}');
    }
  }

  Future<void> markMessageAsRead(String messageId) async {
    try {
      await _dio.patch('/messages/mark-read/$messageId');
    } catch (e) {
      throw Exception('Mesaj okundu olarak işaretlenemedi: ${e.toString()}');
    }
  }
}
