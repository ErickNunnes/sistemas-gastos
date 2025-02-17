import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../widgets/custom_drawer.dart'; // Importe o Drawer

class UserScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>(); //Chave para formulário
  final _nameController =
      TextEditingController(); //Controlador para o campo nome
  final _ageController =
      TextEditingController(); //Controlador para o campo idade

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Criar Usuário')),
      drawer: CustomDrawer(), //Drawer para navegação
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Idade'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma idade';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final name =
                        _nameController.text; //Obtém o valor do campo nome
                    final age = int.parse(
                        _ageController.text); //Obtém o valor do campo idade
                    await Provider.of<UserProvider>(context, listen: false)
                        .addUser(name, age); //Adiciona o usuário
                    Navigator.pushReplacementNamed(context,
                        '/criar-transacao'); //Navega para a tela de criar transações
                  }
                },
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
