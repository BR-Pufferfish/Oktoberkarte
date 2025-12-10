import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oktoberkarte/models/karte_model.dart';
import 'package:oktoberkarte/pages/karte_form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  List<NovoKarte> kartes = [];

  bool isLoading = true;

  @override
  void initState() {
    _getKartes();
    super.initState();
  }

  Future<void> _getKartes() async {
    setState(() {
      isLoading = true;
    });

    var dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        baseUrl: 'https://691266ae52a60f10c8218c11.mockapi.io/api/v1',
      ),
    );

    var response = await dio.get('/karte');

    var listaData = response.data as List;
    for (var data in listaData) {
      var karte = NovoKarte(
        id: data['id'],
        nomeUsuario: data['nomeUsuario'],
        valorSaldo: double.parse(data['valorSaldo']),
        dataInclusao: DateTime.parse(data['dataInclusao']),
      );
      kartes.add(karte);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: kartes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.task),
                  title: Text(kartes[index].nomeUsuario),
                  subtitle: Column(
                    children: [
                      Text(kartes[index].valorSaldo.toString()),
                      Text(kartes[index].dataInclusao.toString()),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deletarKarte(kartes[index].id),
                  ),
                  isThreeLine: true,
                  onTap: () {
                    // Ação ao tocar no item da lista (se necessário)
                    () => _editarKarte(kartes[index].id);
                  },
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarKarte,
        tooltip: 'Adicionar Karte',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _adicionarKarte() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) {
              return KarteFormPage();
            },
          ),
        )
        .then((_) {
          kartes.clear();
          _getKartes();
        });
  }

  void _deletarKarte(String id) async {
    var dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        baseUrl: 'https://691266ae52a60f10c8218c11.mockapi.io/api/v1',
      ),
    );

    var response = await dio.delete('/karte/$id');
    if (response.statusCode == 200) {
    } else {
      if (!context.mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao deletar Karte')));
    }
    Navigator.pop(context);
  }

  void _editarKarte(String id) async {
    // Implementar a lógica de edição aqui
  }
}
