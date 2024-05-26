import 'package:flutter/material.dart';

import '../model/card_model.dart';

class ExpansionSelector extends StatefulWidget {
  final bool value;
  final Expansion expansion;
  final Function(bool) onCheckChanged;

  const ExpansionSelector({
    super.key,
    required this.value,
    required this.expansion,
    required this.onCheckChanged,
  });

  @override
  State<StatefulWidget> createState() => _ExpansionSelectorState();
}

class _ExpansionSelectorState extends State<ExpansionSelector> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: widget.value,
          onChanged: (value) {
            _toggleCheck();
          },
        ),
        Text(widget.expansion.name),
      ],
    );
  }

  void _toggleCheck() {
    widget.onCheckChanged(!widget.value);
  }
}
