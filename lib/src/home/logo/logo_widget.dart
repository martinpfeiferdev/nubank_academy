import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LogoWidget extends StatefulWidget {
  // SECURITY: User ID should be passed from authenticated context
  final String userId;

  const LogoWidget({
    Key key,
    this.userId,
  }) : super(key: key);

  _LogoState createState() => _LogoState();
}

class _LogoState extends State<LogoWidget> {
  String nomePerfil = 'Não definido';
  StreamSubscription<DocumentSnapshot> _userSubscription;

  @override
  void initState() {
    super.initState();
    _getDadosPerfil();
  }

  @override
  void dispose() {
    // SECURITY FIX: Cancel subscription to prevent memory leak
    _userSubscription?.cancel();
    super.dispose();
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
    // SECURITY FIX: User ID should come from authenticated user context
    // For now, only fetch if userId is provided
    if (widget.userId == null || widget.userId.isEmpty) {
      debugPrint('SECURITY WARNING: No user ID provided. User should be authenticated first.');
      setState(() {
        nomePerfil = 'Usuário';
      });
      return;
    }

    try {
      // SECURITY FIX: Proper error handling and subscription management
      _userSubscription = Firestore.instance
          .collection('usuarios')
          .document(widget.userId)
          .snapshots()
          .listen(
            (DocumentSnapshot snapShot) {
              if (!mounted) return;

              setState(() {
                // SECURITY FIX: Validate data before using it
                if (snapShot.exists && snapShot.data != null && snapShot.data.containsKey('nome')) {
                  nomePerfil = snapShot.data['nome'] ?? 'Usuário';
                } else {
                  nomePerfil = 'Usuário';
                }
              });
            },
            onError: (error) {
              debugPrint('Error fetching user profile: $error');
              if (!mounted) return;
              setState(() {
                nomePerfil = 'Erro ao carregar';
              });
            },
          );
    } catch (e) {
      debugPrint('Exception in _getDadosPerfil: $e');
      setState(() {
        nomePerfil = 'Erro ao carregar';
      });
    }
  }
}
