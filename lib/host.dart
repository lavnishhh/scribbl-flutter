import 'package:flutter/material.dart';
import 'package:scribbl/game/game_page.dart';
import 'package:scribbl/lan/communication.dart';
import 'package:scribbl/lan/host.dart';
import 'dart:math';

import 'game/player.dart';

class HostPage extends StatefulWidget {
  const HostPage({super.key, required this.username});

  final String username;

  @override
  State<HostPage> createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {

  //update players function, called from hostServer class
  int port = Random().nextInt(9999 - 1024) + 1024;

  void updatePlayerList() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    //create server
    HostServer.createServer(widget.username, port)
        .then((value) => HostServer.startAdvertising());
    HostServer.context = context;

    HostServer.hostPlayer = Player.host(username: widget.username);
  }

  @override
  void dispose() {
    //delete, clean up server
    HostServer.stopServer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    HostServer.updateListFunction = updatePlayerList;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
              child: Text(
                "ID: $port",
                textScaleFactor: 1.15,
              ),
            )),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
            child:
                IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Hero(
                  tag: "host_hero",
                  child: Card(
                      elevation: 0,
                      color: Theme.of(context).colorScheme.primaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      child: SizedBox(
                          child: ListView.builder(
                              padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                              itemCount: HostServer.clients.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                    // titleAlignment: "titleAlignment",
                                    leading: const Icon(Icons.done),
                                    title: Text(
                                        HostServer.clients[index].username),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.person_remove),
                                      onPressed: () {
                                        HostServer.broadcast(
                                            "You have been kicked out of the room.",
                                            [HostServer.clients[index]],
                                            SocketAction.kick);
                                        HostServer.remove(
                                            HostServer.clients[index].socket!);
                                      },
                                    ));
                              }))),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton.tonal(
                        onPressed: () {
                          setState(() {
                            HostServer.lock = !HostServer.lock;
                          });
                        },
                        child: Row(
                          children: [
                            Icon(HostServer.lock
                                ? Icons.lock_open
                            : Icons.lock,
                            size: 20,),
                            SizedBox(
                                width: 90,
                                child: Text(
                                  HostServer.lock
                                      ? "Unlock Room"
                                      : "Lock Room",
                                  textAlign: TextAlign.center,
                                ))
                          ],
                        ))
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton.tonal(
                        onPressed: () {
                          //create room
                          //TODO: send all players list to client

                          print("start");

                          HostServer.broadcast("", HostServer.clients, SocketAction.start);

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const GamePage()));
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.start),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Start")
                          ],
                        ))
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
