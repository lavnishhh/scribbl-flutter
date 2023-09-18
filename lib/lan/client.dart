import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nsd/nsd.dart';
import 'package:scribbl/game/player.dart';
import 'package:scribbl/game/room_page.dart';
import 'package:scribbl/join_room.dart';
import 'package:scribbl/lan/communication.dart';

import '../game/game_page.dart';

abstract class ClientServer {

  static List<Service> availableServices = [];
  static late String username;

  static Discovery? discovery;
  static Socket? socket;

  static int connectingTo = -1;
  static bool disableButtons = false;

  static late BuildContext context;

  static void Function()? repaintPage;

  //index : [loading, disabled]
  Map<int, List<bool>> roomStatus = {};

  static Future<void> startDiscovering() async {
    print("starting discovery");
    ClientServer.discovery = await startDiscovery('_http._tcp');
    ClientServer.discovery?.addServiceListener((service, status) {
      if (status == ServiceStatus.found) {
        //TODO: keep pinging clients
        ClientServer.availableServices.add(service);
        ClientServer.repaintPage!();
        print(service);
      }
    });
  }

  static Future<void> stopDiscovering() async {
    availableServices.clear();
      if(discovery==null){
        return;
    }
    await stopDiscovery(discovery!);
      print('discovery stopped.');
    discovery = null;
  }

  static Future<void> connect(address, port) async {
    try {
      socket = await Socket.connect(address, port).timeout(const Duration(seconds: 4));
      print(
          'Connected to: ${ClientServer.socket?.remoteAddress.address}:${ClientServer.socket?.remotePort}');

      sendMessageToServer(ClientServer.socket!,
          MapEntry(SocketAction.join, ClientServer.username.toString()));

      ClientServer.socket?.listen(
        (Uint8List data) {
          final serverResponse = String.fromCharCodes(data);
          var parsedCommand = parseCommand(serverResponse);
          print(parsedCommand);

          if (parsedCommand.key == SocketAction.join){

            //parsed json
            Map<String, dynamic> parsedJson = stringToMap(parsedCommand.value.toString());

            //final player map
            Map<String, Player> players = {};

            //convert raw json to class
            for(var id in parsedJson.keys){
              Map<String, dynamic>? playerRaw = parsedJson[id];
              Player player = Player.set(username: playerRaw?["username"], id: playerRaw?["id"], color: playerRaw?["color"]);
              if(id == "9"){
                Room.host = player;
              }
              players[id] = player;
            }

            Room.players = players;

            print(Room.players);

            // stop discovering after join success
            ClientServer.stopDiscovering();
            Navigator.pushReplacement<void, void>(context, MaterialPageRoute(builder: (context) => const RoomPage()));

          }

          // kick
          if (parsedCommand.key == SocketAction.kick) {
            ScaffoldMessenger.of(ClientServer.context).showSnackBar(
              SnackBar(
                content: Text(parsedCommand.value.toString()),
              ),
            );
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => JoinRoomPage(username: ClientServer.username.toString())));
          }

          // room locked
          if (parsedCommand.key == SocketAction.roomLocked) {
            ScaffoldMessenger.of(ClientServer.context).showSnackBar(
              SnackBar(
                content: Text(parsedCommand.value.toString()),
              ),
            );
            ClientServer.connectingTo = -1;
            ClientServer.repaintPage!();
            Future.delayed(const Duration(seconds: 4), () {
              ClientServer.disableButtons = false;
              ClientServer.repaintPage!();
            });
          }

          if(parsedCommand.key == SocketAction.start){
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const GamePage()));
          }

          // error
          if (parsedCommand.key == SocketAction.error) {
            ScaffoldMessenger.of(ClientServer.context).showSnackBar(
              SnackBar(
                content: Text(parsedCommand.value.toString()),
              ),
            );
          }
        },
        // handle errors
        onError: (error) {
          print(error);
          ClientServer.socket?.destroy();
        },

        // handle server ending connection
        onDone: () {
          print('Server left.');
          ClientServer.socket?.destroy();

          ScaffoldMessenger.of(ClientServer.context).showSnackBar(
            const SnackBar(
              content: Text("The room was deleted."),
            ),
          );

          Navigator.of(context).pop();
        },
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Couldn't connect. Please try again."),
        ),
      );
      ClientServer.connectingTo = -1;
      ClientServer.repaintPage!();
      Future.delayed(const Duration(seconds: 2), () {
        ClientServer.disableButtons = false;
        ClientServer.repaintPage!();
      });
    }
  }

  static void dispose() {
    ClientServer.stopDiscovering();
    ClientServer.connectingTo = -1;
    ClientServer.disableButtons = false;
    print("stopped discovery");
  }
}
