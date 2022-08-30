import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CnpjFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();
    if (newTextLength == 3) {
      if(!newValue.text.contains('.')){
        newText.write(newValue.text.substring(0, usedSubstringIndex = 2) + '.');
        if (newValue.selection.end >= 3) selectionIndex++;
      }
    }
    if (newTextLength == 7) {
      if(!newValue.text.substring(4).contains('.')){
        newText.write(newValue.text.substring(0, usedSubstringIndex = 6) + '.');
        if (newValue.selection.end >= 7) selectionIndex++;
      }
    }
    if (newTextLength == 11) {
      if(!newValue.text.substring(8).contains('/')){
        newText.write(newValue.text.substring(0, usedSubstringIndex = 10) + '/');
        if (newValue.selection.end >= 11) selectionIndex++;
      }
    }
    if (newTextLength == 16) {
      if(!newValue.text.substring(12).contains('-')){
        newText.write(newValue.text.substring(0, usedSubstringIndex = 15) + '-');
        if (newValue.selection.end >= 16) selectionIndex++;
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