import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  late AppState appState;

  /// The veggie trivia about which to show.
  late Veggie veggie;

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

    final newAppState = Provider.of<AppState>(context);

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
          const Text(
            'All done!',
            style: VeggieStyles.triviaFinishedTitleText,
          ),
          const SizedBox(height: 16),
          const Text(
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
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
          const Text(
            'questions correctly!',
            style: VeggieStyles.triviaFinishedText,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _resetGame(),
            child: const Text('Try Again'),
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
          const SizedBox(height: 16),
          Text(currentTrivia.question),
          const SizedBox(height: 32),
          for (int i = 0; i < currentTrivia.answers.length; i++)
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () => _processAnswer(i),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white),
                child: Text(
                  currentTrivia.answers[i],
                  textAlign: TextAlign.center,
                ),
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
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => setState(() {
              triviaIndex++;
              status = PlayerStatus.readyToAnswer;
            }),
            child: const Text('Next Question'),
          ),
        ],
      ),
    );
  }
}
