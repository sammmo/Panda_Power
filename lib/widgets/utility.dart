/*
Shared widgets
 */

import 'package:flutter/material.dart';

class TextEntryWidget extends StatelessWidget {
  final onChanged;

  const TextEntryWidget({Key key, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextField(
      decoration: InputDecoration(

      ),
      textCapitalization: TextCapitalization.words,
      onSubmitted: this.onChanged,
      autofocus: true,
    );
  }


}