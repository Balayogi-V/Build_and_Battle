import 'package:build_and_battle/bloc/battle/battle_bloc.dart';
import 'package:build_and_battle/helper/soldier_assets.dart';
import 'package:build_and_battle/models/soldier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:build_and_battle/models/player.dart';

class FontManager {
  static const String fontFamily = "ClashGrotesk";
}

class BattleScreen extends StatelessWidget {
  final List<Player> players;
  final int numberOfSoldiers;

  const BattleScreen({
    super.key,
    required this.players,
    required this.numberOfSoldiers,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BattleBloc(players, numberOfSoldiers),
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
          buildWhen: (previous, current) =>
              current is PlayerTurnStarted || current is GenerateRandom,
          builder: (context, state) {
            return BlinkingPlayButton(state: state);
          },
        ),
        backgroundColor: Colors.black,
        body: BlocConsumer<BattleBloc, BattleState>(
          listener: (context, state) {
            if (state is PlayerTurnStarted) {
              context
                  .read<BattleBloc>()
                  .add(RequestTurnAction(state.currentPlayerIndex));
            }
          },
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
        const GameTitle(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            children: players.map((player) {
              return PlayerSoltsWidget(
                player: player,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Padding gameTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 40, right: 15, left: 15),
      child: Stack(
        alignment: AlignmentDirectional.centerEnd,
        children: [
          // Hamburger Button (Right Side)
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outline
                  Text(
                    '☰',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: FontManager.fontFamily,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 3.5
                        ..color = Colors.black,
                    ),
                  ),
                  // Gradient Fill
                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.yellow, Colors.orangeAccent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(bounds),
                    child: const Text(
                      '☰',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontManager.fontFamily,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Game Title (Centered)
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Stroke text
                Text(
                  "BUILD & BATTLE",
                  style: TextStyle(
                    fontFamily: FontManager.fontFamily,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 4
                      ..color = Colors.black,
                  ),
                ),
                // Gradient text
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Colors.yellow, Colors.orangeAccent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ).createShader(bounds),
                  child: const Text(
                    "BUILD & BATTLE",
                    style: TextStyle(
                      fontFamily: FontManager.fontFamily,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GameTitle extends StatefulWidget {
  const GameTitle({super.key});

  @override
  State<GameTitle> createState() => _GameTitleState();
}

class _GameTitleState extends State<GameTitle> {
  double _scale = 1.0;

  void _onTapDown(_) {
    setState(() => _scale = 0.9); // Shrink a bit on tap down
  }

  void _onTapUp(_) {
    setState(() => _scale = 1.0); // Back to normal
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0); // Reset if tap canceled
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, right: 15, left: 15),
      child: Stack(
        alignment: AlignmentDirectional.centerEnd,
        children: [
          // Hamburger Icon with InkWell and Scale
          AnimatedScale(
            scale: _scale,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {},
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Stroke
                      Text(
                        '☰',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: FontManager.fontFamily,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 3.5
                            ..color = Colors.black,
                        ),
                      ),
                      // Gradient Fill
                      ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Colors.yellow, Colors.orangeAccent],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ).createShader(bounds),
                        child: const Text(
                          '☰',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: FontManager.fontFamily,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Title in Center
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  "BUILD & BATTLE",
                  style: TextStyle(
                    fontFamily: FontManager.fontFamily,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 4
                      ..color = Colors.black,
                  ),
                ),
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Colors.yellow, Colors.orangeAccent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ).createShader(bounds),
                  child: const Text(
                    "BUILD & BATTLE",
                    style: TextStyle(
                      fontFamily: FontManager.fontFamily,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlayerSoltsWidget extends StatefulWidget {
  final Player player;

  const PlayerSoltsWidget({
    super.key,
    required this.player,
  });

  @override
  State<PlayerSoltsWidget> createState() => _PlayerSoltsWidgetState();
}

class _PlayerSoltsWidgetState extends State<PlayerSoltsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPlayerHeader(),
        _buildSoldierList(),
      ],
    );
  }

  Widget _buildPlayerHeader() {
    return Container(
      padding: const EdgeInsets.only(
        left: 5,
        right: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: widget.player.waitingForTurn
            ? Colors.white.withOpacity(0.8)
            : Colors.white.withOpacity(0.5),
      ),
      margin: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Row(
            children: [
              const Icon(
                Icons.person,
                color: Colors.black,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                widget.player.name,
                style: const TextStyle(
                  fontFamily: FontManager.fontFamily,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: widget.player.soldiers.map((soldier) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Icon(
                  soldier.isDead ? Icons.close : Icons.favorite,
                  color: soldier.isDead ? Colors.green : Colors.red,
                  size: 10,
                ),
              );
            }).toList(),
          ),
          const SizedBox(width: 5),
          const Row(
            children: [
              Icon(
                Icons.military_tech,
                color: Colors.black,
                size: 14,
              ),
              SizedBox(width: 2),
              Text(
                "10",
                style: TextStyle(
                  fontFamily: FontManager.fontFamily,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSoldierList() {
    return Padding(
      padding: const EdgeInsets.only(left: 2.5, right: 2, bottom: 5),
      child: Row(
        children: widget.player.soldiers.map((soldier) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.yellowAccent.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      SoldierAssets.getAsset(SoldierEvolution.uniform),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
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

    if (isPlayerTurn) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant BlinkingPlayButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Restart animation if the turn changes
    if (isPlayerTurn && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!isPlayerTurn && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.red.withOpacity(0.3),
          highlightColor: Colors.orange.withOpacity(0.1),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            splashColor: Colors.red.withOpacity(0.3),
            highlightColor: Colors.orange.withOpacity(0.1),
            onTap: isPlayerTurn
                ? () {
                    var myState = widget.state;
                    if (myState is PlayerTurnStarted) {
                      context
                          .read<BattleBloc>()
                          .add(PlayButtonPressed(myState.currentPlayerIndex));
                    }
                  }
                : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header text
                Container(
                  width: 200,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12)),
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
                                  child: Text(
                                    "It's $playerName's turn",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: FontManager.fontFamily,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : const Text(
                            "Loading...",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: FontManager.fontFamily,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                // Bottom button
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: 200,
                  decoration: const BoxDecoration(
                    color: Colors.yellow,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(12)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!isPlayerTurn)
                        const Padding(
                          padding: EdgeInsets.only(right: 6.0),
                          child: SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      Text(
                        isPlayerTurn ? "PLAY" : "Please wait...",
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: FontManager.fontFamily,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
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
