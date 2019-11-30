import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LogoWidget extends StatefulWidget {
  const LogoWidget({
    Key key,
  }) : super(key: key);

  _LogoState createState() => _LogoState();
}

class _LogoState extends State<LogoWidget> {
  String nomePerfil = 'Não definido';

  @override
  void initState() {
    _getDadosPerfil();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              "assets/logo.svg",
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              nomePerfil,
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Icon(
          Icons.keyboard_arrow_down,
          color: Colors.white.withOpacity(0.54),
          size: 35,
        ),
      ],
    );
  }

  Future _getDadosPerfil() async {
      Firestore.instance.collection('usuarios').document("dFg9PefipCrRwKdxqOQ5").snapshots().listen((DocumentSnapshot snapShot) {
        setState(() {
          nomePerfil = snapShot.data['nome'];
        });
      });
  }
}
