import 'package:flutter/material.dart';
import 'package:mathapp/components/countdown_progressbar.dart';

// ---------------------------------------------------------------------------
// VÍ DỤ SỬ DỤNG
// ---------------------------------------------------------------------------
class QuizDemoPage extends StatefulWidget {
  const QuizDemoPage({super.key});

  @override
  State<QuizDemoPage> createState() => _QuizDemoPageState();
}

class _QuizDemoPageState extends State<QuizDemoPage> {
  final _timer = CountdownBarController();
  String _status = 'Hãy trả lời nhanh!';

  void _onAnswer() {
    _timer.stop(); // dừng đồng hồ khi đã chọn đáp án
    setState(() => _status = 'Đã trả lời, còn ${_timer.remaining.inSeconds}s');
  }

  void _nextQuestion() {
    setState(() => _status = 'Hãy trả lời nhanh!');
    _timer.restart(); // câu mới -> đếm lại 10 giây
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz nhanh')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CountdownProgressBar(
              duration: const Duration(seconds: 10),
              controller: _timer,
              onComplete: () => setState(() => _status = 'Hết giờ!'),
            ),
            const SizedBox(height: 32),
            Text(_status, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _onAnswer,
              child: const Text('Chọn đáp án'),
            ),
            ElevatedButton(
              onPressed: _nextQuestion,
              child: const Text('Câu tiếp theo'),
            ),
          ],
        ),
      ),
    );
  }
}
