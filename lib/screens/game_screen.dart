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

  final List<Color> avatarColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
  ];

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
      backgroundColor: const Color(0xFFCCE7FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Name Your Squad',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.numberOfPlayers,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Solid color circular avatar
                          CircleAvatar(
                            radius: 24,
                            backgroundColor:
                                avatarColors[index % avatarColors.length],
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _nameControllers[index],
                              decoration: InputDecoration(
                                hintText: 'Player ${index + 1}',
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Icon(Icons.edit, size: 20),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFDC82F),
                    foregroundColor: Colors.black,
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (widget.numberOfPlayers > maxPlayers) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Maximum players allowed is $maxPlayers for this mode.',
                          ),
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
                  child: const Row(
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
                      Icon(Icons.arrow_right_alt_rounded, size: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
