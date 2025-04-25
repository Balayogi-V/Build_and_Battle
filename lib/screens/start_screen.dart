import 'package:build_and_battle/bloc/player_selection/player_selection_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'player_selection_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6DD5FA), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Row Buttons
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _circleIcon(Icons.volume_up),
                    const SizedBox(width: 12),
                    _circleIcon(Icons.info_outline),
                    const SizedBox(width: 12),
                    _circleIcon(Icons.settings),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Title
              const Text(
                'BUILD &\nBATTLE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                        blurRadius: 1,
                        color: Colors.orange,
                        offset: Offset(1, 1))
                  ],
                ),
              ),

              const SizedBox(height: 8),
              const Text(
                'DUDE SQUAD',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 24),

              // Image Placeholder
              Container(
                height: 200,
                width: 200,
                color: Colors
                    .transparent, // Replace with your Image.asset(...) if needed
              ),

              const SizedBox(height: 12),
              const Text(
                'Build. Blast. Battle!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const Spacer(),

              // Start Game Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC107),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.black, width: 2),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (context) => PlayerSelectionBloc(),
                          child: const PlayerSelectionScreen(),
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'START GAME',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circleIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Icon(icon, size: 20),
    );
  }
}
