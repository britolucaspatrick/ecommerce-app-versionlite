import 'package:bertonlite/business/carrinhobusiness.dart';
import 'package:bertonlite/model/produto.dart';
import 'package:bertonlite/shared/styles.dart';
import 'package:bertonlite/wigdets/loading.dart';
import 'package:flutter/material.dart';

class Alert {
  //code 0 ERROR 1 CORRECT 2 INFORMATION 3 QUESTION

  static void showAlertDialog(BuildContext context, String msg, int code, {ProductCarrinho prod, bool dellCar}) {
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
                        code == 0 ? 'assets/cancel.png' :
                        code == 1 ? 'assets/tick.png' :
                        code == 2 ? 'assets/info.png' :
                        'assets/question.png',
                        width: 90, height: 90, ),
                      SizedBox(width: 10, height: 10,),
                      Padding(
                        padding: EdgeInsets.only(right: 15, left: 15),
                        child: Text(msg,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color:
                                code == 0 ? Colors.red :
                                code == 1 ? Colors.green :
                                code == 2 ? Colors.blue :
                                Colors.blue,
                                fontSize: 15)
                        ),
                      ),
                      code == 3 ?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FlatButton(
                                child: Text("Não",
                                    style: TextStyle(
                                        color:
                                        code == 0 ? Colors.red :
                                        code == 1 ? Colors.green :
                                        code == 2 ? Colors.blue :
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
                                        code == 0 ? Colors.red :
                                        code == 1 ? Colors.green :
                                        code == 2 ? Colors.blue :
                                        Colors.blue,
                                        fontSize: 15)),
                                onPressed: () {
                                  if (dellCar){
                                    Navigator.pop(context);
                                    Loading.start(context, 'Removendo produto...');
                                    CarrinhoBusiness.removeProdCar(prod)
                                        .catchError((onError){
                                      Alert.showAlertDialog(context, 'Erro ao remover produto', 0);
                                      Loading.dismiss(context);
                                    })
                                        .whenComplete((){
                                      Loading.dismiss(context);
                                    });
                                  }

                                },
                              )
                            ],
                          ) :
                      FlatButton(
                        child: Text("OK",
                            style: TextStyle(
                                color:
                                code == 0 ? Colors.red :
                                code == 1 ? Colors.green :
                                code == 2 ? Colors.blue :
                                Colors.blue,
                                fontSize: 15)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                )
            ),
          );
        }
    );
  }
}