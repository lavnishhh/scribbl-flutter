import 'package:nsd/nsd.dart';

class Server{

  static late Registration registration;

  static Future<void> startDiscovering() async {
    final discovery = await startDiscovery('_http._tcp');
    discovery.addServiceListener((service, status) {
      if (status == ServiceStatus.found) {
        print(service.name);
        print(service.port);
        // put service in own collection, etc.
      }
    });
  }

  static Future<void> startServer(String username) async {

    registration = await register(
        Service(name: "$username's server", type: '_http._tcp', port: 69420));
  }

  void stopServer() async {

    await unregister(registration);
  }
}