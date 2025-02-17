import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../widgets/custom_drawer.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late Future<void> _loadUsersFuture; //Para carregar os  usuários

  @override
  void initState() {
    super.initState();
    _loadUsersFuture = Provider.of<UserProvider>(context, listen: false)
        .loadUsers(); //Carrega os usuários ao iniciar
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listar Usuários'),
      ),
      drawer: CustomDrawer(), //Drawer para navegação
      body: FutureBuilder(
        future: _loadUsersFuture, //Use o Future para carregar os dados
        builder: (context, snapshot) {
          print('Estado do FutureBuilder: ${snapshot.connectionState}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator()); // Exibe um loading
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
                    'Erro ao carregar usuários: ${snapshot.error}')); // Exibe erro com detalhes
          } else if (userProvider.users.isEmpty) {
            return const Center(
                child: Text('Nenhum usuário cadastrado')); // Lista vazia
          } else {
            return ListView.builder(
              itemCount: userProvider.users.length,
              itemBuilder: (context, index) {
                final user = userProvider.users[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text('Idade: ${user.age}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      try {
                        await userProvider
                            .deleteUser(user.id); //Deleta o usuário
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Usuário deletado com sucesso!')),
                        );
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Erro ao deletar usuário: $error')),
                        );
                      }
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            // Recarrega a lista quando o botão é pressionado
            _loadUsersFuture =
                Provider.of<UserProvider>(context, listen: false).loadUsers();
          });
        },
        child: const Icon(Icons.refresh),
        tooltip: 'Atualizar lista',
      ),
    );
  }
}
