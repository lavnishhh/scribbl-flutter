import 'dart:io';
import 'dart:typed_data';
import 'package:nsd/nsd.dart';
import 'package:scribbl/lan/communication.dart';



class ClientServer{

  ClientServer(String username){
    this.username;
  }

  static List<Service> availableServices = [];
  late Discovery discovery;
  late String username;

  Future<void> startDiscovering() async {

    enableLogging(LogTopic.errors);
    enableLogging(LogTopic.calls);

    discovery = await startDiscovery('_http._tcp');
    discovery?.addServiceListener((service, status) {
      if (status == ServiceStatus.found) {
        availableServices.add(service);
        print(service.name);
        print(service.port);
        print(availableServices);
      }
    });
  }
  Future<void> stopDiscovering(Discovery discovery) async {
    await stopDiscovery(discovery);
  }

  Future<void> connect(port) async {
    final socket = await Socket.connect("0.0.0.0", port);
    print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');

    socket.listen(
          (Uint8List data) {
        final serverResponse = String.fromCharCodes(data);
        var parsedCommand = parseCommand(serverResponse);

        if (parsedCommand.key == SocketAction.successMessage) {
          print(parsedCommand.value.toString());
        }
      },
      // handle errors
      onError: (error) {
        print(error);
        socket.destroy();
      },

      // handle server ending connection
      onDone: () {
        print('Server left.');
        socket.destroy();
      },
    );

    sendMessageToServer(socket, MapEntry(SocketAction.join, username));
  }
}