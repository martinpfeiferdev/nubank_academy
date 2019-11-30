import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class ConfigBloc extends BlocBase {
  final $config = BehaviorSubject<DocumentModel>();
  Observable<DocumentSnapshot> outConfig;
  DocumentModel _documentModel;

  ConfigBloc() {
    outConfig = $config.switchMap((v) => Firestore.instance
        .collection(v.contas)
        .document(v.documents)
        .snapshots());
    getAccount();
  }

  void getAccount() {
    _documentModel = DocumentModel('contas', "IIqfbEVioPqXQcBWsgYz");
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
