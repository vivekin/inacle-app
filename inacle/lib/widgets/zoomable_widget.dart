import 'package:flutter/material.dart';

class ZoomableWidget extends StatefulWidget {
  final Widget child;

  const ZoomableWidget({super.key, required this.child});

  @override
  _ZoomableWidgetState createState() => _ZoomableWidgetState();
}

class _ZoomableWidgetState extends State<ZoomableWidget> {
  double _scale = 1.0;
  final double _previousScale = 1.0;
  final Offset _offset = Offset.zero;
  final Offset _normalizedOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
// onScaleStart: (ScaleStartDetails details) {
// _previousScale = _scale;
// _normalizedOffset = (details.focalPoint - _offset) / _scale;
// setState(() {});
// },
// onScaleUpdate: (ScaleUpdateDetails details) {
// setState(() {
// _scale = (_previousScale * details.scale).clamp(0.5, 4.0);
// _offset = details.focalPoint - _normalizedOffset * _scale;
// });
// },
// onScaleEnd: (ScaleEndDetails details) {
// _previousScale = 1.0;
// },
      onDoubleTap: () {
        setState(() {
          if (_scale == 1.0) {
            _scale = 2.0;
          } else {
            _scale = 1.0;
          }
        });
      },
      child: Transform(
        transform: Matrix4.identity()
          ..translate(_offset.dx, _offset.dy)
          ..scale(_scale),
        child: widget.child,
      ),
    );
  }
}
