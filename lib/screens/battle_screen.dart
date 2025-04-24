import 'package:build_and_battle/bloc/battle/battle_bloc.dart';
import 'package:build_and_battle/helper/soldier_assets.dart';
import 'package:build_and_battle/models/soldier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:build_and_battle/models/player.dart';

class BattleScreen extends StatelessWidget {
  final List<Player> players;

  const BattleScreen({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BattleBloc(players),
      child: const _BattleView(),
    );
  }
}

class _BattleView extends StatefulWidget {
  const _BattleView();

  @override
  State<_BattleView> createState() => _BattleViewState();
}

class _BattleViewState extends State<_BattleView> {
  @override
  void initState() {
    super.initState();
    context.read<BattleBloc>().add(StartTurnEvent(playerIndex: 0));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldQuit = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Quit Game"),
              content: const Text("Are you sure you want to quit the game?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Quit"),
                ),
              ],
            );
          },
        );
        return shouldQuit ?? false;
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: BlocBuilder<BattleBloc, BattleState>(
          buildWhen: (previous, current) => current is PlayerTurnStarted,
          builder: (context, state) {
            return BlinkingPlayButton(state: state);
          },
        ),
        backgroundColor: Colors.black,
        body: BlocBuilder<BattleBloc, BattleState>(
          buildWhen: (previous, current) => current is PlayerBattleInfoState,
          builder: (context, state) {
            if (state is PlayerBattleInfoState) {
              return Stack(
                children: [
                  CustomPaint(
                    size: MediaQuery.of(context).size,
                    painter: GameBackgroundPainter(),
                  ),
                  _buildPlayerList(context, state.players),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildPlayerList(BuildContext context, List<Player> players) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 40, right: 15, left: 15),
          child: Stack(
            alignment: AlignmentDirectional.centerEnd,
            children: [
              IconButton(
                icon:
                    Icon(Icons.settings, color: Colors.black.withOpacity(0.5)),
                onPressed: null,
              ),
              const Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "🛠️",
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "BUILD & BATTLE",
                            style: TextStyle(
                              fontFamily: "Gomarice",
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 30,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "🎯",
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            children: players.map((player) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          player.name,
                          style: const TextStyle(
                            fontFamily: "Gomarice",
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 4),
                      Row(
                        children:
                            List.generate(player.soldiers.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: player.soldiers[index].isDead
                                    ? Colors.green
                                    : Colors.red,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 0.5,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(width: 6),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Row(
                      children: player.soldiers.asMap().entries.map((entry) {
                        return Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.yellowAccent,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    SoldierAssets.getAsset(
                                        SoldierEvolution.uniform),
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class BlinkingPlayButton extends StatefulWidget {
  final BattleState state;

  const BlinkingPlayButton({super.key, required this.state});

  @override
  State<BlinkingPlayButton> createState() => _BlinkingPlayButtonState();
}

class _BlinkingPlayButtonState extends State<BlinkingPlayButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  bool get isPlayerTurn => widget.state is PlayerTurnStarted;
  String get playerName => isPlayerTurn
      ? (widget.state as PlayerTurnStarted).currentPlayer.name
      : "";

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (isPlayerTurn) _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.red.withOpacity(0.3),
          highlightColor: Colors.orange.withOpacity(0.1),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            splashColor: Colors.red.withOpacity(0.3),
            highlightColor: Colors.orange.withOpacity(0.1),
            onTap: isPlayerTurn ? () {} : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Cap section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Center(
                    child: isPlayerTurn
                        ? AnimatedBuilder(
                            animation: _controller,
                            builder: (_, child) {
                              return Transform.scale(
                                scale: _scaleAnimation.value,
                                child: Opacity(
                                  opacity: _opacityAnimation.value,
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: "It's ",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: "Gomarice",
                                            color: Colors.white,
                                          ),
                                        ),
                                        TextSpan(
                                          text: playerName,
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontFamily: "Gomarice",
                                            color: Colors.redAccent,
                                            shadows: [
                                              Shadow(
                                                blurRadius: 10,
                                                color: Colors.redAccent,
                                                offset: Offset(0, 0),
                                              )
                                            ],
                                          ),
                                        ),
                                        const TextSpan(
                                          text: "'s turn",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: "Gomarice",
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Colors.white30, Colors.white],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds),
                            child: const Text(
                              "Loading...",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Gomarice",
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.yellow,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!isPlayerTurn)
                        const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      Text(
                        isPlayerTurn ? "PLAY" : "Please wait...",
                        style: const TextStyle(
                          fontSize: 35,
                          fontFamily: "Gomarice",
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GameBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw the radial gradient
    const gradient = RadialGradient(
      center: Alignment(-0.6, -0.8), // offset to upper-left
      radius: 1.2,
      colors: [
        Colors.lightBlue,
        Colors.lightBlueAccent, // Sky blue shade
      ],
      stops: [0.0, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
