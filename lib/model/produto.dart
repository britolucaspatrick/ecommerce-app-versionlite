import 'package:cloud_firestore/cloud_firestore.dart';

class Produto {
  String documentID;
  String descricao;
  bool isOferta;
  String nome;
  int qt_estoque;
  int qt_minimalsell;
  String url_imagem;
  double vl_unitario;
  String categoriaID;

  bool isFav = false;
  double rating = 5;

  Produto({
    this.documentID,
    this.descricao,
    this.isOferta,
    this.nome,
    this.qt_estoque,
    this.qt_minimalsell,
    this.url_imagem,
    this.vl_unitario,
    this.categoriaID,
  });

  Map<String, Object> toJson() {
    return {
      'documentID' : documentID,
      'descricao' : descricao,
      'isOferta' : isOferta,
      'nome': nome,
      'qt_estoque': qt_estoque,
      'qt_minimalsell': qt_minimalsell,
      'url_imagem': url_imagem,
      'vl_unitario': vl_unitario,
      'categoriaID': categoriaID,
    };
  }

  factory Produto.fromJson(Map<String, Object> doc) {
    Produto prod = new Produto(
      documentID: doc['documentID'],
      descricao: doc['descricao'],
      isOferta: doc['isOferta'],
      nome: doc['nome'],
      qt_estoque: doc['qt_estoque'],
      qt_minimalsell: doc['qt_minimalsell'],
      url_imagem: doc['url_imagem'],
      vl_unitario: doc['vl_unitario'],
      categoriaID: doc['categoriaID'],
    );
    return prod;
  }

  factory Produto.fromDocument(DocumentSnapshot doc) {
    return Produto.fromJson(doc.data);
  }
}

class QtSellCarrinho{
  int qtd;
  double vl_unitario;

  QtSellCarrinho({
    this.qtd,
    this.vl_unitario
  });

  Map<String, Object> toJson() {
    return {
      'vl_unitario': vl_unitario,
      'qtd': qtd,
    };
  }

  factory QtSellCarrinho.fromJson(Map<String, Object> doc) {
    QtSellCarrinho prod = new QtSellCarrinho(
      vl_unitario: doc['vl_unitario'],
      qtd: doc['qtd'],
    );
    return prod;
  }

  factory QtSellCarrinho.fromDocument(DocumentSnapshot doc) {
    return QtSellCarrinho.fromJson(doc.data);
  }
}

class ProductCarrinho {
  int qtd;
  double vl_unitario;
  String url_produc;
  String nome;
  String documentID;

  ProductCarrinho({
    this.qtd,
    this.vl_unitario,
    this.url_produc,
    this.nome,
    this.documentID
  });

  Map<String, Object> toJson() {
    return {
      'vl_unitario': vl_unitario,
      'qtd': qtd,
    };
  }

  factory ProductCarrinho.fromJson(Map<String, Object> doc) {
    ProductCarrinho prod = new ProductCarrinho(
      vl_unitario: doc['vl_unitario'],
      qtd: doc['qtd'],
    );
    return prod;
  }

  factory ProductCarrinho.fromDocument(DocumentSnapshot doc) {
    return ProductCarrinho.fromJson(doc.data);
  }
}