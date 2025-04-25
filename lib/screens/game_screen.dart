import 'package:build_and_battle/models/soldier.dart';
import 'package:flutter/material.dart';
import 'package:build_and_battle/models/player.dart';
import 'package:build_and_battle/screens/battle_screen.dart';

class SetupScreen extends StatefulWidget {
  final int numberOfPlayers;
  final bool isFiveSoldiers;

  const SetupScreen({
    super.key,
    required this.numberOfPlayers,
    required this.isFiveSoldiers,
  });

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  late List<TextEditingController> _nameControllers;
  late int numberOfSoldiers;

  @override
  void initState() {
    super.initState();
    numberOfSoldiers = widget.isFiveSoldiers ? 5 : 4;
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
    final maxPlayers = widget.isFiveSoldiers ? 5 : 4;

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
                if (widget.numberOfPlayers > maxPlayers) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Maximum players allowed is $maxPlayers for this mode.'),
                    ),
                  );
                  return;
                }

                final players = List.generate(
                  widget.numberOfPlayers,
                  (index) {
                    return Player(
                      id: DateTime.now().millisecondsSinceEpoch.toString() +
                          index.toString(),
                      name: _nameControllers[index].text.isNotEmpty
                          ? _nameControllers[index].text
                          : 'Player ${index + 1}',
                      soldiers: List.generate(
                        numberOfSoldiers,
                        (_) => Soldier(),
                      ),
                    );
                  },
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BattleScreen(
                      players: players,
                      numberOfSoldiers: numberOfSoldiers,
                    ),
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
