import 'dart:io';
import 'dart:convert';
import 'dart:async';

class Server {
  ServerSocket? _serverSocket;
  Socket? _clientSocket;

  bool _isServerRunning = false;
  bool _isConnectedToServer = false;

  // 1. Create a server (host)
  Future<void> createServer({int port = 8080}) async {
    try {
      _serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, port);
      _isServerRunning = true;
      print('Server created on port $port');
      _listenForConnections();
    } catch (e) {
      print('Failed to create server: $e');
    }
  }

  void _listenForConnections() {
    _serverSocket?.listen((clientSocket) {
      _clientSocket = clientSocket;
      _isConnectedToServer = true;
      print('Client connected: ${clientSocket.remoteAddress.address}:${clientSocket.remotePort}');
      _listenForClientData();
    });
  }

  // 2. Stop the server (host)
  void stopServer() {
    _isServerRunning = false;
    _serverSocket?.close();
    _serverSocket = null;
    _isConnectedToServer = false;
    _clientSocket?.close();
    _clientSocket = null;
    print('Server stopped');
  }

  // 3. Find and list available servers (client)
  Future<List<String>> findAvailableServers({int port = 8080}) async {
    List<String> availableServers = [];

    try {
      final serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, port);
      serverSocket.close();
    } catch (e) {
      print('Failed to bind server socket: $e');
      return availableServers;
    }

    try {
      final broadcastAddress = InternetAddress('255.255.255.255');
      final socket = await Socket.connect(broadcastAddress, port);
      socket.write('ping');

      final completer = Completer<List<String>>();
      final serverResponse = <String>[];

      socket.listen((List<int> data) {
        final response = utf8.decode(data);
        serverResponse.add(response);
      }, onDone: () {
        completer.complete(serverResponse);
        socket.close();
      });

      await completer.future;
      availableServers = serverResponse;
    } catch (e) {
      print('Failed to find available servers: $e');
    }

    return availableServers;
  }

  // 4. Join one of the servers from available servers (client)
  Future<void> joinServer(String serverIP, int port) async {
    try {
      _clientSocket = await Socket.connect(serverIP, port);
      _isConnectedToServer = true;
      print('Connected to server: $serverIP:$port');
      _listenForClientData();
    } catch (e) {
      print('Failed to join server: $e');
    }
  }

  // 5. Leave/disconnect from the connected server
  void disconnectFromServer() {
    _isConnectedToServer = false;
    _clientSocket?.close();
    _clientSocket = null;
    print('Disconnected from server');
  }

  void _listenForClientData() {
    _clientSocket?.listen((List<int> data) {
      final message = utf8.decode(data);
      print('Received data: $message');
    });
  }

  // 6. Transmit data to the host server
  void transmitDataToServer(String data) {
    if (_isConnectedToServer && _clientSocket != null) {
      _clientSocket!.write(data);
    } else {
      print('Not connected to any server');
    }
  }

  // 7. Transmit data to client devices
  void transmitDataToClients(String data) {
    if (_isServerRunning && _clientSocket != null) {
      _clientSocket!.write(data);
    } else {
      print('Server is not running');
    }
  }
}