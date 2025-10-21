import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/foundation.dart';

class ConfigBloc extends BlocBase {
  final $config = BehaviorSubject<DocumentModel>();
  Observable<DocumentSnapshot> outConfig;
  DocumentModel _documentModel;

  // SECURITY FIX: Account ID should come from authenticated user
  final String accountId;

  ConfigBloc({this.accountId}) {
    outConfig = $config.switchMap((v) => Firestore.instance
        .collection(v.contas)
        .document(v.documents)
        .snapshots());
    getAccount();
  }

  void getAccount() {
    // SECURITY FIX: Use authenticated user's account ID instead of hardcoded value
    if (accountId == null || accountId.isEmpty) {
      debugPrint('SECURITY WARNING: No account ID provided. User should be authenticated first.');
      // Don't load any account if not authenticated
      return;
    }

    _documentModel = DocumentModel('contas', accountId);
    $config.add(_documentModel);
  }

  @override
  void dispose() {
    super.dispose();
    $config.close();
  }
}

class DocumentModel {
  final String contas;
  final String documents;

  DocumentModel(this.contas, this.documents);
}
