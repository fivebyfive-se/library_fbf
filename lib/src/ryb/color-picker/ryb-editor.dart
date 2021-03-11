import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../dart/extensions/iterable.dart';

import '../ryb-color.dart';

typedef RYBChangedCallback = void Function(RYBColor);

class RYBEditor extends StatelessWidget {
  RYBEditor({this.color, this.onChanged});

  final RYBColor color;
  final RYBChangedCallback onChanged;

  static const _channelNames = [
    "Alpha",
    "Red",
    "Yellow",
    "Blue"
  ];

  List<int> get _channels => color.toList(); 

  void _setValue(int idx, int value) {
    onChanged?.call(color.withChannel(idx, value));
  }

  Widget _channel(int idx) {
    final name      = _channelNames[idx];
    final val       = _channels[idx];
    final valString = val.toString();
    final ctrl = TextEditingController.fromValue(
      TextEditingValue(
        text: valString
      )
    );
    final cursorToEnd = () => ctrl.selection = TextSelection.fromPosition(
      TextPosition(offset: ctrl.text.length)
    );
    final setVal = (double v) => _setValue(idx, v.toInt());
    
    return Expanded(
      flex: 1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Text(name)
          ),
          Expanded(
            flex: 17,
            child: Slider(
              label: valString,
              min: 0,
              max: 255,
              onChanged: setVal,
              value: val.toDouble(),
            )
          ),
          Expanded(
            flex: 4,
            child: TextField(
              inputFormatters: [
                TextInputFormatter.withFunction(
                  (oldValue, newValue) => TextEditingValue(
                    text: newValue.text.replaceAll(r'[\D]', '')
                  )
                )
              ],
              keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
              controller: ctrl,
              // onChanged: (s) => setVal(double.tryParse(s)),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(4.0)
              ),
              onChanged: (v) => cursorToEnd(),
              onEditingComplete: () => setVal(double.tryParse(ctrl.text)),
            )
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 6,
          child: Column(
            children: <Widget>[
              ..._channels.mapIndex(
                (_, i) => _channel(i)
              ).toList()
            ],
          )
        ),
      ]
    );
  }
}