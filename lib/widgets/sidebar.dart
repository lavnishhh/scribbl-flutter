import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {

    final ButtonStyle buttonStyle = TextButton.styleFrom(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      minimumSize: const Size(double.infinity, 0),
      textStyle: const TextStyle(
        fontSize: 20,
      ),
      alignment: Alignment.centerLeft,
    );

    return Drawer(
      // width: MediaQuery.of(context).size.width * 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 80, 5, 5),
            child: const Text(
              'SCRIBBLE',
              style: TextStyle(
                fontSize: 40,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Handle button 1 pressed
            },
            style: buttonStyle,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.edit
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                  Text(
                    'Change Name',
                    textAlign: TextAlign.left,
                  ),
                ],
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () {
                // Handle button 2 pressed
              },
              child: const Text('Button 2'),
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: TextButton(
              onPressed: () {
                // Handle button 1 pressed
              },
              style: buttonStyle,
              child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                          Icons.star_border_outlined
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(5, 5, 5, 50)),
                      Text(
                        'Rate',
                        textAlign: TextAlign.left,
                      ),
                    ],
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }
}
