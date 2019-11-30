import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class CardListBloc extends BlocBase {
  var positionPage = BehaviorSubject<dynamic>();

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    super.dispose();
    positionPage.close();
  }

  void pageChange({int index}){
    positionPage.sink.add(index);
  }
}
