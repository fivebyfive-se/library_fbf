import 'package:flutter/material.dart';

class TogglableText extends StatefulWidget {
  TogglableText({this.initalText, this.onChanged, this.style});

  final String initalText;
  final void Function(String) onChanged;
  final TextStyle style;

  @override
  _TogglableTextState createState() => _TogglableTextState();
}

class _TogglableTextState extends State<TogglableText> {
  TextEditingController _controller;
  FocusNode _focusNode;
  bool _editingText = false;

  void _applyChange() {
    widget.onChanged?.call(_controller.text);

    setState(() => _editingText = false);
  }

  void _edit()
    => setState(() => _editingText = true);

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController.fromValue(
      TextEditingValue(text: widget.initalText)
    );

    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _editingText) {
        _applyChange();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: _editingText 
      ? TextField(
          controller: _controller,
          focusNode: _focusNode,
          onEditingComplete: _applyChange,
        )
      : TextButton(
        child: Text(
          _controller.text,
          style: widget.style
        ),
        onPressed: _edit,
      )
    );
  }
}