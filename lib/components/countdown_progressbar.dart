import 'package:flutter/material.dart';

/// Controller để điều khiển [CountdownProgressBar] từ bên ngoài.
class CountdownBarController {
  _CountdownProgressBarState? _state;

  /// Bắt đầu đếm ngược từ đầu (đầy thanh -> 0).
  void start() => _state?._start();

  /// Giống start(): dùng khi chuyển sang câu hỏi mới.
  void restart() => _state?._start();

  /// Tạm dừng (ví dụ: khi người chơi mở popup).
  void pause() => _state?._pause();

  /// Chạy tiếp từ thời điểm đã dừng.
  void resume() => _state?._resume();

  /// Dừng hẳn (ví dụ: khi người chơi đã trả lời), không gọi onComplete.
  void stop() => _state?._stop();

  /// Đưa thanh về trạng thái đầy nhưng không chạy.
  void reset() => _state?._reset();

  /// Thời gian còn lại.
  Duration get remaining => _state?.remaining ?? Duration.zero;

  bool get isRunning => _state?._anim.isAnimating ?? false;
}

/// Thanh thời gian giảm dần từ đầy -> 0 (mặc định 10 giây).
class CountdownProgressBar extends StatefulWidget {
  const CountdownProgressBar({
    super.key,
    this.duration = const Duration(seconds: 10),
    this.controller,
    this.autoStart = true,
    this.onComplete,
    this.onTick,
    this.height = 14,
    this.borderRadius = 10,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.startColor = const Color(0xFF4CAF50), // xanh lá (còn nhiều thời gian)
    this.midColor = const Color(0xFFFFC107), // vàng
    this.endColor = const Color(0xFFF44336), // đỏ (sắp hết giờ)
    this.showText = true,
    this.textStyle,
  });

  final Duration duration;
  final CountdownBarController? controller;
  final bool autoStart;

  /// Gọi khi đếm về 0.
  final VoidCallback? onComplete;

  /// Gọi mỗi khi số giây còn lại thay đổi (làm tròn lên).
  final ValueChanged<int>? onTick;

  final double height;
  final double borderRadius;
  final Color backgroundColor;
  final Color startColor;
  final Color midColor;
  final Color endColor;

  /// Hiện số giây còn lại bên phải thanh.
  final bool showText;
  final TextStyle? textStyle;

  @override
  State<CountdownProgressBar> createState() => _CountdownProgressBarState();
}

class _CountdownProgressBarState extends State<CountdownProgressBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  int _lastSecond = -1;

  Duration get remaining => Duration(
    milliseconds: (_anim.value * widget.duration.inMilliseconds).round(),
  );

  @override
  void initState() {
    super.initState();
    _anim =
        AnimationController(vsync: this, duration: widget.duration, value: 1.0)
          ..addListener(_handleTick)
          ..addStatusListener((status) {
            if (status == AnimationStatus.dismissed) {
              widget.onComplete?.call();
            }
          });

    widget.controller?._state = this;
    if (widget.autoStart) _start();
  }

  @override
  void didUpdateWidget(covariant CountdownProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._state = null;
      widget.controller?._state = this;
    }
    if (oldWidget.duration != widget.duration) {
      _anim.duration = widget.duration;
    }
  }

  @override
  void dispose() {
    widget.controller?._state = null;
    _anim.dispose();
    super.dispose();
  }

  void _handleTick() {
    final sec = (remaining.inMilliseconds / 1000).ceil();
    if (sec != _lastSecond) {
      _lastSecond = sec;
      widget.onTick?.call(sec);
    }
  }

  void _start() {
    _lastSecond = -1;
    _anim.reverse(from: 1.0);
  }

  void _pause() => _anim.stop();

  void _resume() {
    if (_anim.value > 0 && !_anim.isAnimating) _anim.reverse();
  }

  void _stop() => _anim.stop();

  void _reset() {
    _anim.stop();
    _anim.value = 1.0;
  }

  /// Chuyển màu mượt: xanh -> vàng -> đỏ theo phần trăm còn lại.
  Color _colorFor(double v) {
    if (v > 0.5) {
      return Color.lerp(widget.midColor, widget.startColor, (v - 0.5) * 2)!;
    }
    return Color.lerp(widget.endColor, widget.midColor, v * 2)!;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        final v = _anim.value;
        final color = _colorFor(v);
        final seconds = (remaining.inMilliseconds / 1000).ceil();

        final bar = ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: Container(
            height: widget.height,
            color: widget.backgroundColor,
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: v.clamp(0.0, 1.0),
              child: Container(color: color),
            ),
          ),
        );

        if (!widget.showText) return bar;

        return Row(
          children: [
            Expanded(child: bar),
            const SizedBox(width: 10),
            SizedBox(
              width: 28,
              child: Text(
                '$seconds',
                textAlign: TextAlign.end,
                style:
                    widget.textStyle ??
                    TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
            ),
          ],
        );
      },
    );
  }
}
