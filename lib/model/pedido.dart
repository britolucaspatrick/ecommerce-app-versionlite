import 'package:cloud_firestore/cloud_firestore.dart';

class Pedido{
  Timestamp dt_pedido;
  Timestamp dt_entrega;
  String userID;
  int st_registro;
  String documentID;

  String get Status_desc{
    if (st_registro == 0)
      return "Aberto";
    else if (st_registro == 1)
      return "Em entrega";
    else if (st_registro == 2)
      return "Finalizado";
    else if (st_registro == 3)
      return "Cancelado";
  }

  Pedido({
    this.userID,
    this.dt_entrega,
    this.dt_pedido,
    this.st_registro = 0
  });

  Map<String, Object> toJson() {
    return {
      'userID' : userID,
      'dt_pedido' : dt_pedido,
      'dt_entrega' : dt_entrega,
      'st_registro' : st_registro,
    };
  }

  factory Pedido.fromJson(Map<String, Object> doc) {
    Pedido ped = new Pedido(
      userID: doc['userID'],
      dt_pedido: doc['dt_pedido'],
      dt_entrega: doc['dt_entrega'],
      st_registro: doc['st_registro'],
    );
    return ped;
  }

  factory Pedido.fromDocument(DocumentSnapshot doc) {
    return Pedido.fromJson(doc.data);
  }
}

class PedProduto{
  int qtd;
  double vl_unitario;

  PedProduto({
    this.vl_unitario,
    this.qtd
  });

  Map<String, Object> toJson() {
    return {
      'vl_unitario' : vl_unitario,
      'qtd' : qtd,
    };
  }

  factory PedProduto.fromJson(Map<String, Object> doc) {
    PedProduto ped = new PedProduto(
      vl_unitario: doc['vl_unitario'],
      qtd: doc['qtd'],
    );
    return ped;
  }

  factory PedProduto.fromDocument(DocumentSnapshot doc) {
    return PedProduto.fromJson(doc.data);
  }
}