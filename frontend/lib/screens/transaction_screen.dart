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
  final _formKey = GlobalKey<FormState>(); //Chave para o formulario
  final _valorController =
      TextEditingController(); //Controlador para o campo de valor
  final _descricaoController =
      TextEditingController(); //Controlador para o campo de descrição
  String? _selectedUserId; //ID do usuário selecionado
  String? _selectedType; //Tipo de transação selecionado

  @override
  void dispose() {
    _valorController.dispose(); //Libera o controlador valor
    _descricaoController.dispose(); //Libera o controlador descrição
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
      drawer: CustomDrawer(), //Drawer para navegação
      body: Column(
        children: [
          //Formulário para criar transação
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
                        _selectedUserId =
                            value; //Atualiza o usuário selecionado
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
                    items: (_selectedUserId != null)
                        ? userProvider.users
                            .where((user) =>
                                user.id == int.parse(_selectedUserId!))
                            .map((user) => user.age < 18
                                    ? [
                                        'despesa'
                                      ] //Apenas "despesa" se menor de idade
                                    : [
                                        'receita',
                                        'despesa'
                                      ] //Ambos se maior de idade
                                )
                            .expand((list) => list)
                            .map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(
                                type == 'receita' ? 'Receita' : 'Despesa',
                              ),
                            );
                          }).toList()
                        : [],
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value; //Atualiza o tipo selecionado
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
                        //Cria um objeto Transaction com os dados do formulário
                        final transaction = Transaction(
                          id: DateTime.now()
                              .millisecondsSinceEpoch, //Gera um ID único
                          userId: int.parse(_selectedUserId!), //ID do usuário
                          type: _selectedType!, //Tipo de transação
                          value: double.parse(
                              _valorController.text), //Valor da transação
                          description: _descricaoController
                              .text, //Descrição da transação
                        );

                        //Adiciona a transação usando o TransactionProvider
                        await transactionProvider.addTransaction(transaction);

                        //Exibe uma mensagem de sucesso
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Transação criada com sucesso!')),
                        );

                        //Limpa os campos do formulário
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

          //Lista de transações
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
                      age: 0), //Fallback para usuário não encontrado
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
