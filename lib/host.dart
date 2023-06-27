import 'package:flutter/material.dart';

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
            Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: const SizedBox(
                  width: 300,
                  height: 100,
                  child: Center(child: Text('Filled Card')),
                )
            ),
          ],
        ),
      ),
    );
  }
}