import 'package:bertonlite/business/auth.dart';
import 'package:bertonlite/screen/search.dart';
import 'package:bertonlite/wigdets/alert.dart';
import 'package:bertonlite/wigdets/entryfield.dart';
import 'package:bertonlite/wigdets/loading.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = new TextEditingController();
  TextEditingController senha = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/welcome.png', width: 200, height: 200),
                    _emailPasswordWidget(),
                    _submitButton(),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        onPressed: () {
                          if (email.text.trim().isEmpty){
                            Alert.showAlertDialog(context, 'Informe um email', 0);
                          }else{
                            bool error = false;
                            Loading.start(context, 'Enviando email...');
                            Auth.sendPasswordResetEmail(email.text.trim())
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
                          }
                        },
                        child: Text('Esqueceu a senha?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }

  Widget _submitButton(){
    return GestureDetector(
      onTap: () {
        if (_formKey.currentState.validate()){
          Loading.start(context, 'Efetuando login...');
          bool error = false;
          try{
            Auth.signUp(email.text.trim(), senha.text.trim());
          }catch(ex){}
          Auth.signIn(email.text.trim(), senha.text.trim())
              .catchError((onError){
            String exception = Auth.getExceptionText(onError);
            Loading.dismiss(context);
            Alert.showAlertDialog(context, exception.toString(), 0, );
            error = true;
          }).whenComplete((){
            if (!error)
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SearchScreen()));
          });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
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
        child: Text(
          'Entrar',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        EntryField(controller: email, title: 'Email', validator: true,),
        EntryField(controller: senha, title: 'Senha', isPassword: true, validator: true),
      ],
    );
  }

}