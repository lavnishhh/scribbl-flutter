import 'package:flutter/material.dart';
import 'package:scribbl/game/painter.dart';
import 'package:scribbl/game/player.dart';
import 'package:scribbl/lan/host.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<Offset> _points = [];
  List<Color> colors = [Colors.black];
  Color paintColor = Colors.black;

  bool textFieldFocused = false;

  String word = "The word";

  late double hue;

  late TextEditingController _controller;

  void updateState() {
    print("updating");
    setState(() {
      HostServer.clients = HostServer.clients;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    HostServer.updateListFunction = updateState;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    hue =
        HSVColor.fromColor(Theme.of(context).colorScheme.primaryContainer).hue;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(64.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: SizedBox(
                      height: 40,
                      // Specify a fixed height for the horizontal list
                      child: ListView.builder(
                        itemCount: Room.players.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          var key = Room.players.keys.elementAt(index);

                          print(Room.players.length);

                          return SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                          width: 15,
                                          height: 15,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: HSVColor.fromAHSV(
                                                        1,
                                                        Room.players[key]!
                                                            .color,
                                                        0.5,
                                                        1)
                                                    .toColor(),
                                                shape: BoxShape.circle),
                                          ),
                                        ),
                                        // const Icon(Icons.arrow_upward_sharp),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  Room.players[key]!.username,
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 400,
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: Theme.of(context).colorScheme.primary),
                ),
                child: ClipRect(
                  child: GestureDetector(
                    onPanUpdate: (DragUpdateDetails details) {
                      setState(() {
                        RenderBox renderBox =
                            context.findRenderObject() as RenderBox;
                        Offset localPosition =
                            renderBox.globalToLocal(details.localPosition);
                        _points = List.from(_points)..add(localPosition);
                      });
                    },
                    onPanEnd: (DragEndDetails details) =>
                        _points.add(const Offset(-1, -1)),
                    child: CustomPaint(
                      painter:
                          FingerPainter(points: _points, color: paintColor),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Card(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
                            child: Text(
                              word,
                              textScaleFactor: 1.15,
                            ),
                          )),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            int i = _points.length - 1;
                            if (i == -1) {
                              return;
                            }
                            while (!(i == 0 || _points[i - 1].dx == -1.0)) {
                              _points.removeLast();
                              i -= 1;
                            }
                            _points.removeLast();
                          },
                          icon: const Icon(Icons.undo)),
                      IconButton(
                          onPressed: () {
                            _points.clear();
                          },
                          icon: const Icon(Icons.delete)),
                      const SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
          DraggableScrollableSheet(
            minChildSize: 0.3,
              initialChildSize: 0.35,
              maxChildSize: 0.4,
              builder: (BuildContext context, ScrollController scrollController) {

            return Container(
              decoration: BoxDecoration(
                  color: HSVColor.fromAHSV(1, hue, 0.1, 1).toColor(),
                  boxShadow: <BoxShadow>[

                  textFieldFocused? BoxShadow(color: Colors.black, offset: Offset(0, 4), blurRadius: 8): BoxShadow()
                ]
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      reverse: true,
                      padding: const EdgeInsets.fromLTRB(8, 8, 4, 8),
                      shrinkWrap: true,
                      itemCount: Room.players.length,
                      itemBuilder: (context, index) {
                        var key = Room.players.keys.elementAt(index);

                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 15,
                                height: 15,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: HSVColor.fromAHSV(
                                              1,
                                              Room.players[key]!.color,
                                              0.5,
                                              1)
                                          .toColor(),
                                      shape: BoxShape.circle),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Flexible(
                                  child: Text(
                                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Massa vitae tortor condimentum lacinia quis vel eros donec."))
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
                            child: Focus(
                              onFocusChange: (focused){
                                setState(() {
                                  textFieldFocused = focused;
                                });
                              },
                              child: TextField(
                                controller: _controller,
                              ),
                            ),
                          ),
                        ),
                        IconButton(onPressed: () {}, icon: Icon(Icons.send))
                      ],
                    ),
                  )
                ],
              ),
            );
          })
        ]),
      ),
    );
  }
}

class FingerPainter extends CustomPainter {
  final List<Offset> points;
  Color color;

  FingerPainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    print(points.length);

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i].dx != -1 && points[i + 1].dx != -1) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(FingerPainter oldDelegate) => true;
}
