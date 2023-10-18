class CepsModel {
  List<UmCepModel> ceps = [];

  CepsModel(this.ceps);

  CepsModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      ceps = <UmCepModel>[];
      json['results'].forEach((v) {
        ceps.add(UmCepModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['results'] = ceps.map((v) => v.toJson()).toList();
    return data;
  }
}

class UmCepModel {
  String objectId = "";
  String createdAt = "";
  String updatedAt = "";
  String cep = "";
  String logradouro = "";
  String bairro = "";
  String localidade = "";
  String uf = "";

  UmCepModel(this.objectId, this.createdAt, this.updatedAt, this.cep,
      this.logradouro, this.bairro, this.localidade, this.uf);

  UmCepModel.criar(
      this.cep, this.logradouro, this.bairro, this.localidade, this.uf);

  UmCepModel.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    cep = json['cep'];
    logradouro = json['logradouro'];
    bairro = json['bairro'];
    localidade = json['localidade'];
    uf = json['uf'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = objectId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['cep'] = cep;
    data['logradouro'] = logradouro;
    data['bairro'] = bairro;
    data['localidade'] = localidade;
    data['uf'] = uf;
    return data;
  }

  Map<String, dynamic> toCreateJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cep'] = cep;
    data['logradouro'] = logradouro;
    data['bairro'] = bairro;
    data['localidade'] = localidade;
    data['uf'] = uf;
    return data;
  }
}
