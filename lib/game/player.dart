import 'dart:io';
import 'dart:math';

class Player {
  Socket? socket;
  late final String username;
  late final String id;
  late final double color;
  late final bool isHost;
  int points = 0;

  Player.host({required this.username}){
    isHost = true;
    id = "9";
    color = Random().nextInt(256)/256;
  }

  Player.createWithSocket({required this.socket, required this.username}){
    id = (Random().nextInt(90) + 10).toString();
    color = Random().nextInt(256)/256;
  }


  Player.set({required this.username, required this.id, required this.color});
}

// can be used by both host and client

abstract class Room{
  static late Function talk;
  static late Player host;
  static Map<String, Player> players = {};
}


