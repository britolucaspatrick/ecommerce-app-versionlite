import 'package:flutter/cupertino.dart';

class NoData extends StatelessWidget {
  final String labelText;

  const NoData({Key key, this.labelText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage("assets/nodata.png"),
              height: 45,
              width: 45,
            ),
            Text(labelText)
          ],
        ));
  }
}
