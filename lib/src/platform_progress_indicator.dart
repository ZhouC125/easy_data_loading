import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 根据平台显示的进度指示器
class PlatformProgressIndicator extends StatelessWidget {
  const PlatformProgressIndicator({
    Key? key,
    this.strokeWidth = 4.0,
    this.radius = 10.0,
    this.size = 48.0,
    this.color,
    this.value,
    this.brightness,
  }) : super(key: key);

  /// 指示器的厚度，在 [CircularProgressIndicator] 时有效
  final double strokeWidth;

  /// 圆角度，在 [CupertinoActivityIndicator] 时有效
  final double radius;

  /// 预期大小
  final double size;

  /// 指示器的颜色，在 [CircularProgressIndicator] 时有效
  final Color? color;

  /// 指示器当前的进度，在 [CircularProgressIndicator] 时有效
  final double? value;

  /// 是否是暗黑模式，在 [CupertinoActivityIndicator] 时有效
  final Brightness? brightness;

  /// 是否是苹果系列系统
  bool get isAppleOS => Platform.isIOS || Platform.isMacOS;

  @override
  Widget build(BuildContext context) {
    Widget indicator;
    if (isAppleOS) {
      indicator = CupertinoTheme(
        data: CupertinoThemeData(
          brightness: brightness ?? Theme.of(context).brightness,
        ),
        child: CupertinoActivityIndicator(radius: radius),
      );
    } else {
      indicator = CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor:
            color != null ? AlwaysStoppedAnimation<Color?>(color) : null,
        value: value,
      );
    }
    return SizedBox.fromSize(size: Size.square(size), child: indicator);
  }
}
