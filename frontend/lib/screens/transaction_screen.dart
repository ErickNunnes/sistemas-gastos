import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/custom_drawer.dart';
import '../models/user.dart';
import '../models/transaction.dart';

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _valorController = TextEditingController();
  final _descricaoController = TextEditingController();
  String? _selectedUserId;
  String? _selectedType;

  @override
  void dispose() {
    _valorController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Transação'),
      ),
      drawer: CustomDrawer(), // Drawer para navegação
      body: Column(
        children: [
          // Formulário para criar transação
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedUserId,
                    items: userProvider.users.map((user) {
                      return DropdownMenuItem(
                        value: user.id.toString(),
                        child: Text(user.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedUserId = value;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Usuário'),
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor, selecione um usuário';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedType,
                    items: ['receita', 'despesa'].map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type == 'receita' ? 'Receita' : 'Despesa'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Tipo'),
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor, selecione o tipo';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _valorController,
                    decoration: InputDecoration(labelText: 'Valor'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um valor';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descricaoController,
                    decoration: InputDecoration(labelText: 'Descrição'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma descrição';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Cria um objeto Transaction
                        final transaction = Transaction(
                          id: DateTime.now().millisecondsSinceEpoch,
                          userId: int.parse(_selectedUserId!),
                          type: _selectedType!,
                          value: double.parse(_valorController.text),
                          description: _descricaoController.text,
                        );

                        // Adiciona a transação usando o TransactionProvider
                        await transactionProvider.addTransaction(transaction);

                        // Exibe uma mensagem de sucesso
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Transação criada com sucesso!')),
                        );

                        // Limpa os campos do formulário
                        _valorController.clear();
                        _descricaoController.clear();
                        setState(() {
                          _selectedUserId = null;
                          _selectedType = null;
                        });
                      }
                    },
                    child: Text('Salvar'),
                  ),
                ],
              ),
            ),
          ),

          // Lista de transações
          Expanded(
            child: ListView.builder(
              itemCount: transactionProvider.transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactionProvider.transactions[index];
                final user = userProvider.users.firstWhere(
                  (user) => user.id == transaction.userId,
                  orElse: () => User(
                      id: -1,
                      name: 'Desconhecido',
                      age: 0), // Fallback para usuário não encontrado
                );

                return ListTile(
                  title: Text(transaction.description),
                  subtitle: Text(
                    'Usuário: ${user.name} | Valor: R\$ ${transaction.value.toStringAsFixed(2)}',
                  ),
                  trailing: Text(
                    transaction.type == 'receita' ? 'Receita' : 'Despesa',
                    style: TextStyle(
                      color: transaction.type == 'receita'
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
