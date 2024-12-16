import 'package:flutter/material.dart';

void main() => runApp(KellyApp());

class KellyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '凱利公式下注計算器',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: BettingCalculator(),
    );
  }
}

class BettingCalculator extends StatefulWidget {
  @override
  _BettingCalculatorState createState() => _BettingCalculatorState();
}

class _BettingCalculatorState extends State<BettingCalculator> {
  final TextEditingController _lowCardController = TextEditingController();
  final TextEditingController _highCardController = TextEditingController();
  final TextEditingController _capitalController = TextEditingController();
  final TextEditingController _oddsController = TextEditingController();

  String _result = ""; // 結果顯示

  /// 計算勝率
  double calculateProbability(int lowCard, int highCard) {
    if (lowCard >= highCard) return 0.0; // 無效範圍
    int totalCards = 13; // 單一花色總牌數
    int validCards = highCard - lowCard - 1; // 符合條件的牌數
    return validCards / totalCards;
  }

  /// 凱利公式計算下注比例
  double calculateKelly(double probability, double odds) {
    double q = 1 - probability;
    return (odds * probability - q) / odds;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('凱利公式下注計算器'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _lowCardController,
              decoration: InputDecoration(
                labelText: '低牌 (例如：2)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _highCardController,
              decoration: InputDecoration(
                labelText: '高牌 (例如：13)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _oddsController,
              decoration: InputDecoration(
                labelText: '賠率 (例如：2.0)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _capitalController,
              decoration: InputDecoration(
                labelText: '總資金 (例如：1000)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                // 輸入檢查
                int? lowCard = int.tryParse(_lowCardController.text);
                int? highCard = int.tryParse(_highCardController.text);
                double? odds = double.tryParse(_oddsController.text);
                double? capital = double.tryParse(_capitalController.text);

                if (lowCard == null ||
                    highCard == null ||
                    odds == null ||
                    capital == null ||
                    lowCard < 1 ||
                    lowCard > 13 ||
                    highCard < 1 ||
                    highCard > 13 ||
                    capital <= 0 ||
                    odds <= 0) {
                  setState(() {
                    _result = "請輸入正確的數值！";
                  });
                  return;
                }

                // 計算勝率
                double probability = calculateProbability(lowCard, highCard);
                if (probability <= 0) {
                  setState(() {
                    _result = "低牌必須小於高牌！";
                  });
                  return;
                }

                // 計算凱利公式下注比例與金額
                double kellyFraction = calculateKelly(probability, odds);
                double betAmount = (kellyFraction > 0) ? capital * kellyFraction : 0.0; // 最小值為 0

                setState(() {
                  _result =
                      "勝率: ${(probability * 100).toStringAsFixed(2)}%\n"
                      "建議下注金額: ${betAmount.toStringAsFixed(2)} 元";
                });
              },
              child: Text('計算'),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                _result,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
