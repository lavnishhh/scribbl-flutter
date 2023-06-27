import 'package:flutter/material.dart';
import 'package:scribbl/lan/lan.dart';

class HostPage extends StatefulWidget {
  const HostPage({super.key});

  @override
  State<HostPage> createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
  bool isScanning = true;

  void setScanningState(bool state) {
    setState(() {
      isScanning = state;
    });
  }

  @override
  Widget build(BuildContext context) {

    if(isScanning){
      Server server = Server();
      server.createServer();
    }


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton.tonal(
                        onPressed: () {
                          setState(() {
                            setScanningState(!isScanning);
                          });
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.wifi_tethering),
                            const SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                                width: 90,
                                child: Text(
                                  isScanning
                                      ? "Stop Scanning"
                                      : "Start Scanning",
                                  textAlign: TextAlign.center,
                                ))
                          ],
                        ))
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton.tonal(
                        onPressed: () {},
                        child: const Row(
                          children: [
                            Icon(Icons.start),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Start")
                          ],
                        ))
                  ],
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    child: SizedBox(
                        child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                            itemCount: 5,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                  // titleAlignment: "titleAlignment",
                                leading: const Icon(Icons.done),
                                  title: const Text('Headline Text'),
                                  trailing: IconButton(
                                      icon: const Icon(
                                          Icons.person_remove_alt_1_outlined),
                                    onPressed: (){

                                    },
                                  ));
                            }))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
