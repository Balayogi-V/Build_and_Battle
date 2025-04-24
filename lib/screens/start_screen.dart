import 'package:build_and_battle/bloc/player_selection/player_selection_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'player_selection_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Built and Battle')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (context) => PlayerSelectionBloc(),
                    child: const PlayerSelectionScreen(),
                  ),
                ));
          },
          child: const Text('Start Game'),
        ),
      ),
    );
  }
}
