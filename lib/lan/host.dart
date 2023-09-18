import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nsd/nsd.dart';
import 'package:scribbl/game/player.dart';
import 'package:scribbl/lan/communication.dart';


abstract class HostServer {

  static Registration? registration;
  static ServerSocket? serverSocket;
  static String? username;
  static List<Player> clients = [];
  static void Function()? updateListFunction;
  static bool lock = false;
  static late BuildContext context;

  //set in host.dart
  static late Player hostPlayer;

  static Future<void> createServer(String username, int port) async {

    HostServer.username = username;

    InternetAddress host = InternetAddress.anyIPv4;
    HostServer.registration = await register(Service(
        name: username, type: '_http._tcp', host: host.address, port: port));

    HostServer.serverSocket = await ServerSocket.bind(HostServer.registration?.service.host, port);
    print(HostServer.serverSocket?.address);
    print(HostServer.serverSocket?.port);
  }

  static void stopServer() async {
    print("stopping server");
    if (HostServer.registration == null) {
      return;
    }
    unregister(HostServer.registration!);
    HostServer.serverSocket?.close();
    print(HostServer.clients);
    HostServer.clients.map((client)=>{
      print(client.username),
      client.socket?.close()
    });
    HostServer.clients.clear();
  }

  static void startAdvertising() async {
    HostServer.serverSocket?.listen((Socket event) {
      handleConnection(event);
    });
  }

  static void handleConnection(Socket client) {
    print(
      "Connection from ${client.remoteAddress.address}:${client.remotePort}",
    );

    client.listen(
          (Uint8List data) async {
        final message = String.fromCharCodes(data);

        SocketCommand command = parseCommand(message);

        print(command);

        if (command.key == SocketAction.join) {

          // reject if room is locked
          if(lock){
            broadcast("Room is locked.", [Player.createWithSocket(socket: client, username: command.value.toString())], SocketAction.roomLocked);
            remove(client);
            return;
          }

          //return information about players
          Map<String, dynamic> playersJson =  {};

          for(var client in HostServer.clients){
            playersJson[client.id] = {
              "username":client.username,
              "id":client.id,
              "color":client.color
            };
          }

          //add host to output
          playersJson[HostServer.hostPlayer.id] = {
            "username":HostServer.hostPlayer.username,
            "id":HostServer.hostPlayer.id,
            "color":HostServer.hostPlayer.color
          };


          String playersParsed = mapToString(playersJson);

          Map<String, Player> players = {};

          //update room
          for(var id in playersJson.keys){
            Map<String, dynamic>? playerRaw = playersJson[id];
            Player player = Player.set(username: playerRaw?["username"], id: playerRaw?["id"], color: playerRaw?["color"]);
            if(id == "9"){
              Room.host = player;
            }
            players[id] = player;
          }

          print(players);

          Room.players = players;

          // add player to clients
          HostServer.clients
              .add(Player.createWithSocket(socket: client, username: command.value.toString()));

          //send updated player list
          broadcast(playersParsed, HostServer.clients, SocketAction.join);

          HostServer.updateListFunction!();

        }

        if(command.key == SocketAction.error){

        }

        if(command.key == SocketAction.ping){
          ScaffoldMessenger.of(HostServer.context).showSnackBar(
            SnackBar(
              content: Text(command.value.toString()),
            ),
          );
        }
      }, // handle errors
      onError: (error) {
        print(error);
        remove(client);
      },

      // handle the client closing the connection
      onDone: () {
        print('Client left');
        remove(client);
      },
    );
  }

  static void broadcast(String message, List<Player> clients, SocketAction command,) {
    for (var client in clients) {
      client.socket?.write(SocketCommand(command,
          message));
    }
  }

  static void remove(Socket client){
    client.close();
    HostServer.clients.removeWhere(((element) => element.socket == client));
    HostServer.updateListFunction!();
  }

  static void clientsToPlayers(){

  }
}
