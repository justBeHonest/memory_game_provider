import 'package:flutter/material.dart';
import 'package:memory_game_provider/features/main_game/main_game_provider.dart';
import 'package:provider/provider.dart';
import '../../core/components/game_card/game_card.dart';
import '../../core/components/game_card/game_card_provider.dart';

class MainGameScreen extends StatelessWidget {
  const MainGameScreen({super.key});

  @override
  Widget build(BuildContext context) => Consumer<MainGameProvider>(
        builder: (context, value, child) {
          _checkGameOver(value, context);
          return Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Ali : ${value.scoreAli}'),
                  Text('Şebnem : ${value.scoreSebnem}'),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(onPressed: value.resetGame, child: Icon(Icons.refresh)),
            body: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              itemBuilder: (context, index) => ChangeNotifierProvider(
                create: (context) => GameCardProvider(),
                child: GameCardComponent(gameCardModel: value.gameCards[index]),
              ),
              itemCount: value.colors.length,
            ),
            backgroundColor: value.backgroundColorForTurnState,
          );
        },
      );

  void _checkGameOver(MainGameProvider value, BuildContext context) {
    if (value.isGameOver) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Game Over'),
            content: Text(value.winner),
            actions: [
              TextButton(
                onPressed: () {
                  value.resetGame();
                  Navigator.pop(context);
                },
                child: Text('Play Again'),
              ),
            ],
          ),
        );
      });
    }
  }
}
