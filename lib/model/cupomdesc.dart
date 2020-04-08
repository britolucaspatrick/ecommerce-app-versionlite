
import 'package:cloud_firestore/cloud_firestore.dart';

class CupomDesc {
  String code;
  int codeStatus;     //0-ativo 1-desativado
  double vl_desconto;
  int tp_cupom;       //0-percentual 1-valor

  CupomDesc({
    this.code,
    this.codeStatus,
    this.vl_desconto,
    this.tp_cupom
  });

  Map<String, Object> toJson() {
    return {
      'code' : code,
      'codeStatus' : codeStatus,
      'vl_desconto' : vl_desconto,
      'tp_cupom' : tp_cupom,
    };
  }

  factory CupomDesc.fromJson(Map<String, Object> doc) {
    CupomDesc cup = new CupomDesc(
      code: doc['code'],
      codeStatus: doc['codeStatus'],
      vl_desconto: doc['vl_desconto'],
      tp_cupom: doc['tp_cupom'],
    );
    return cup;
  }

  factory CupomDesc.fromDocument(DocumentSnapshot doc) {
    return CupomDesc.fromJson(doc.data);
  }
}
