import 'package:flutter/material.dart';


class LoadingWidget extends StatelessWidget {
  final String message;

  const LoadingWidget({
    Key key,
    @required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,     // помещаемся в треть окна приложения
      child: Center(                                      // центрируем виджет
        child: SingleChildScrollView(                     // контент виджета прокручивается
          child: Column(
            children: <Widget>[
              Text(                                    // тип контента - текст
                message,
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
