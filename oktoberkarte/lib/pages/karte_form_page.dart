import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class KarteFormPage extends StatefulWidget {
  const KarteFormPage({super.key});

  @override
  State<KarteFormPage> createState() => _KarteFormPageState();
}

class _KarteFormPageState extends State<KarteFormPage> {
  late TextEditingController controllerNome;
  late TextEditingController controllerValor;
  late TextEditingController controllerData;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
      appBar: AppBar(title: const Text('Karte Form Page')),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: controllerNome,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nome do Usuário',
                ),
                validator: (value) => validaNome(value),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: controllerValor,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Valor',
                ),
                validator: (value) => validaValor(value),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: controllerData,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Data',
                ),
                validator: (value) => validaData(value),
              ),
            ),

            ElevatedButton(
              onPressed: _salvarKarte,
              child: const Text('Salvar Karte'),
            ),
          ],
        ),
      ),
    );
  }

  String? validaNome(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o nome do usuário.';
    }
    return null;
  }

  String? validaValor(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o valor do saldo.';
    }
    final valor = double.tryParse(value);
    if (valor == null) {
      return 'Por favor, insira um valor numérico válido.';
    }
    return null;
  }

  String? validaData(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira a data de inclusão.';
    }
    return null;
  }

  Future<void> _salvarKarte() async {
    final nomeUsuario = controllerNome.text;
    final valorSaldo = double.parse(controllerValor.text);
    final dataInclusao = DateTime.parse(controllerData.text);

    if (formKey.currentState?.validate() == true) {
      var dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          baseUrl: 'https://691266ae52a60f10c8218c11.mockapi.io/api/v1',
        ),
      );

      var response = await dio.post(
        '/karte',
        data: {
          'nomeUsuario': nomeUsuario,
          'valorSaldo': valorSaldo,
          'dataInclusao': dataInclusao.toIso8601String(),
        },
      );

      if (!context.mounted) return;
      Navigator.pop(context);
    }
  }
}
