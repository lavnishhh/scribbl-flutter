import 'package:flutter/material.dart';
import 'package:scribbl/lan/lan.dart';

class JoinRoomPage extends StatefulWidget {
  const JoinRoomPage({super.key});

  @override
  State<JoinRoomPage> createState() => _JoinRoomPageState();
}

class _JoinRoomPageState extends State<JoinRoomPage> {

  String status = 'Finding';
  List<String> availableServers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Server server = Server();
    server.findAvailableServers();
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
              itemCount: availableServers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(availableServers[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

