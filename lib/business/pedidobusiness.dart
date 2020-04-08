import 'package:bertonlite/business/carrinhobusiness.dart';
import 'package:bertonlite/model/pedido.dart';
import 'package:bertonlite/model/produto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PedidoBusiness{

  static void post(List<ProductCarrinho> prod) {
    FirebaseAuth.instance.currentUser().then((user) {


      //INFO PEDIDO
      Firestore.instance.collection('pedidos')
          .add(Pedido(dt_entrega: null, dt_pedido: Timestamp.now(), userID: user.uid).toJson())
            .then((onValue){


        //GERAR PEDIDO ITENS
        prod.forEach((f){
          Firestore.instance.document('/pedidos/${onValue.documentID}/produtos/${f.documentID}')
              .setData(PedProduto(qtd: f.qtd, vl_unitario: f.vl_unitario).toJson());
        });
      });


    });

    //EXCLUIR PRODUTOS DO CARRINHO
    prod.forEach((f){
      CarrinhoBusiness.removeProdCar(f);
    });

    //EXCLUIR CARRINHO DE COMPRAS
    CarrinhoBusiness.deleteCarrinho();
  }


}