import 'package:flutter/material.dart';

import 'package:scribbl/host.dart';
import 'package:scribbl/lan/client.dart';

class JoinRoomPage extends StatefulWidget {
  const JoinRoomPage({super.key, required this.username});

  final String username;

  @override
  State<JoinRoomPage> createState() => _JoinRoomPageState();
}

class _JoinRoomPageState extends State<JoinRoomPage> {
  String status = 'Finding';

  void repaintPage() {
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ClientServer.context = context;
    ClientServer.username = widget.username;
    ClientServer.repaintPage = repaintPage;
    ClientServer.startDiscovering();
  }

  @override
  void dispose() {
    ClientServer.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(JoinRoomPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget != oldWidget) {
      print('Navigated back to BottomPage');
      // Perform any necessary actions here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Servers'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                child: Hero(
                  tag: 'client_hero',
                  child: Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                      shrinkWrap: true,
                      itemCount: ClientServer.availableServices.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(ClientServer.availableServices[index].name
                              .toString()),
                          trailing: SizedBox(
                            width: 70,
                            child: FilledButton.tonal(
                              onPressed: (ClientServer.disableButtons)
                                  ? null
                                  : () {
                                      setState(() {
                                        ClientServer.connectingTo = index;
                                        ClientServer.disableButtons = true;
                                      });
                                      try {
                                        print(ClientServer
                                            .availableServices[index]);
                                        ClientServer.connect(
                                            ClientServer
                                                .availableServices[index].host,
                                            ClientServer
                                                .availableServices[index].port);
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                              child: (index != ClientServer.connectingTo)
                                  ? const Icon(Icons.start)
                                  : const SizedBox(
                                      width: 15,
                                      height: 15,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                      ),
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
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
                          ClientServer.dispose();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HostPage(
                                    username: widget.username,
                                  )));
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.add),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "OR Create your own...",
                            )
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
