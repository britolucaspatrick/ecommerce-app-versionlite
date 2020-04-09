import 'dart:async';
import 'package:bertonlite/business/carrinhobusiness.dart';
import 'package:bertonlite/model/produto.dart';
import 'package:bertonlite/screen/endereco.dart';
import 'package:bertonlite/shared/styles.dart';
import 'package:bertonlite/utils/functions.dart';
import 'package:bertonlite/wigdets/alert.dart';
import 'package:bertonlite/wigdets/loading.dart';
import 'package:bertonlite/wigdets/nodata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with AutomaticKeepAliveClientMixin<CartScreen >{
  List<ProductCarrinho> prodCar = new List<ProductCarrinho>();
  double total = 0.0;

  @override
  void initState() {
    super.initState();
    getCarrinho();
  }

  @override
  void dispose() {
    super.dispose();
    prodCar = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Carrinho',
          style: TextStyle(
            color: Colors.black54,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Colors.black54,
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(bottom: 130),
        child: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (prodCar.length > 0)
                  ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: prodCar.length,
                    itemBuilder: (BuildContext context, int index) => Column (
                      children: <Widget>[
                        Divider(height: 10, indent: 70, endIndent: 15,),
                        ListTile(
                          title: Text(
                            "${prodCar[index].nome}",
                            style: TextStyle(
                              fontFamily: "Raleway",
                            ),
                          ),
                          leading: Container(
                            child: CircleAvatar(
                              foregroundColor: Colors.transparent,
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(
                                "${prodCar[index].url_produc}",
                              ),
                            ),
                            width: 60,
                            height: 60,
                            decoration: decoratioShadowAndCircularRadius,
                          ),
                          subtitle: Text("R\u0024 ${Functions.formatDoubleToMoney(prodCar[index].vl_unitario)} "
                              "Qtd: ${prodCar[index].qtd}"),
                          trailing: GestureDetector(
                            onTap: (){
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Center(
                                      child: Container(
                                          decoration: boxDecorationContainer,
                                          height: 300,
                                          width: 250,
                                          child: Card(
                                            elevation: 0,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Image.asset(
                                                  'assets/question.png',
                                                  width: 90, height: 90, ),
                                                SizedBox(width: 10, height: 10,),
                                                Padding(
                                                  padding: EdgeInsets.only(right: 15, left: 15),
                                                  child: Text('Remover o produto do carrinho?',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color:
                                                          Colors.blue,
                                                          fontSize: 15)
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    FlatButton(
                                                      child: Text("Não",
                                                          style: TextStyle(
                                                              color:
                                                              Colors.blue,
                                                              fontSize: 15)),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    FlatButton(
                                                      child: Text("Sim",
                                                          style: TextStyle(
                                                              color:
                                                              Colors.blue,
                                                              fontSize: 15)),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        Loading.start(context, 'Removendo produto...');
                                                        CarrinhoBusiness.removeProdCar(prodCar[index])
                                                            .catchError((onError){
                                                          Alert.showAlertDialog(context, 'Erro ao remover produto', 0);
                                                          Loading.dismiss(context);
                                                        })
                                                            .whenComplete((){
                                                          Loading.dismiss(context);
                                                        });
                                                        getCarrinho();
                                                      },
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                      ),
                                    );
                                  }
                              );
                            },
                            child: Icon(Icons.clear, color: Colors.redAccent,),
                          ),
                        )
                      ],
                    ),
                  )
                else
                  NoData(labelText: 'Nenhum produto foi adicionado'),

              ],
            ),
          ],
        )
      ),

      bottomSheet: Card(
        elevation: 4.0,
        child: Container(
          height: 127,
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(

                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: TextField(
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color: Colors.grey[200],),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[200],),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      hintText: "Cupom desconto",
                      prefixIcon: Icon(
                        Icons.redeem,
                        color: Theme.of(context).accentColor,
                      ),
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Total",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          "R\u0024 ${Functions.formatDoubleToMoney(total)} ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  _submitButton()
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _submitButton(){
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Endereco(carrFinal: prodCar,)));
      },
      child: Container(
          width: 150,
          height: 50,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color.fromRGBO(68, 208, 98, 1), Color.fromRGBO(61, 158, 88, 1)])),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                'Endereço',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              Icon(Icons.arrow_forward, color: Colors.white,)
            ],
          )
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void getCarrinho() {
    setState(() {
      prodCar.clear();
      total = 0.0;
    });

    FirebaseAuth.instance.currentUser().then((user)  {
      Firestore.instance
          .collection('carrinhoUser')
          .document('${user.uid}')
          .collection('produtos')
          .getDocuments()
          .then((querySnapshot) {
        querySnapshot.documents.forEach((f) {
          //BUSCAR O NOME, URL DO PRODUTO
          Firestore.instance.collection('produtos').document('${f.documentID}').get().then((aa){
            Produto aux = Produto.fromJson(aa.data);
            QtSellCarrinho qtSell = QtSellCarrinho.fromJson(f.data);
            setState(() {
              prodCar.add(new ProductCarrinho(
                  qtd: qtSell.qtd,
                  vl_unitario: qtSell.vl_unitario,
                  url_produc: aux.url_imagem,
                  nome: aux.nome,
                  documentID: f.documentID
              ));
            });

            getTotal(prodCar);
          });
        });
      });
    });
  }

  void getTotal(List<ProductCarrinho> prodCar) {
    prodCar.forEach((f){
      total += f.vl_unitario * f.qtd;
    });

    setState(() {
      total;
    });
  }



}
