import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'providers/transaction_provider.dart';
import 'screens/user_screen.dart';
import 'screens/list_screen.dart';
import 'screens/transaction_screen.dart';
import 'screens/totals_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
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
      initialRoute: '/criar-usuario',
      routes: {
        '/criar-usuario': (context) => UserScreen(),
        '/listar-usuarios': (context) => ListScreen(),
        '/criar-transacao': (context) => TransactionScreen(),
        '/listar-totais': (context) => TotalsScreen(),
      },
    );
  }
}
