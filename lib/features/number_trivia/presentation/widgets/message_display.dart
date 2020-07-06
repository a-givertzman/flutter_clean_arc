import 'package:flutter/material.dart';


class MessageDisplay extends StatelessWidget {
  final String message;

  const MessageDisplay({
    Key key,
    @required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,     // помещаемся в треть окна приложения
      child: Center(                                      // центрируем виджет
        child: SingleChildScrollView(                     // контент виджета прокручивается
          child: Text(                                    // тип контента - текст
            message,
            style: TextStyle(fontSize: 25),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}