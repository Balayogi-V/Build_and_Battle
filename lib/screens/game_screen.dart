import 'package:build_and_battle/models/soldier.dart';
import 'package:flutter/material.dart';
import 'package:build_and_battle/models/player.dart';
import 'package:build_and_battle/screens/battle_screen.dart';

class SetupScreen extends StatefulWidget {
  final int numberOfPlayers;

  const SetupScreen({super.key, required this.numberOfPlayers});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  late List<TextEditingController> _nameControllers;

  @override
  void initState() {
    super.initState();
    _nameControllers = List.generate(
      widget.numberOfPlayers,
      (_) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game Setup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.numberOfPlayers,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: _nameControllers[index],
                      decoration: InputDecoration(
                        labelText: 'Player ${index + 1} Name',
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final players = List.generate(
                  widget.numberOfPlayers,
                  (index) => Player(
                    id: DateTime.now().millisecondsSinceEpoch.toString() +
                        index.toString(),
                    name: _nameControllers[index].text.isNotEmpty
                        ? _nameControllers[index].text
                        : 'Player ${index + 1}',
                    soldiers: List.generate(4, (_) => Soldier()),
                  ),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BattleScreen(players: players),
                  ),
                );
              },
              child: const Text('Start Battle'),
            ),
          ],
        ),
      ),
    );
  }
}
