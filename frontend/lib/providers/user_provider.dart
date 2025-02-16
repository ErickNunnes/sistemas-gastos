import 'package:flutter/material.dart';
import 'package:frontend/providers/transaction_provider.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  final TransactionProvider transactionProvider;

  UserProvider(this.transactionProvider);

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
    try {
      await ApiService.deleteUser(id);
      await transactionProvider.deleteTransactionsByUserId(id);
      _users.removeWhere((user) => user.id == id);
      notifyListeners();
    } catch (error) {
      throw Exception('Falha ao carregar usuarios: $error');
    }
    //   await ApiService.deleteUser(id);
//
    //   final transactionProvider = Provider.of<TransactionProvider>(
    //       navigatorKey.currentContext!,
    //       listen: false);
    //   _users.removeWhere((user) => user.id == id);
//
    //   notifyListeners();
  }
}
