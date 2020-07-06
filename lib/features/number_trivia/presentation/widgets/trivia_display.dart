import 'package:flutter/material.dart';

import '../../domain/entities/number_trivia.dart';


class TriviaDisplay extends StatelessWidget {
  final NumberTrivia numberTrivia;

  const TriviaDisplay({
    Key key,
    @required this.numberTrivia,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,     // помещаемся в треть окна приложения
      child: Column(
        children: <Widget>[
          Center(
            child: Text(
              numberTrivia.number.toString(),
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Center(                                      // центрируем виджет
              child: SingleChildScrollView(                     // контент виджета прокручивается
                child: Text(                                    // тип контента - текст
                  numberTrivia.text,
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}