import 'package:bertonlite/model/produto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CarrinhoBusiness {

  static void postNewProductCarrinho({String prodID, int prodQtd, double prodVl}) async {
    FirebaseAuth.instance.currentUser().then((user) async {
      await Firestore.instance.document('/carrinhoUser/${user.uid}/produtos/${prodID}').setData(ProductCarrinho(qtd: prodQtd, vl_unitario: prodVl).toJson());
    });
  }

  static Future<void> removeProdCar(ProductCarrinho prodCar) async  {
    FirebaseAuth.instance.currentUser().then((user) async  {
      return Firestore.instance
          .collection('carrinhoUser')
          .document('${user.uid}')
          .collection('produtos')
          .document('${prodCar.documentID}')
          .delete();
    });
  }

  static Future<void> deleteCarrinho() async   {
    FirebaseAuth.instance.currentUser().then((user) async   {
       return Firestore.instance
          .collection('carrinhoUser')
          .document('${user.uid}')
          .delete();
    });
  }
}
