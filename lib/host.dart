import 'package:flutter/material.dart';
import 'package:scribbl/lan/host.dart';
import 'dart:math';

import 'game/player.dart';

class HostPage extends StatefulWidget {

  const HostPage({
    super.key,
    required this.username
  });

  final String username;
  @override
  State<HostPage> createState() => _HostPageState();


}

class _HostPageState extends State<HostPage> {

  //set discovery mode
  bool isScanning = true;
  void setScanningState(bool state) {
    setState(() {
      isScanning = state;
    });
  }

  HostServer hostServer = HostServer();

  //update players function, called from hostServer class

  void updatePlayerList(){
    setState(() {

    });
  }


  @override
  void initState(){
    super.initState();

    //create server
    int port = Random().nextInt(9999 - 1024) + 1024;
    hostServer.createServer(widget.username, port).then((value) => hostServer.startAdvertising());

  }

  @override
  void dispose(){

    //delete, clean up server
    hostServer.stopServer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    HostServer.updateListFunction = updatePlayerList;

    if(isScanning){

    }


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton.tonal(
                        onPressed: () {
                          setState(() {
                            setScanningState(!isScanning);
                          });
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.wifi_tethering),
                            const SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                                width: 90,
                                child: Text(
                                  isScanning
                                      ? "Stop Scanning"
                                      : "Start Scanning",
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
                        onPressed: () {},
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
                              return Column(
                                children: [
                                  ListTile(
                                      // titleAlignment: "titleAlignment",
                                    leading: const Icon(Icons.done),
                                      title: Text(HostServer.clients[index].username),
                                      trailing: IconButton(
                                          icon: const Icon(
                                              Icons.person_remove_alt_1_outlined),
                                        onPressed: (){

                                        },
                                      )
                                  ),
                                  ListTile(
                                    // titleAlignment: "titleAlignment",
                                      leading: const Icon(Icons.done),
                                      title: Text(HostServer.clients[index].username),
                                      trailing: IconButton(
                                        icon: const Icon(
                                            Icons.person_remove_alt_1_outlined),
                                        onPressed: (){

                                        },
                                      )
                                  ),
                                  ListTile(
                                    // titleAlignment: "titleAlignment",
                                      leading: const Icon(Icons.done),
                                      title: Text(HostServer.clients[index].username),
                                      trailing: IconButton(
                                        icon: const Icon(
                                            Icons.person_remove_alt_1_outlined),
                                        onPressed: (){

                                        },
                                      )
                                  ),
                                  ListTile(
                                    // titleAlignment: "titleAlignment",
                                      leading: const Icon(Icons.done),
                                      title: Text(HostServer.clients[index].username),
                                      trailing: IconButton(
                                        icon: const Icon(
                                            Icons.person_remove_alt_1_outlined),
                                        onPressed: (){

                                        },
                                      )
                                  ),ListTile(
                                    // titleAlignment: "titleAlignment",
                                      leading: const Icon(Icons.done),
                                      title: Text(HostServer.clients[index].username),
                                      trailing: IconButton(
                                        icon: const Icon(
                                            Icons.person_remove_alt_1_outlined),
                                        onPressed: (){

                                        },
                                      )
                                  ),ListTile(
                                    // titleAlignment: "titleAlignment",
                                      leading: const Icon(Icons.done),
                                      title: Text(HostServer.clients[index].username),
                                      trailing: IconButton(
                                        icon: const Icon(
                                            Icons.person_remove_alt_1_outlined),
                                        onPressed: (){

                                        },
                                      )
                                  ),ListTile(
                                    // titleAlignment: "titleAlignment",
                                      leading: const Icon(Icons.done),
                                      title: Text(HostServer.clients[index].username),
                                      trailing: IconButton(
                                        icon: const Icon(
                                            Icons.person_remove_alt_1_outlined),
                                        onPressed: (){

                                        },
                                      )
                                  ),ListTile(
                                    // titleAlignment: "titleAlignment",
                                      leading: const Icon(Icons.done),
                                      title: Text(HostServer.clients[index].username),
                                      trailing: IconButton(
                                        icon: const Icon(
                                            Icons.person_remove_alt_1_outlined),
                                        onPressed: (){

                                        },
                                      )
                                  ),ListTile(
                                    // titleAlignment: "titleAlignment",
                                      leading: const Icon(Icons.done),
                                      title: Text(HostServer.clients[index].username),
                                      trailing: IconButton(
                                        icon: const Icon(
                                            Icons.person_remove_alt_1_outlined),
                                        onPressed: (){

                                        },
                                      )
                                  ),
                                ],
                              );
                            }))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
