import 'package:build_and_battle/bloc/player_selection/player_selection_bloc.dart';
import 'package:build_and_battle/screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerSelectionScreen extends StatefulWidget {
  const PlayerSelectionScreen({super.key});

  @override
  State<PlayerSelectionScreen> createState() => _PlayerSelectionScreenState();
}

class _PlayerSelectionScreenState extends State<PlayerSelectionScreen> {
  bool isFivePlayersMode = false;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<PlayerSelectionBloc>(context);

    return Scaffold(
      body: BlocBuilder<PlayerSelectionBloc, PlayerSelectionState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '5 Players Mode',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Switch(
                      value: isFivePlayersMode,
                      onChanged: (value) {
                        setState(() {
                          isFivePlayersMode = value;
                        });
                      },
                    ),
                  ],
                ),
                ...List.generate(isFivePlayersMode ? 4 : 3, (index) {
                  final playerCount = index + 2;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        backgroundColor: Colors.purpleAccent,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.black,
                        elevation: 10,
                      ),
                      onPressed: () {
                        bloc.add(SelectPlayerCount(playerCount));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SetupScreen(
                              numberOfPlayers: playerCount,
                              isFiveSoldiers: isFivePlayersMode,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 10),
                          Text(
                            '$playerCount Players',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
