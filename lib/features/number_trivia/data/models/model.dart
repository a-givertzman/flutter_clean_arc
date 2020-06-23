import 'package:meta/meta.dart';

import '../../domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {

  NumberTriviaModel({
    @required String text,
    @required double number,
  }) : super(text: text, number: number);


  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {

    return NumberTriviaModel(
      text: json['text'],
      number: json['number'].toDouble(), 
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'number': number,
    };
  }
}