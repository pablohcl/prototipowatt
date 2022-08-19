import 'package:flutter/services.dart';

class InscrEstadualFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();
    
    if (newTextLength == 4) {
      if(!newValue.text.contains('/') && !newValue.text.contains('E')){
        newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + '/');
        if (newValue.selection.end >= 4) selectionIndex++;
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

    throw 'Erro no InscrEstadualFormatter!';
  }
}