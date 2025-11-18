import 'package:flutter/material.dart';
import 'package:oktoberkarte/models/karte_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<NovoKarte> kartes = [];

  late TextEditingController controllerNome;
  late TextEditingController controllerValor;
  late TextEditingController controllerData;

  @override
  void initState() {
    controllerNome = TextEditingController();
    controllerValor = TextEditingController();
    controllerData = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controllerNome.dispose();
    controllerValor.dispose();
    controllerData.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: controllerNome,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nome do Usuário',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: controllerValor,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Valor do Saldo',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: controllerData,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Data de Inclusão',
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: kartes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.person),
                  title: Text(kartes[index].nomeUsuario),
                  subtitle: Text(kartes[index].valorSaldo.toString()),
                  : Text(kartes[index].dataInclusao.toString()),
                  isThreeLine: true,
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarKarte,
        tooltip: 'Adicionar Karte',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _adicionarKarte() {
    var cpfUsuario = controller.text;
  }
}
