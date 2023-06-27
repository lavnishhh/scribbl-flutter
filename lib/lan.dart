import 'package:nsd/nsd.dart';

class Server{

  static late Registration registration;

  static Future<void> startServer() async {
    final discovery = await startDiscovery('_http._tcp');
    discovery.addServiceListener((service, status) {
      if (status == ServiceStatus.found) {
        print(service.name);
        print(service.port);
        // put service in own collection, etc.
      }
    });
  }

  static Future<void> scanForDevices() async {

    registration = await register(
        const Service(name: 'Foo', type: '_http._tcp', port: 56000));
  }

  void stopScanningForDevices() async {

    await unregister(registration);
  }
}