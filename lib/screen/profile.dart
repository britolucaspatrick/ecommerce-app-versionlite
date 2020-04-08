import 'package:bertonlite/business/auth.dart';
import 'package:bertonlite/screen/loginpage.dart';
import 'package:bertonlite/shared/styles.dart';
import 'package:bertonlite/wigdets/alert.dart';
import 'package:bertonlite/wigdets/loading.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget{
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile>  {
  bool prodOferta  = false;
  bool pedExp  = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((onValue){
      var aux = onValue.getBool('prodOferta');
      var aux1 = onValue.getBool('pedExp');
      if (aux == null)
        aux = true;
      if (aux1 == null)
        aux1 = true;

      setState(() {
        prodOferta = aux;
        pedExp = aux1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: Container(
              decoration: boxDecorationContainer,
              height: 320,
              width: 250,
              child: Card(
                elevation: 0,
                child: ListView(
                  children: <Widget>[
                    Text(
                      'Notificações',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 10),

                    ListTile(
                      title: Text(
                        "Produtos na oferta",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      trailing: Switch(
                        value: prodOferta,
                        onChanged: (v) async {
                          setState(() {
                            prodOferta = v;
                          });
                          SharedPreferences.getInstance().then((onValue){
                            onValue.setBool('prodOferta', prodOferta);
                          });
                        },
                        activeColor: Theme.of(context).accentColor,
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "Pedido saiu para entrega",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      trailing: Switch(
                        value: pedExp,
                        onChanged: (v) async {
                          setState(() {
                            pedExp = v;
                          });
                          SharedPreferences.getInstance().then((onValue){
                            onValue.setBool('pedExp', pedExp);
                          });
                        },
                        activeColor: Theme.of(context).accentColor,
                      ),
                    ),
                    ListTile(
                      title: Text('Sair da conta',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontStyle: FontStyle.normal,
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onTap: (){
                        Auth.signOut();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                      },
                    ),
                    ListTile(
                      title: Text('Esqueceu a senha',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontStyle: FontStyle.normal,
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onTap: (){
                        Loading.start(context, 'Enviando email...');
                        Auth.getCurrentFirebaseUser().then((onValue){
                          bool error = false;
                          Auth.sendPasswordResetEmail(onValue.email)
                              .catchError((onError){
                            String exception = Auth.getExceptionText(onError);
                            Alert.showAlertDialog(context, exception.toString(), 0);
                            error = true;
                            Loading.dismiss(context);
                          })
                              .whenComplete((){
                            if (!error){
                              Loading.dismiss(context);
                              Alert.showAlertDialog(context, 'Verifique sua caixa de email para alterar a senha', 1);
                            }
                          });
                        });
                      },
                    )
                  ],
                ),
              )
          )
        )
      ],
    );
  }


}