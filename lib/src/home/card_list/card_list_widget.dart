import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nubank_layout/src/home/card_list/card_list_bloc.dart';

import 'card1/card1_widget.dart';
import 'card3/card3_widget.dart';

class CardListWidget extends StatefulWidget {
  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardListWidget> {
  List<Widget> _pages = [
    Card1(),
    Card3()
  ];

  ScrollController _scrollController = new ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  CardListBloc bloc = CardListBloc();

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -60),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SingleChildScrollView(
              physics: PageScrollPhysics(),
              scrollDirection: Axis.horizontal,
              controller: _scrollController,      // Where I pin the ScrollController
              child: Row(
                children: _pages,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DotsIndicator(
                  dotsCount: 2,
                  position: 0,
                  decorator: DotsDecorator(
                    size: Size(4, 4),
                    activeSize: Size(5, 5),
                    color: Colors.white54,
                    activeColor: Colors.white,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

_teste() {
  print('olpa');
}