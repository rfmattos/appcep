import 'package:appcep/model/cep_model.dart';
import 'package:appcep/model/viacep_model.dart';
import 'package:appcep/repository/back4app/cep_repository.dart';
import 'package:appcep/repository/viacep_repository.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  final String titulo = "Cadastro de CEP";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CepRepository cepRepository = CepRepository();
  var _listaCeps = CepsModel([]);
  var _buscaUmCep = CepsModel([]);
  var cepController = TextEditingController();
  var carregando = false;
  var viaCepModel = ViaCepModel();
  var viaCepRepository = ViaCepRepository();
  var _cep = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int tamanhoDaLista = 0;

  @override
  void initState() {
    super.initState();
    oberDados();
  }

  void oberDados() async {
    setState(() {
      carregando = true;
    });
    _listaCeps = await cepRepository.obter();
    tamanhoDaLista = _listaCeps.ceps.length;
    setState(() {
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.titulo)),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: carregando ? const CircularProgressIndicator() : _listaDeCep(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _adicionarCep();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  Widget campoDeCep() {
    return TextFormField(
      controller: _cep,
      keyboardType: TextInputType.number,
      validator: (valor) {
        if ((valor!.isEmpty) || (double.parse(_cep.text) == 0)) {
          return "Campo Obrigatório";
        }
      },
      decoration: const InputDecoration(
        hintText: 'cep',
        labelText: 'cep',
        border: OutlineInputBorder(),
      ),
    );
  }

  void _adicionarCep() {
    _cep.text = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Novo CEP"),
          content: Container(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  campoDeCep(),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Salvar"),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  viaCepModel = await viaCepRepository.consultarCEP(_cep.text);
                  _buscaUmCep = await cepRepository.obterUmCep(_cep.text);
                  if (_buscaUmCep.ceps.isEmpty) {
                    await cepRepository.criar(UmCepModel.criar(
                        _cep.text,
                        viaCepModel.logradouro ?? "",
                        viaCepModel.bairro ?? "",
                        viaCepModel.localidade ?? "",
                        viaCepModel.uf ?? ""));
                  }
                  oberDados();
                  _formKey.currentState!.reset();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _listaDeCep() {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: tamanhoDaLista,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: ListTile(
            title: Text(_listaCeps.ceps[index].cep),
            subtitle: Text(
                "${_listaCeps.ceps[index].logradouro ?? ""} - ${_listaCeps.ceps[index].bairro ?? ""} - ${_listaCeps.ceps[index].localidade ?? ""} - ${_listaCeps.ceps[index].uf ?? ""}"),
            leading: const CircleAvatar(
              backgroundColor: Colors.blue,
            ),
          ),
          onDoubleTap: () {
            _atualizarContato(_listaCeps.ceps[index]);
          },
          onHorizontalDragEnd: (a) async {
            await cepRepository.remover(_listaCeps.ceps[index].objectId);
            oberDados();
          },
          //          onTap: () async {
          //       await cepRepository.remover(_listaCeps.ceps[index].objectId);
          //       oberDados();
          //           }
        );
      },
    );
  }

  void _atualizarContato(UmCepModel cepAtualizarModel) {
    _cep.text = cepAtualizarModel.cep;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Atualizar CEP"),
          content: Container(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  campoDeCep(),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Atualizar"),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  viaCepModel = await viaCepRepository.consultarCEP(_cep.text);
                  _buscaUmCep = await cepRepository.obterUmCep(_cep.text);
                  if (_buscaUmCep.ceps.isEmpty) {
                    cepAtualizarModel.cep = _cep.text;
                    cepAtualizarModel.logradouro = viaCepModel.logradouro ?? "";
                    cepAtualizarModel.bairro = viaCepModel.bairro ?? "";
                    cepAtualizarModel.localidade = viaCepModel.localidade ?? "";
                    cepAtualizarModel.uf = viaCepModel.uf ?? "";
                    await cepRepository.atualizar(cepAtualizarModel);
                  }
                  oberDados();
                  _formKey.currentState!.reset();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
