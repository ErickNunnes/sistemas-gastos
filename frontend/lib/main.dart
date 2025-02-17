import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'providers/transaction_provider.dart';
import 'screens/user_screen.dart';
import 'screens/list_screen.dart';
import 'screens/transaction_screen.dart';
import 'screens/totals_screen.dart';

void main() {
  final transctionProvider =
      TransactionProvider(); //Instancia do TransactionProvider
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) =>
                UserProvider(transctionProvider)), //Provider para userProvider
        ChangeNotifierProvider.value(
            value: transctionProvider), //Provider para transctionProvider
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu App Financeiro',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/criar-usuario', //Rota inicial
      routes: {
        '/criar-usuario': (context) =>
            UserScreen(), //Rota para a tela de criação de usuário
        '/listar-usuarios': (context) =>
            ListScreen(), //Rota para a tela de listagem de usuários
        '/criar-transacao': (context) =>
            TransactionScreen(), //Rota para a tela de criação de transações
        '/listar-totais': (context) =>
            TotalsScreen(), //Rota para a tela de listagem de totais
      },
    );
  }
}
