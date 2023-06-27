import 'package:flutter/material.dart';

class BottomModalButton extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();

  BottomModalButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      labelText: 'Enter some text',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  FilledButton.tonal(
                    onPressed: () {
                      String enteredText = _textEditingController.text;
                      // Perform some action with the entered text
                      // For example, you can print it
                      print('Entered text: $enteredText');

                      // Close the bottom modal
                      Navigator.pop(context);
                    },
                    child: Text('Done'),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Text('Open Bottom Modal'),
    );
  }
}