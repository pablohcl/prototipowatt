import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();
    if (newTextLength == 6) {
      if(!newValue.text.contains('-')){
        newText.write(newValue.text.substring(0, usedSubstringIndex = 5) + '-');
        if (newValue.selection.end >= 6) selectionIndex++;
      }
    }


    // Dump the rest
    if (newTextLength >= usedSubstringIndex) {
      newText.write(newValue.text.substring(usedSubstringIndex));
      return TextEditingValue(
        text: newText.toString(),
        selection: TextSelection.collapsed(offset: selectionIndex),
      );
    }

    throw 'Erro no CpfTextFormatter!';
  }
}