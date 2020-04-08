import 'package:cloud_firestore/cloud_firestore.dart';

class Pessoa {
  String nome;
  String cpf;
  String logradouro;
  String bairro;
  String numero;
  String cidade;
  String estado;
  String complemento;
  String cep;
  String url_perfil;
  String telefone;
  String userID;

  Pessoa({
    this.nome = '',
    this.cpf = '',
    this.logradouro = '',
    this.bairro = '',
    this.numero = '',
    this.cidade = '',
    this.estado = '',
    this.complemento = '',
    this.cep = '',
    this.url_perfil = '',
    this.telefone = '',
    this.userID = ''
  });

  Map<String, Object> toJson() {
    return {
      'nome' : nome,
      'cpf' : cpf,
      'logradouro' : logradouro,
      'bairro': bairro,
      'numero': numero,
      'cidade': cidade,
      'estado': estado,
      'complemento': complemento,
      'cep': cep,
      'url_perfil': url_perfil,
      'telefone': telefone,
      'userID': userID,
    };
  }

  factory Pessoa.fromJson(Map<String, Object> doc) {
    Pessoa pessoa = new Pessoa(
      nome: doc['nome'],
      cpf: doc['cpf'],
      logradouro: doc['logradouro'],
      bairro: doc['bairro'],
      numero: doc['numero'],
      cidade: doc['cidade'],
      estado: doc['estado'],
      complemento: doc['complemento'],
      cep: doc['cep'],
      url_perfil: doc['url_perfil'],
      telefone: doc['telefone'],
      userID: doc['userID'],
    );
    return pessoa;
  }

  factory Pessoa.fromDocument(DocumentSnapshot doc) {
    return Pessoa.fromJson(doc.data);
  }
}