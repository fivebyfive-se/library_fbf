import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../dart/extensions/string.dart';

extension FbfTextEditingControllerExtensions on TextEditingController {
  /// Move cursor in controlled textfield. A value of -1 represents
  /// the end of the input content.
  TextEditingController setCursor({int position = -1}) {
    final textLen = this.text.length;
    final offset = position < 0
      ? position + textLen + 1
      : math.min(position, textLen); 

    this.selection = TextSelection.fromPosition(
      TextPosition(offset: offset)
    );
    return this;
  }

  /// Insert text into a textfield, replacing any selected text
  TextEditingController insertText(String newText, [bool ensureWhiteSpace = true]) {
    if (validSelection) {
      final start = this.selection.base.offset;
      final end   = this.selection.extent.offset;
      String addText = newText;
      if (ensureWhiteSpace) {
        final prefix = start == 0 || text[start - 1].isWhitespace() 
          ? "" : " "; // prefix with space, unless beginning of selection
                      // is at  beginning of text, or to the right of 
                      // an existing space. Mutatis mutandis for end
                      // of selection.
        final suffix = end == text.length || text[end].isWhitespace()
          ? "" : " ";
        addText = "$prefix$newText$suffix";
      }
      this.text = text.replaceRange(start, end, addText);
      setCursor(position: end + addText.length);    
    } else {
      this.text += newText;
      setCursor();
    }

    return this;
  }

  TextEditingController setDoubleValue(double val, [int precision = 3]) {
    text = val.toStringAsPrecision(precision);
    return this;
  }

  double textToDouble([double fallback = 0.0]) 
    => double.tryParse(text) ?? fallback;

  int textToInt([int fallback = 0])
    => int.tryParse(text) ?? fallback;

  /// Shorthand for checking if there's a valid selection
  bool
  get validSelection => (this.selection != null && this.selection.isValid);
}

TextEditingController textEditCtrlFromValue(String value)
  => TextEditingController.fromValue(TextEditingValue(text: value));