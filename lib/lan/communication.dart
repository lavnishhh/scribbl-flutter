import 'dart:convert';
import 'dart:io';

enum SocketAction { join, kick, roomLocked, start, message, players, ping, unknown, error }

SocketAction parseStringToSocketAction(String value) {
  switch (value) {
    case "SocketAction.join":
      return SocketAction.join;
    case "SocketAction.kick":
      return SocketAction.kick;
    case "SocketAction.start":
      return SocketAction.start;
    case "SocketAction.roomLocked":
      return SocketAction.roomLocked;
    case "SocketAction.message":
      return SocketAction.message;
    case "SocketAction.players":
      return SocketAction.players;
    case "SocketAction.ping":
      return SocketAction.ping;
    case "SocketAction.error":
      return SocketAction.error;
    default:
      return SocketAction.unknown;
  }
}

typedef SocketCommand = MapEntry<SocketAction, Object>;
typedef LoginCommand = MapEntry<SocketAction, String>;

void sendMessageToServer(Socket socket, SocketCommand message) {
  // print("Client: ${message.key} - ${message.value}");
  socket.write(message);
}

SocketCommand parseCommand(String message) {
  List<String> splittedMessage =
  message.substring(9, message.indexOf(")")).split(":");

  return SocketCommand(
    parseStringToSocketAction(splittedMessage.removeAt(0)),
    splittedMessage.join(":"),
  );
}

// Method to parse a Map to a string
String mapToString(Map<String, dynamic> map) {
  return json.encode(map);
}

// Method to parse a string to a Map
Map<String, dynamic> stringToMap(String jsonString) {
  return json.decode(jsonString);
}