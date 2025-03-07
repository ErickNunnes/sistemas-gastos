import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/api_service.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> _transactions = []; //Lista de transações

  //Getter para acessar a lista de transações
  List<Transaction> get transactions => _transactions;

  //Carregar transações do backend
  Future<void> loadTransactions() async {
    try {
      //Chama a API para buscar as transações
      _transactions = await ApiService.listTransactions();
      notifyListeners(); //Notifica os listeners sobre a mudança
    } catch (error) {
      throw Exception('Falha ao carregar transações: $error');
    }
  }

  //Adicionar uma nova transação
  Future<void> addTransaction(Transaction transaction) async {
    try {
      //Chama a API para criar a transação no backend
      final newTransaction = await ApiService.createTransaction(transaction);
      _transactions.add(newTransaction); //Adiciona a transação à lista local
      notifyListeners(); //Notifica os listeners sobre a mudança
    } catch (error) {
      throw Exception('Falha ao criar transação: $error');
    }
  }

  //Deleta as transações de um usuario especifico
  Future<void> deleteTransactionsByUserId(int userId) async {
    try {
      _transactions.removeWhere((transaction) =>
          transaction.userId == userId); //Remove as transações do usuario
      notifyListeners(); // Notifica os listeners sobre a mudança
    } catch (error) {
      throw Exception('Falha ao deletar transações do usuário: $error');
    }
  }

  // Buscar transações de um usuário específico
  List<Transaction> getTransactionsByUserId(int userId) {
    return _transactions
        .where((transaction) => transaction.userId == userId)
        .toList();
  }
}
