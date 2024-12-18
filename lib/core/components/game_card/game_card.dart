import 'package:flutter/material.dart';
import 'package:memory_game_provider/core/model/game_card_model.dart';
import 'package:provider/provider.dart';
import '../../../features/main_game/main_game_provider.dart';
import 'game_card_provider.dart';

class GameCardComponent extends StatelessWidget {
  final GameCardModel gameCardModel;

  const GameCardComponent({super.key, required this.gameCardModel});

  @override
  Widget build(BuildContext context) {
    final listenProvider = Provider.of<GameCardProvider>(context, listen: true);
    final mainGameProvider = Provider.of<MainGameProvider>(context, listen: false);

    return Consumer<GameCardProvider>(
      builder: (context, value, child) {
        return Card(
          color: listenProvider.isFlippedOrMatchedColor(gameCardModel),
          child: InkWell(onTap: gameCardModel.isFlipped || mainGameProvider.gameCardState == GameCardState.secondCardFlipped ? null : () => mainGameProvider.flip(gameCardModel)),
        );
      },
    );
  }
}
