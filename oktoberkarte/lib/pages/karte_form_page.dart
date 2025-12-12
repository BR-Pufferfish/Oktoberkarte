import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoberkarte/models/karte_model.dart';

class KarteFormPage extends StatefulWidget {
  final String? id; // Added id parameter
  const KarteFormPage({super.key, this.id});

  @override
  State<KarteFormPage> createState() => _KarteFormPageState();
}

class _KarteFormPageState extends State<KarteFormPage> {
  late TextEditingController controllerNome;
  late TextEditingController controllerValor;
  late TextEditingController controllerData;
  DateTime selectedDate = DateTime.now();
  late TextEditingController controllerCpf;
  late TextEditingController controllerAcessoVip;
  late TextEditingController controllerAcessoGratis;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  NovoKarte? _karte; // Adiciona um objeto do karte para edição

  @override
  void initState() {
    controllerNome = TextEditingController();
    controllerValor = TextEditingController();
    controllerData = TextEditingController(
      text: selectedDate.toIso8601String(),
    );
    controllerCpf = TextEditingController();
    controllerAcessoVip = TextEditingController();
    controllerAcessoGratis = TextEditingController();

    if (widget.id != null) {
      _loadNovoKarte(widget.id!); // Carrega o karte existente caso receba um ID
    }
    super.initState();
  }

  @override
  void dispose() {
    controllerNome.dispose();
    controllerValor.dispose();
    controllerData.dispose();
    controllerCpf.dispose();
    controllerAcessoVip.dispose();
    controllerAcessoGratis.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? 'Cadastrar Karte' : 'Editar Karte'),
      ),
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
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: controllerData,
                readOnly: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Data',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: controllerCpf,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'CPF',
                ),
                validator: (value) => validaCpf(value),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: controllerAcessoGratis,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Acessos Grátis',
                ),
                validator: (value) => validaAcessoGratis(value),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Checkbox(
                    value: controllerAcessoVip.text == "true",
                    onChanged: (value) {
                      setState(() {
                        controllerAcessoVip.text = value == true
                            ? "true"
                            : "false";
                      });
                    },
                  ),
                  const Text("Acesso VIP"),
                ],
              ),
            ),

            ElevatedButton.icon(
              onPressed: _salvarKarte,
              label: Text("Salvar Karte"),
              icon: Icon(Icons.save_alt_outlined),
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

  String? validaCpf(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o CPF do usuário.';
    }
    return null;
  }

  String? validaAcessoGratis(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o número de acessos grátis.';
    }
    final acessoGratis = int.tryParse(value);
    if (acessoGratis == null || acessoGratis < 0) {
      return 'Por favor, insira um número válido para acessos grátis.';
    }
    return null;
  }

  Future<void> _salvarKarte() async {
    final nomeUsuario = controllerNome.text;
    final valorSaldo = double.parse(controllerValor.text);

    if (formKey.currentState?.validate() == true) {
      var dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          baseUrl: 'https://691266ae52a60f10c8218c11.mockapi.io/api/v1',
        ),
      );

      if (widget.id == null) {
        // Criação de novo karte
        await dio.post(
          '/karte',
          data: {
            'nomeUsuario': nomeUsuario,
            'valorSaldo': valorSaldo,
            'dataInclusao': selectedDate.millisecondsSinceEpoch,
            'cpfUsuario': controllerCpf.text,
            'acessoVip': controllerAcessoVip.text.toLowerCase() == 'true',
            'acessoGratis': int.parse(controllerAcessoGratis.text),
          },
        );
      } else {
        // Atualização de karte existente
        await dio.put(
          '/karte/${widget.id}',
          data: {
            'nomeUsuario': nomeUsuario,
            'valorSaldo': valorSaldo,
            'dataInclusao': selectedDate.millisecondsSinceEpoch,
            'cpfUsuario': controllerCpf.text,
            'acessoVip': controllerAcessoVip.text.toLowerCase() == 'true',
            'acessoGratis': int.parse(controllerAcessoGratis.text),
          },
        );
      }

      if (!context.mounted) return;
      Navigator.pop(context);
    }
  }

  Future<void> _loadNovoKarte(String id) async {
    var dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        baseUrl: 'https://691266ae52a60f10c8218c11.mockapi.io/api/v1',
      ),
    );

    var response = await dio.get('/karte/$id');
    if (response.statusCode == 200) {
      setState(() {
        _karte = NovoKarte.fromJson(response.data);
        controllerNome.text = _karte!.nomeUsuario;
        controllerValor.text = _karte!.valorSaldo.toString();
        controllerData.text = _karte!.dataInclusao.toIso8601String();
      });
    } else {
      if (!context.mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar o karte.')));
    }
  }
}
