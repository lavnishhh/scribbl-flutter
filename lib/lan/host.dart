import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:nsd/nsd.dart';
import 'package:scribbl/game/player.dart';
import 'package:scribbl/lan/communication.dart';


class HostServer {

  Registration? registration;
  ServerSocket? serverSocket;
  static List<Player> clients = [];
  static void Function()? updateListFunction;

  Future<void> createServer(String username, int port) async {
    InternetAddress host = InternetAddress.anyIPv4;
    registration = await register(Service(
        name: username, type: '_http._tcp', host: host.address, port: port));

    print(registration!.service.host);
    print(registration!.service.port);

    serverSocket = await ServerSocket.bind(registration?.service.host, port);
    print(serverSocket?.address);
    print(serverSocket?.port);
  }

  void stopServer() async {
    print("stopping server");
    if (registration == null) {
      return;
    }
    unregister(registration!);
    serverSocket?.close();
    print(clients);
    for(Player client in clients){
      client.socket.destroy();
    }
    clients.clear();
  }

  void startAdvertising() async {
    serverSocket?.listen((Socket event) {
      handleConnection(event);
    });
  }

  void handleConnection(Socket client) {
    print(
      "Connection from ${client.remoteAddress.address}:${client.remotePort}",
    );

    client.listen(
      (Uint8List data) async {
        final message = String.fromCharCodes(data);

        SocketCommand command = parseCommand(message);

        print(command);

        if (command.key == SocketAction.join) {
          for (var client in clients) {
            client.socket.write(SocketCommand(SocketAction.successMessage,
                "${command.value} joined the game"));
          }

          clients
              .add(Player(socket: client, username: command.value.toString()));

          updateListFunction!();
          print(clients);

          client.write(
            SocketCommand(SocketAction.successMessage,
                "You are logged in as: ${command.value}"),
          );
        }
        print(command.value);
      }, // handle errors
      onError: (error) {
        print(error);
        client.close();
        clients.removeWhere(((element) => element.socket == client));
        updateListFunction!();

      },

      // handle the client closing the connection
      onDone: () {
        print('Client left');
        client.close();
        clients.removeWhere(((element) => element.socket == client));
        updateListFunction!();

      },
    );
  }

  List<Player> getPlayers(){
    return clients;
  }
}
