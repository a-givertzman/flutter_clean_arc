import 'package:clean_arcitecture/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/number_trivia_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  // const NumberTriviaPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Number Trivia')),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              // Верхняя половина
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  // return LoadingWidget(message: 'Подожди, загружаю данные...');
                  // return TriviaDisplay(numberTrivia: NumberTrivia(text: 'Какой то текст с инфой о числе. Какой то текст с инфой о числе. Какой то текст с инфой о числе. Какой то текст с инфой о числе. Какой то текст с инфой о числе. Какой то текст с инфой о числе. Какой то текст с инфой о числе. Какой то текст с инфой о числе.', number: 808));
                  // return MessageDisplay(message: 'Ошибка! \nНеизвестный стейт.');
                  if (state is Initial) {
                    return MessageDisplay(message: state.message);
                  } else if (state is Loading) {
                    return LoadingWidget(message: state.message);
                  } else if (state is Loaded) {
                    return TriviaDisplay(numberTrivia: state.numberTrivia);
                  } else if (state is Error) {
                    return MessageDisplay(message: state.message);
                  } else {
                    return MessageDisplay(
                        message: 'Ошибка! \nНеизвестный стейт.');
                  }
                },
              ),
              SizedBox(height: 20),
              // Нижняя половина
              TriviaControls(),
            ],
          ),
        ),
      ),
    );
  }
}
