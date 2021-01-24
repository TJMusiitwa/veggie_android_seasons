import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:veggie_android_seasons/data/app_state.dart';
import 'package:veggie_android_seasons/data/veggie.dart';
import 'package:veggie_android_seasons/veggie_styles.dart';

class TriviaView extends StatefulWidget {
  final int id;

  const TriviaView(this.id);

  @override
  _TriviaViewState createState() => _TriviaViewState();
}

/// Possible states of the game.
enum PlayerStatus {
  readyToAnswer,
  wasCorrect,
  wasIncorrect,
}

class _TriviaViewState extends State<TriviaView> {
  /// Current app state. This is used to fetch veggie data.
  AppState appState;

  /// The veggie trivia about which to show.
  Veggie veggie;

  /// Index of the current trivia question.
  int triviaIndex = 0;

  /// User's score on the current veggie.
  int score = 0;

  /// Trivia question currently being displayed.
  Trivia get currentTrivia => veggie.trivia[triviaIndex];

  /// The current state of the game.
  PlayerStatus status = PlayerStatus.readyToAnswer;

  // Called at init and again if any dependencies (read: InheritedWidgets) on
  // on which this object relies are changed.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final newAppState =
        ScopedModel.of<AppState>(context, rebuildOnChange: true);

    setState(() {
      appState = newAppState;
      veggie = appState.getVeggie(widget.id);
    });
  }

  // Called when the widget associated with this object is swapped out for a new
  // one. If the new widget has a different Veggie ID value, the state object
  // needs to do a little work to reset itself for the new Veggie.
  @override
  void didUpdateWidget(TriviaView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.id != widget.id) {
      setState(() {
        veggie = appState.getVeggie(widget.id);
      });

      _resetGame();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (triviaIndex >= veggie.trivia.length) {
      return _buildFinishedView();
    } else if (status == PlayerStatus.readyToAnswer) {
      return _buildQuestionView();
    } else {
      return _buildResultView();
    }
  }

  void _resetGame() {
    setState(() {
      triviaIndex = 0;
      score = 0;
      status = PlayerStatus.readyToAnswer;
    });
  }

  void _processAnswer(int answerIndex) {
    setState(() {
      if (answerIndex == currentTrivia.correctAnswerIndex) {
        status = PlayerStatus.wasCorrect;
        score++;
      } else {
        status = PlayerStatus.wasIncorrect;
      }
    });
  }

  // Widget shown when the game is over. It includes the score and a button to
  // restart everything.
  Widget _buildFinishedView() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Text(
            'All done!',
            style: VeggieStyles.triviaFinishedTitleText,
          ),
          SizedBox(height: 16),
          Text(
            'You answered',
            style: VeggieStyles.triviaFinishedText,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$score',
                style: VeggieStyles.triviaFinishedBigText,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  ' of ',
                  style: VeggieStyles.triviaFinishedText,
                ),
              ),
              Text(
                '${veggie.trivia.length}',
                style: VeggieStyles.triviaFinishedBigText,
              ),
            ],
          ),
          Text(
            'questions correctly!',
            style: VeggieStyles.triviaFinishedText,
          ),
          SizedBox(height: 16),
          RaisedButton(
            child: Text('Try Again'),
            onPressed: () => _resetGame(),
          ),
        ],
      ),
    );
  }

  // Presents the current trivia's question and answer choices.
  Widget _buildQuestionView() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(height: 16),
          Text(currentTrivia.question),
          SizedBox(height: 32),
          for (int i = 0; i < currentTrivia.answers.length; i++)
            Padding(
              padding: const EdgeInsets.all(8),
              child: RaisedButton(
                color: Colors.blueAccent,
                child: Text(
                  currentTrivia.answers[i],
                  textAlign: TextAlign.center,
                ),
                onPressed: () => _processAnswer(i),
              ),
            ),
        ],
      ),
    );
  }

  // Shows whether the last answer was right or wrong and prompts the user to
  // continue through the game.
  Widget _buildResultView() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Text(status == PlayerStatus.wasCorrect
              ? 'That\'s right!'
              : 'Sorry, that wasn\'t the right answer.'),
          SizedBox(height: 16),
          RaisedButton(
            child: Text('Next Question'),
            onPressed: () => setState(() {
              triviaIndex++;
              status = PlayerStatus.readyToAnswer;
            }),
          ),
        ],
      ),
    );
  }
}