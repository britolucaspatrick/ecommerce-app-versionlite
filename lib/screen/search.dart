import 'package:bertonlite/business/auth.dart';
import 'package:bertonlite/model/pedido.dart';
import 'package:bertonlite/model/produto.dart';
import 'package:bertonlite/screen/cart.dart';
import 'package:bertonlite/screen/loginpage.dart';
import 'package:bertonlite/screen/productpage.dart';
import 'package:bertonlite/screen/profile.dart';
import 'package:bertonlite/wigdets/alert.dart';
import 'package:bertonlite/wigdets/loading.dart';
import 'package:bertonlite/wigdets/pedidos.dart';
import 'package:bertonlite/shared/styles.dart';
import 'package:bertonlite/utils/functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with AutomaticKeepAliveClientMixin<SearchScreen>{
  final TextEditingController _searchControl = new TextEditingController();
  List<Produto> produtos = new List<Produto>();
  List<Produto> produtosTemp = new List<Produto>();
  List<Pedido> pedidos = new List<Pedido>();

  @override
  void initState() {
    super.initState();
    getProdutos();
  }

  @override
  void dispose() {
    super.dispose();
    produtos = null;
    produtosTemp = null;
    pedidos = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Sua MARCA',
            style: TextStyle(
              color: Colors.black54,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(onPressed: () => showDialog(context: context, child: Profile()),
              icon: Icon(Icons.person, color: Colors.black45,)
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                setState(() {
                  pedidos.clear();
                });
                Loading.start(context, 'Carregando pedidos...');
                Auth.getCurrentFirebaseUser().then((onValue){
                  Firestore.instance.collection('pedidos')
                      .where('userID', isEqualTo: '${onValue.uid}')
                      .getDocuments()
                      .then((querySnapshot) {
                    querySnapshot.documents.forEach((f) {
                      Pedido aux = Pedido.fromJson(f.data);
                      aux.documentID = f.documentID;

                      setState(() {
                        pedidos.add(aux);
                      });
                    });
                    Loading.dismiss(context);
                    Pedidos.show(context, pedidos);

                  }).catchError((onError){
                    Loading.dismiss(context);
                    String msg = Auth.getExceptionText(onError);
                    Alert.showAlertDialog(context, msg, 0);

                  });

                }).catchError((onError){
                  Loading.dismiss(context);
                  String msg = Auth.getExceptionText(onError);
                  Alert.showAlertDialog(context, msg, 0);

                });
              },
              child: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(Icons.shopping_cart, color: Colors.black45,)
              ),
            ),

            GestureDetector(
              onTap: () {
                Alert.showAlertDialog(context, 'Esse aplicativo é um demonstrativo, '
                    'serve de exemplo de como seria a venda e logística dos seus produtos. '
                    'Contate o fornecedor do sistema, faça um orçamento e comece a vender seus produtos na sua região com seu aplicativo.', 2);
              },
              child: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(Icons.info_outline, color: Colors.black45,)
              ),
            ),
          ],
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.only(right: 15, left: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: Card(
                elevation: 6.0,
                child: TextField(
                  onChanged: (value){
                    initiateSearch(value);
                  },
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(color: Colors.white,),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white,),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Buscar...",
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.black54,
                    ),
                    hintStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.black54,
                    ),
                  ),
                  maxLines: 1,
                  controller: _searchControl,
                ),
              ),
            ),

            SizedBox(height: 10),

            ListView.builder(
              shrinkWrap: true,
              primary: false,
              physics: NeverScrollableScrollPhysics(),
              itemCount: produtosTemp == null ? 0 : produtosTemp.length,
              itemBuilder: (BuildContext context, int index) => Column(
                children: <Widget>[
                  Divider(height: 10, indent: 70, endIndent: 15,),
                  ListTile(
                    title: Text(
                      "${produtosTemp[index].nome}",
                      style: TextStyle(
                        fontFamily: "Raleway",
                      ),
                    ),
                    leading: Container(
                      child: CircleAvatar(
                        foregroundColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(
                          "${produtosTemp[index].url_imagem}",
                        ),
                      ),
                      width: 60,
                      height: 60,
                      decoration: decoratioShadowAndCircularRadius,
                    ),
                    subtitle: Text("R\u0024 ${Functions.formatDoubleToMoney(produtosTemp[index].vl_unitario)}"),
                    trailing: Icon(Icons.add_shopping_cart),
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProductPage(productData: produtosTemp[index],)));
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),
          ],
        ),
        floatingActionButton: _submitButton()
    );
  }

  @override
  bool get wantKeepAlive => true;

  initiateSearch(value) {
    value.toString().length == 0 ?
    produtosTemp = produtos :
    produtosTemp = new List<Produto>();

    produtos.forEach((element) {
      if (element.nome.toLowerCase().contains(value.toString().toLowerCase())) {
        setState(() {
          produtosTemp.add(element);
        });
      }
    });
  }

  getProdutos() async{
    try {
      produtos.clear();
      await Firestore.instance
          .collection("produtos")
          .getDocuments()
          .then((querySnapshot) {
        querySnapshot.documents.forEach((f) {
          setState(() {
            f.data["documentID"] = f.documentID;
            produtos.add(Produto.fromJson(f.data));
            produtosTemp = produtos;
          });
        });
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {}
    }
  }

  Widget _submitButton(){
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen()));
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
                'Carrinho',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              Icon(Icons.arrow_forward, color: Colors.white,)
            ],
          )
      ),
    );
  }

}
