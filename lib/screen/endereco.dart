
import 'package:bertonlite/business/auth.dart';
import 'package:bertonlite/business/pedidobusiness.dart';
import 'package:bertonlite/model/pessoa.dart';
import 'package:bertonlite/model/produto.dart';
import 'package:bertonlite/screen/search.dart';
import 'package:bertonlite/wigdets/alert.dart';
import 'package:bertonlite/wigdets/entryfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class Endereco extends StatefulWidget{
  final List<ProductCarrinho> carrFinal;

  const Endereco({Key key, this.carrFinal}) : super(key: key);

  @override
  _EnderecoState createState() => _EnderecoState();
}

class _EnderecoState extends State<Endereco>  {
  final _formKey = GlobalKey<FormState>();
  TextEditingController cep = new MaskedTextController(mask: '00.000-000',);
  TextEditingController cpf = new MaskedTextController(mask: '000.000.000-00',);
  TextEditingController log = new TextEditingController();
  TextEditingController bai = new TextEditingController();
  TextEditingController num = new TextEditingController();
  TextEditingController com = new TextEditingController();
  TextEditingController nome = new TextEditingController();
  TextEditingController telefone = new MaskedTextController(mask: '(00) 0 0000-0000',);
  FirebaseUser user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPessoa();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dados Cliente',
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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[
            ListTile(
              title: Text(
                "Dados pessoais".toUpperCase(),
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            EntryField(title: 'Nome', controller: nome, isNome: true,),
            EntryField(title: 'Telefone', controller: telefone, keyboardType: TextInputType.number, isTelefone: true, ),
            EntryField(title: 'CPF', controller: cpf, keyboardType: TextInputType.number, isCPF: true,),

            Divider(),
            ListTile(
              title: Text(
                "Endereço de entrega".toUpperCase(),
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            EntryField(title: 'Logradouro', controller: log,),
            EntryField(title: 'CEP', controller: cep, keyboardType: TextInputType.number),
            EntryField(title: 'Bairro', controller: bai,),
            EntryField(title: 'Número', controller: num,),
            EntryField(title: 'Complemento', controller: com, validator: false,),

            _submitButton()
          ],
        ),
      )
    );
  }

  Widget _submitButton(){
    return GestureDetector(
      onTap: () {
        if (_formKey.currentState.validate()){
          PedidoBusiness.post(widget.carrFinal);
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SearchScreen()));
          Alert.showAlertDialog(context, 'Pedido gerado com sucesso', 2);
        }
      },
      child: Container(
          width: 150,
          height: 50,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                'Gerar pedido'.toUpperCase(),
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          )
      ),
    );
  }

  void getPessoa() async {
    Auth.getCurrentFirebaseUser().then((onValue) {
      setState(() {
        user = onValue;
      });

      Stream<Pessoa> pessoa = Auth.getUser(user.uid);
      pessoa.forEach((f){
        setState(() {
          nome.text = f.nome;
          telefone.text = f.telefone;
          cpf.text = f.cpf;

          log.text = f.logradouro;
          bai.text = f.bairro;
          num.text = f.numero;
          cep.text = f.cep;
        });
      });
    });
  }
}