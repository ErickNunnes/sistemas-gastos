import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];

  List<User> get users => _users;

  Future<void> loadUsers() async {
    _users = await ApiService.listUsers();
    notifyListeners();
  }

  Future<void> addUser(String name, int age) async {
    try {
      final user = await ApiService.createUser(name, age);
      _users.add(user);
      notifyListeners();
    } catch (error) {
      throw Exception('Falha ao criar usuário: $error');
    }
  }

  Future<void> deleteUser(int id) async {
    await ApiService.deleteUser(id);
    _users.removeWhere((user) => user.id == id);

    notifyListeners();
  }
}
