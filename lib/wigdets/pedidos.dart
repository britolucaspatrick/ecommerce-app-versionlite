import 'package:bertonlite/model/pedido.dart';
import 'package:bertonlite/shared/styles.dart';
import 'package:bertonlite/wigdets/nodata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Pedidos {

  static void show(BuildContext context, List<Pedido> pedidos) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Container(
                decoration: boxDecorationContainer,
                height: 300,
                width: 315,
                child: Card(
                  elevation: 0,
                    child: ListView(
                      children: <Widget>[
                        Text(
                          'Pedidos',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 10),
                        pedidos.length == 0 ?
                        NoData(labelText: 'Nenhum encontrato') :
                        ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: pedidos.length,
                          itemBuilder:(BuildContext context, int index) =>
                              Column(
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      '${pedidos[index].Status_desc}',
                                      style: TextStyle(
                                        color: pedidos[index].st_registro == 0 ?
                                        Colors.green :
                                        pedidos[index].st_registro == 1 ?
                                        Colors.orange :
                                        pedidos[index].st_registro == 2 ?
                                        Colors.blue :
                                        Colors.red,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    subtitle: Text(
                                      pedidos[index].dt_entrega == null ?
                                      "Dt. pedido: ${pedidos[index].dt_pedido.toDate().day}/"
                                          "${pedidos[index].dt_pedido.toDate().month}/"
                                          "${pedidos[index].dt_pedido.toDate().year} "
                                          "\u00B7 "
                                          "${pedidos[index].dt_pedido.toDate().hour}:"
                                          "${pedidos[index].dt_pedido.toDate().minute} "
                                          "\u00B7 "
                                          "Nº ${pedidos[index].documentID.substring(0,4).toUpperCase()}"
                                          :
                                      "Dt. entrega: ${pedidos[index].dt_entrega.toDate().day}/"
                                          "${pedidos[index].dt_entrega.toDate().month}/"
                                          "${pedidos[index].dt_entrega.toDate().year} "
                                          "\u00B7 "
                                          "${pedidos[index].dt_entrega.toDate().hour}:"
                                          "${pedidos[index].dt_entrega.toDate().minute} "
                                          "\u00B7 "
                                          "Nº ${pedidos[index].documentID.substring(0,4).toUpperCase()}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    leading: Icon(
                                      pedidos[index].st_registro == 0 ?
                                      Icons.check :
                                      pedidos[index].st_registro == 1 ?
                                      Icons.call_split :
                                      pedidos[index].st_registro == 2 ?
                                      Icons.insert_emoticon :
                                      Icons.close,
                                      color: pedidos[index].st_registro == 0 ?
                                      Colors.green :
                                      pedidos[index].st_registro == 1 ?
                                      Colors.orange :
                                      pedidos[index].st_registro == 2 ?
                                      Colors.blue :
                                      Colors.red,
                                    ),
                                  ),

                                ],
                              ),
                        ),
                      ],
                  )
                )
            ),
          );
        }
    );
  }
}







