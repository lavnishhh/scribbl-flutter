import 'package:flutter/material.dart';
import 'package:scribbl/game/player.dart';
import 'package:scribbl/lan/client.dart';
import 'package:scribbl/lan/communication.dart';


class RoomPage extends StatefulWidget {
  const RoomPage({super.key});

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {

  //update players function, called from hostServer class

  void updatePlayerList() {
    setState(() {});
  }

  @override
  void initState() {
    ClientServer.context = context;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: ()  async => false,
      child: Scaffold(
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
                  "ID: ${ClientServer.socket?.port}",
                  textScaleFactor: 1.15,
                ),
              )),
          automaticallyImplyLeading: false,
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
                    tag: "client_hero",
                    child: Card(
                        elevation: 0,
                        color: Theme.of(context).colorScheme.primaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                        child: SizedBox(
                            child: ListView.builder(
                                padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                                itemCount: Room.players.length,
                                itemBuilder: (BuildContext context, int index) {

                                  var key = Room.players.keys.elementAt(index);

                                  return ListTile(
                                    // titleAlignment: "titleAlignment",
                                      leading: const Icon(Icons.done),
                                      title: Text(
                                          Room.players[key]!.username),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.accessible_forward),
                                        onPressed: () {
                                          sendMessageToServer(ClientServer.socket!, const MapEntry(SocketAction.ping, "Client says Hello!"));
                                          // TODO : implement client-host-client
                                        },
                                      ));
                                }))),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  // const SizedBox(
                  //   width: 20,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton.tonal(
                          onPressed: () {
                            ClientServer.socket?.close();

                            //home
                            Navigator.of(context).popAndPushNamed('/');
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.exit_to_app),
                              SizedBox(
                                width: 5,
                              ),
                              Text("Leave")
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
      ),
    );
  }
}
