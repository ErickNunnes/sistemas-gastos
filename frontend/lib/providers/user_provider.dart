import 'package:flutter/material.dart';
import 'package:frontend/providers/transaction_provider.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = []; //Lista de usuarios
  final TransactionProvider transactionProvider;

  UserProvider(this.transactionProvider);

  //Getter para acessar a lista de usuarios
  List<User> get users => _users;

  //Carrega os usuarios do backend
  Future<void> loadUsers() async {
    _users = await ApiService.listUsers(); //Busca usuários do backend
    notifyListeners(); //Notifica os listeners sobre a mudança
  }

  //Adiciona um novo usuário
  Future<void> addUser(String name, int age) async {
    try {
      final user =
          await ApiService.createUser(name, age); //Cria o usuário no backend
      _users.add(user); //Adiciona o usuario na lista
      notifyListeners(); //Notifica os listeners sobre a mudança
    } catch (error) {
      throw Exception('Falha ao criar usuário: $error');
    }
  }

  //Deleta um usuário
  Future<void> deleteUser(int id) async {
    try {
      await ApiService.deleteUser(id); //Deleta um usuário no backend
      await transactionProvider
          .deleteTransactionsByUserId(id); //Deleta transações do usuário
      _users.removeWhere(
          (user) => user.id == id); //Remove o usuário da lista local
      notifyListeners(); //Notifica os listeners sobre a mudança
    } catch (error) {
      throw Exception('Falha ao carregar usuarios: $error');
    }
  }
}
