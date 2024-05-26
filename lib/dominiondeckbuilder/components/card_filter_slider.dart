import 'package:flutter/material.dart';

class CardFilterButtons extends StatefulWidget {
  final String label;
  final CardFilterOption value;
  final Function(CardFilterOption?) onChanged;

  const CardFilterButtons({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  State<StatefulWidget> createState() => _CardFilterButtonsState();
}

class _CardFilterButtonsState extends State<CardFilterButtons> {
  CardFilterOption _selectedOption = CardFilterOption.noOption; // 기본 선택 옵션

  @override
  void initState() {
    _selectedOption = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: double.maxFinite,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(width: 150, child: Text(widget.label)),
          Radio(
            value: CardFilterOption.noOption,
            groupValue: _selectedOption,
            onChanged: (CardFilterOption? value) {
              widget.onChanged(value);
              setState(() {
                _selectedOption = value ?? CardFilterOption.noOption;
              });
            },
          ),
          const Text('-'),
          Radio(
            value: CardFilterOption.atMostZero,
            groupValue: _selectedOption,
            onChanged: (CardFilterOption? value) {
              widget.onChanged(value);
              setState(() {
                _selectedOption = value ?? CardFilterOption.noOption;
              });
            },
          ),
          const Text('0'),
          Radio(
            value: CardFilterOption.oneOrMore,
            groupValue: _selectedOption,
            onChanged: (CardFilterOption? value) {
              widget.onChanged(value);
              setState(() {
                _selectedOption = value ?? CardFilterOption.noOption;
              });
            },
          ),
          const Text('1+'),
          Radio(
            value: CardFilterOption.twoOrMore,
            groupValue: _selectedOption,
            onChanged: (CardFilterOption? value) {
              widget.onChanged(value);
              setState(() {
                _selectedOption = value ?? CardFilterOption.noOption;
              });
            },
          ),
          const Text('2+'),
        ],
      ),
    );
  }
}

enum CardFilterOption {
  noOption, atMostZero, oneOrMore, twoOrMore;

  int toCount() {
    switch(this) {
      case CardFilterOption.noOption: return 0;
      case CardFilterOption.oneOrMore: return 1;
      case CardFilterOption.twoOrMore: return 2;
      case CardFilterOption.atMostZero: return -1;
    }
  }
}