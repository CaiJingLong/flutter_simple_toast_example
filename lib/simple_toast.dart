import 'dart:collection';

import 'package:flutter/material.dart';

LinkedHashMap<_SimpleToastState, BuildContext> _contextMap = LinkedHashMap();
const _defaultDuration = Duration(
  milliseconds: 2300,
);

const _opacityDuration = Duration(milliseconds: 250);

class SimpleToast extends StatefulWidget {
  final Widget child;

  const SimpleToast({Key key, this.child}) : super(key: key);

  @override
  _SimpleToastState createState() => _SimpleToastState();
}

class _SimpleToastState extends State<SimpleToast> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _contextMap.remove(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var overlay = Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (ctx) {
            _contextMap[this] = ctx;
            return widget.child;
          },
        ),
      ],
    );

    return Directionality(
      child: Stack(children: <Widget>[
        overlay,
        Positioned(
          left: 0.0,
          right: 0.0,
          top: 0.0,
          bottom: 0.0,
          child: IgnorePointer(
            child: Container(
              color: Colors.black.withOpacity(0.0),
            ),
          ),
        )
      ]),
      textDirection: TextDirection.ltr,
    );
  }
}

void showToast(
  String msg, {
  BuildContext context,
  Duration duration = _defaultDuration,
}) {
  context ??= _contextMap.values.first;
  Widget widget = Center(
    child: Container(
      margin: const EdgeInsets.all(50.0),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(5.0),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      child: ClipRect(
        child: Text(
          msg,
          style: const TextStyle(
            fontSize: 12.0,
          ),
        ),
      ),
    ),
  );

  showToastWidget(
    widget,
    context: context,
    duration: duration,
  );
}

void showToastWidget(
  Widget widget, {
  BuildContext context,
  Duration duration = _defaultDuration,
}) {
  context ??= _contextMap.values.first;
  var entry = OverlayEntry(builder: (ctx) {
    return IgnorePointer(
      child: _ToastContainer(
        duration: duration,
        child: widget,
      ),
    );
  });

  Future.delayed(duration, () {
    entry.remove();
  });

  Overlay.of(context).insert(entry);
}

class _ToastContainer extends StatefulWidget {
  final Duration duration;
  final Widget child;

  const _ToastContainer({Key key, this.duration, this.child}) : super(key: key);

  @override
  __ToastContainerState createState() => __ToastContainerState();
}

class __ToastContainerState extends State<_ToastContainer> {
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 30), () {
      setState(() {
        opacity = 1.0;
      });
    });

    Future.delayed(widget.duration - _opacityDuration, () {
      setState(() {
        opacity = 0.0;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: _opacityDuration,
      child: widget.child,
      opacity: opacity,
    );
  }
}
