import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/card_filter_slider.dart';
import 'components/card_item.dart';
import 'components/custom_appbar.dart';
import 'components/custom_scaffold.dart';
import 'components/expansion_selector.dart';
import 'model/card_model.dart';
import 'providers/card_provider.dart';

class DominionScreen extends StatefulWidget {
  const DominionScreen({super.key});

  @override
  State<DominionScreen> createState() => _DominionScreenState();
}

class _DominionScreenState extends State<DominionScreen> {
  CardFilterOption addCardCardOption = CardFilterOption.oneOrMore;
  CardFilterOption addActionCardOption = CardFilterOption.oneOrMore;
  CardFilterOption attackCardOption = CardFilterOption.oneOrMore;
  CardFilterOption discardCardOption = CardFilterOption.oneOrMore;
  final List<Expansion> _selectedExpansions = List.from(Expansion.values); // 수정된 부분
  late CardProvider _cardProvider;

  @override
  Widget build(BuildContext context) {
    _cardProvider = Provider.of<CardProvider>(context);
    return CustomScaffold(
      appBar: const CustomAppBar(title: Text('도미니언 덱 빌더')),
      body: Column(
        children: [
          _optionPart(),
          ElevatedButton(
            onPressed: () {
              _cardProvider.shuffleCards(
                  _selectedExpansions,
                  addActionCardOption,
                  attackCardOption,
                  addCardCardOption,
                  discardCardOption);
              setState(() {});
            },
            child: const Text('게임 생성'),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _resultPart(),
          ),
        ],
      ),
    );
  }

  Widget _optionPart() {
    return Row(
      children: [
        SizedBox(width: 200, child: _expansionSelectorPart()),
        Expanded(child: _cardCountOptionPart())
      ],
    );
  }

  Widget _cardCountOptionPart() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CardFilterButtons(
            label: "카드 추가 카드",
            value: addCardCardOption,
            onChanged: (value) {
              setState(() {
                addCardCardOption = value ?? CardFilterOption.noOption;
              });
            }),
        CardFilterButtons(
            label: "액션 추가 카드",
            value: addActionCardOption,
            onChanged: (value) {
              setState(() {
                addActionCardOption = value ?? CardFilterOption.noOption;
              });
            }),
        CardFilterButtons(
            label: "공격 카드",
            value: attackCardOption,
            onChanged: (value) {
              setState(() {
                attackCardOption = value ?? CardFilterOption.noOption;
              });
            }),
        CardFilterButtons(
            label: "폐기 카드",
            value: discardCardOption,
            onChanged: (value) {
              setState(() {
                discardCardOption = value ?? CardFilterOption.noOption;
              });
            }),
      ],
    );
  }
  Widget _expansionSelectorPart() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: Expansion.values.length,
      itemBuilder: (context, index) {
        Expansion expansion = Expansion.values[index];
        return ExpansionSelector(value: _selectedExpansions.contains(expansion), expansion: expansion, onCheckChanged: (checked) {
          print("checked changed to $checked");
          if (checked) {
            _selectedExpansions.add(expansion);
          } else {
            _selectedExpansions.remove(expansion);
            print("selected changed to $_selectedExpansions");
          }
          setState(() {});
        });
      },
    );
  }

  Widget _resultPart() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5, // 한 줄에 5개의 카드를 표시
        crossAxisSpacing: 4.0, // 가로 간격
        mainAxisSpacing: 4.0, // 세로 간격
      ),
      itemCount: _cardProvider.selectedCards.length,
      itemBuilder: (context, index) {
        return CardItem(
          card: _cardProvider.selectedCards[index],
          onPinned: (pinned) {
            setState(() {
              bool isPinned = _cardProvider.selectedCards[index].isPinned;
              _cardProvider.selectedCards[index].isPinned = !isPinned;
            });
          },
        );
      },
    );
  }
}
