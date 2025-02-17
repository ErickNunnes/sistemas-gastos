import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/transaction.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000'; //URL do backend

  //Listar todos os usuários
  static Future<List<User>> listUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body); //Decodifica o JSON
      return data
          .map((json) => User.fromJson(json))
          .toList(); //Converte para a lista de usuários
    } else {
      throw Exception('Falha ao carregar usuários');
    }
  }

  //Cria um novo usuário
  static Future<User> createUser(String name, int age) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'age': age,
      }),
    );

    if (response.statusCode == 201) {
      return User.fromJson(
          json.decode(response.body)); //Retorna o usuário criado
    } else {
      throw Exception('Falha ao criar usuário');
    }
  }

  //Deleta um usuário
  static Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/users/$id'));

    if (response.statusCode != 200) {
      throw Exception('Falha ao deletar usuário');
    }
  }

  //Lista todas as transações
  static Future<List<Transaction>> listTransactions() async {
    final response = await http.get(Uri.parse('$baseUrl/transactions'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body); //Decodifica o JSON
      return data
          .map((json) => Transaction.fromJson(json))
          .toList(); //Converte para a lista de transações
    } else {
      throw Exception('Falha ao carregar transações');
    }
  }

  //Cria uma nova transação
  static Future<Transaction> createTransaction(Transaction transaction) async {
    final response = await http.post(
      Uri.parse('$baseUrl/transactions'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': transaction.userId,
        'type': transaction.type,
        'value': transaction.value,
        'description': transaction.description,
      }),
    );

    if (response.statusCode == 201) {
      return Transaction.fromJson(
          json.decode(response.body)); //Retorna a transação criada
    } else {
      throw Exception('Falha ao criar transação');
    }
  }

  //Consulta totais de receitas, despesas e saldo por usuário
  static Future<List<Map<String, dynamic>>> consultTotals() async {
    final response = await http.get(Uri.parse('$baseUrl/users/total'));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(
          json.decode(response.body)); //Retorna os totais
    } else {
      throw Exception('Falha ao carregar totais');
    }
  }
}
