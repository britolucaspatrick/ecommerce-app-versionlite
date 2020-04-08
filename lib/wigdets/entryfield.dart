import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EntryField extends StatelessWidget{
  String title;
  TextEditingController controller;
  bool isPassword;
  bool validator;
  bool autovalidate;
  TextInputType keyboardType;
  bool isTelefone;
  bool isCPF;
  bool isNome;

  EntryField({Key key,this.isNome = false, this.isCPF = false, this.title, this.controller, this.isPassword = false, this.validator = true, this.autovalidate = true, this.keyboardType, this.isTelefone = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          TextFormField(
              validator: (value) {
                if (!validator)
                  return null;
                if (value == null || value == '' || value.isEmpty)
                  return 'Obrigatório informar';
                else if (value.length < 3 && isNome)
                  return 'Deve conter pelo menos 3 letras';
                else if (isTelefone && value.length != 16)
                  return 'Informe os 11 dígitos';
                else if (isCPF && value.length != 14)
                  return 'Informe os 11 dígitos';

              },
              autovalidate: autovalidate,
              controller: controller,
              obscureText: isPassword,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

}