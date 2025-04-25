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
  int? selectedPlayerCount;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<PlayerSelectionBloc>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFCCE7FF),
      body: BlocBuilder<PlayerSelectionBloc, PlayerSelectionState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Select Players',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                _buildFivePlayersModeSwitch(),
                const SizedBox(height: 20),
                _buildPlayerCountGrid(),
                const Spacer(),
                _buildContinueButton(bloc),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFivePlayersModeSwitch() {
    return Row(
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
              selectedPlayerCount = null; // Reset selection
            });
          },
        ),
      ],
    );
  }

  Widget _buildPlayerCountGrid() {
    final itemCount = isFivePlayersMode ? 4 : 3;

    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final playerCount = index + 2;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedPlayerCount = playerCount;
            });
          },
          child: _buildPlayerCountCard(playerCount),
        );
      },
    );
  }

  Widget _buildPlayerCountCard(int playerCount) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          decoration: BoxDecoration(
            color: selectedPlayerCount == playerCount
                ? const Color(0xFFFDC82F)
                : Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Text(
              '$playerCount Players',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        // if (selectedPlayerCount == playerCount)
        //   Positioned(
        //     bottom: 0,
        //     right: 0,
        //     child: Container(
        //       padding: const EdgeInsets.all(6.0),
        //       decoration: const BoxDecoration(
        //         color: Color(0xFFFDC82F),
        //         borderRadius: BorderRadius.only(
        //           topLeft: Radius.circular(10),
        //           bottomRight: Radius.circular(10),
        //         ),
        //       ),
        //       child: const Icon(
        //         Icons.check,
        //         color: Colors.black,
        //         size: 20,
        //       ),
        //     ),
        //   ),
      ],
    );
  }

  Widget _buildContinueButton(PlayerSelectionBloc bloc) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFDC82F),
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadowColor: Colors.black.withOpacity(0.8),
        ),
        onPressed: selectedPlayerCount == null
            ? null
            : () {
                bloc.add(SelectPlayerCount(selectedPlayerCount!));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SetupScreen(
                      numberOfPlayers: selectedPlayerCount!,
                      isFiveSoldiers: isFivePlayersMode,
                    ),
                  ),
                );
              },
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Continue to Battle',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_right_alt_rounded, size: 28),
          ],
        ),
      ),
    );
  }
}
