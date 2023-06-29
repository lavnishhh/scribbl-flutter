import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:nsd/nsd.dart';
import 'package:scribbl/lan/communication.dart';

class JoinRoomPage extends StatefulWidget {
  const JoinRoomPage({super.key, required this.username});

  final String username;

  @override
  State<JoinRoomPage> createState() => _JoinRoomPageState();
}

class _JoinRoomPageState extends State<JoinRoomPage> {
  String status = 'Finding';

  // List<String> availableServers = [];
  // Timer? searchTimer;
  //
  // void startServerSearch() {
  //   searchTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
  //     // availableServers = await server.findAvailableServers();
  //     print(availableServers);
  //   });
  // }

  List<Service> availableServices = [];

  late Discovery discovery;
  Socket? socket;

  int loadingButton = -1;
  bool disableButtons = false;

  //index : [loading, disabled]
  Map<int, List<bool>> roomStatus = {};

  Future<void> startDiscovering() async {
    discovery = await startDiscovery('_http._tcp');
    discovery?.addServiceListener((service, status) {
      if (status == ServiceStatus.found) {
        setState(() {
          availableServices.add(service);
        });
      }
    });
  }

  Future<void> stopDiscovering(Discovery discovery) async {
    await stopDiscovery(discovery);
  }

  Future<void> connect(address, port) async {
    try {
      socket = await Socket.connect(address, port);
      print(
          'Connected to: ${socket?.remoteAddress.address}:${socket?.remotePort}');

      sendMessageToServer(
          socket!, MapEntry(SocketAction.join, widget.username));

      socket?.listen(
        (Uint8List data) {
          final serverResponse = String.fromCharCodes(data);
          var parsedCommand = parseCommand(serverResponse);

          if (parsedCommand.key == SocketAction.join) {
            print(parsedCommand.value.toString());
          }
        },
        // handle errors
        onError: (error) {
          print(error);
          socket?.destroy();
        },

        // handle server ending connection
        onDone: () {
          print('Server left.');
          socket?.destroy();
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Couldn't connect. Please try again."),
        ),
      );
      loadingButton = -1;
      Future.delayed(const Duration(seconds: 4), () {
        setState(() {
          disableButtons = false;
        });
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startDiscovering();
  }

  @override
  void dispose() {
    stopDiscovering(discovery);
    availableServices.clear();
    print(socket);
    socket?.destroy();
    print("stopped discovery");
    super.dispose();
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
            const Text(
              'Available Servers:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: availableServices.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(availableServices[index].name.toString()),
                  trailing: SizedBox(
                    width: 70,
                    child: FilledButton.tonal(
                      onPressed: (disableButtons)
                          ? null
                          : () {
                              setState(() {
                                loadingButton = index;
                                disableButtons = true;
                              });
                              try {
                                connect(availableServices[index].host,
                                    availableServices[index].port);
                              } catch (e) {}
                            },
                      child: (index != loadingButton)
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
          ],
        ),
      ),
    );
  }
}
