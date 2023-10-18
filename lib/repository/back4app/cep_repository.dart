import 'package:appcep/model/cep_model.dart';
import 'package:appcep/repository/back4app/back4app_custon_dio.dart';

class CepRepository {
  final _custonDio = Back4AppCustonDio();

  CepRepository();

  Future<CepsModel> obter() async {
    var url = "/Ceps";
    var result = await _custonDio.dio.get(url);
    return CepsModel.fromJson(result.data);
  }

  Future<CepsModel> obterUmCep(String cep) async {
    var url = "/Ceps?where={\"cep\":\"$cep\"}";
    var result = await _custonDio.dio.get(url);
    return CepsModel.fromJson(result.data);
  }

  Future<void> criar(UmCepModel cepModel) async {
    try {
      await _custonDio.dio.post("/Ceps", data: cepModel.toCreateJson());
    } catch (e) {
      throw e;
    }
  }

  Future<void> atualizar(UmCepModel cepModel) async {
    try {
      await _custonDio.dio
          .put("/Ceps/${cepModel.objectId}", data: cepModel.toCreateJson());
    } catch (e) {
      throw e;
    }
  }

  Future<void> remover(String objectId) async {
    try {
      await _custonDio.dio.delete("/Ceps/${objectId}");
    } catch (e) {
      throw e;
    }
  }
}
