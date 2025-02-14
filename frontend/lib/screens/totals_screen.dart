import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/custom_drawer.dart';

class TotalsScreen extends StatefulWidget {
  @override
  _TotalsScreenState createState() => _TotalsScreenState();
}

class _TotalsScreenState extends State<TotalsScreen> {
  late Future<void> _loadUsersFuture;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);

    // Carrega usuários e transações simultaneamente
    _loadUsersFuture = Future.wait([
      userProvider.loadUsers(),
      transactionProvider.loadTransactions(),
    ]);
  }

  // Função para calcular os totais gerais
  Map<String, dynamic> calcularTotaisGerais() {
    final transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);

    double totalReceitas = transactionProvider.transactions
        .where((t) => t.type == 'receita')
        .fold(0, (sum, t) => sum + t.value);

    double totalDespesas = transactionProvider.transactions
        .where((t) => t.type == 'despesa')
        .fold(0, (sum, t) => sum + t.value);

    double saldoLiquido = totalReceitas - totalDespesas;

    return {
      'totalReceitas': totalReceitas,
      'totalDespesas': totalDespesas,
      'saldoLiquido': saldoLiquido,
    };
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);

    // Função para calcular os totais por usuário
    Map<String, dynamic> calcularTotais(int userId) {
      final transacoes = transactionProvider.transactions
          .where((t) => t.userId == userId)
          .toList();

      double receitas = transacoes
          .where((t) => t.type == 'receita')
          .fold(0, (sum, t) => sum + t.value);

      double despesas = transacoes
          .where((t) => t.type == 'despesa')
          .fold(0, (sum, t) => sum + t.value);

      double saldo = receitas - despesas;

      return {
        'receitas': receitas,
        'despesas': despesas,
        'saldo': saldo,
      };
    }

    // Calcula os totais gerais
    final totaisGerais = calcularTotaisGerais();

    return Scaffold(
      appBar: AppBar(
        title: Text('Totais por Usuário'),
      ),
      drawer: CustomDrawer(), // Drawer para navegação
      body: FutureBuilder(
        future: _loadUsersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Erro ao carregar dados: ${snapshot.error}'));
          } else if (userProvider.users.isEmpty) {
            return Center(child: Text('Nenhum usuário cadastrado'));
          } else {
            return Column(
              children: [
                // Exibe os totais gerais
                Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Totais Gerais',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                            'Total Receitas: R\$ ${totaisGerais['totalReceitas'].toStringAsFixed(2)}'),
                        Text(
                            'Total Despesas: R\$ ${totaisGerais['totalDespesas'].toStringAsFixed(2)}'),
                        Text(
                            'Saldo Líquido: R\$ ${totaisGerais['saldoLiquido'].toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: totaisGerais['saldoLiquido'] >= 0
                                  ? Colors.green
                                  : Colors.red,
                            )),
                      ],
                    ),
                  ),
                ),
                // Lista de usuários com seus totais
                Expanded(
                  child: ListView.builder(
                    itemCount: userProvider.users.length,
                    itemBuilder: (context, index) {
                      final user = userProvider.users[index];
                      final totais = calcularTotais(user.id);

                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(user.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Receitas: R\$ ${totais['receitas'].toStringAsFixed(2)}'),
                              Text(
                                  'Despesas: R\$ ${totais['despesas'].toStringAsFixed(2)}'),
                              Text(
                                  'Saldo: R\$ ${totais['saldo'].toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: totais['saldo'] >= 0
                                        ? Colors.green
                                        : Colors.red,
                                  )),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            // Recarrega os dados quando o botão é pressionado
            final userProvider =
                Provider.of<UserProvider>(context, listen: false);
            final transactionProvider =
                Provider.of<TransactionProvider>(context, listen: false);
            _loadUsersFuture = Future.wait([
              userProvider.loadUsers(),
              transactionProvider.loadTransactions(),
            ]);
          });
        },
        child: const Icon(Icons.refresh),
        tooltip: 'Atualizar dados',
      ),
    );
  }
}
