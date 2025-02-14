import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person_add),
            title: Text('Cadastrar Usuário'),
            onTap: () {
              Navigator.pop(context); // Fecha o Drawer
              Navigator.pushReplacementNamed(context, '/criar-usuario');
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Listar Usuários'),
            onTap: () {
              Navigator.pop(context); // Fecha o Drawer
              Navigator.pushReplacementNamed(context, '/listar-usuarios');
            },
          ),
          ListTile(
            leading: Icon(Icons.attach_money),
            title: Text('Criar Transação'),
            onTap: () {
              Navigator.pop(context); // Fecha o Drawer
              Navigator.pushReplacementNamed(context, '/criar-transacao');
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Listar Totais'),
            onTap: () {
              Navigator.pop(context); // Fecha o Drawer
              Navigator.pushReplacementNamed(context, '/listar-totais');
            },
          ),
        ],
      ),
    );
  }
}
