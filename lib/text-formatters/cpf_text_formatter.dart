import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CpfTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();
    if (newTextLength == 4) {
      if(!newValue.text.contains('.')){
        newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + '.');
        if (newValue.selection.end >= 4) selectionIndex++;
      }
    }
    if (newTextLength == 8) {
      if(!newValue.text.substring(4).contains('.')){
        newText.write(newValue.text.substring(0, usedSubstringIndex = 7) + '.');
        if (newValue.selection.end >= 8) selectionIndex++;
      }
    }
    if (newTextLength == 12) {
      if(!newValue.text.substring(8).contains('-')){
        newText.write(newValue.text.substring(0, usedSubstringIndex = 11) + '-');
        if (newValue.selection.end >= 12) selectionIndex++;
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