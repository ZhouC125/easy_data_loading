import 'package:flutter/material.dart';
import 'loading_status.dart';

class LoadingWidget {
  static double maxHeight = double.maxFinite;

  /// 网络加载错误页面
  static Widget buildNetworkBlockedView(
      BuildContext context, String desc, Function? function) {
    return buildGeneralTapView(
      url: "assets/image/loading/network_error@2x.png",
      desc: desc,
      onTap: function,
      context: context,
    );
  }

  /// 加载错误页面
  static Widget buildErrorView(BuildContext context, String errorDesc,
      List<String> errorStack, Function? function) {
    return buildGeneralTapView(
      url: "assets/image/loading/loading_error@2x.png",
      desc: errorDesc,
      onTap: function,
      errorStack: errorStack,
      context: context,
    );
  }

  /// 加载成功但数据为空 View
  static Widget buildLoadingSucButEmptyView(
      BuildContext context, EmptyStatus emptyStatus) {
    return LoadingWidget.buildGeneralTapView(
      url: emptyStatus.icon,
      desc: emptyStatus.name,
      onTap: null,
      context: context,
    );
  }

  /// 编译通用页面
  static Widget buildGeneralTapView({
    String url = "",
    String? desc,
    Function? onTap,
    List<String>? errorStack,
    required BuildContext context,
  }) {
    return Container(
      color: Colors.white,
      width: double.maxFinite,
      height: maxHeight,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 240,
            width: 240,
            child: Stack(
              children: [
                Image.asset(
                  url,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      desc ?? '',
                      style: const TextStyle(color: Color(0xFF8B909A), fontSize: 14),
                    ),
                  ),
                )
              ],
            ),
          ),
          if (onTap != null)
            SizedBox(
              width: 110,
              child: BorderRedBtnWidget(
                content: "重新加载",
                onClick: onTap,
                padding: 20.0,
              ),
            ),
          const SizedBox(height: 20),
          if (errorStack != null && errorStack.isNotEmpty)
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return Scaffold(
                      body: ListView.builder(
                        itemBuilder: (c, index) {
                          return ListTile(
                            dense: true,
                            title: Text(errorStack[index]),
                          );
                        },
                        itemCount: errorStack.length,
                      ),
                    );
                  },
                );
              },
              child: const Text(
                '错误日志',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}

class BorderRedBtnWidget extends StatelessWidget {
  const BorderRedBtnWidget({
    Key? key,
    padding = 16.0,
    radius = 19.0,
    required content,
    required onClick,
  })  : _content = content,
        _padding = padding,
        _onClick = onClick,
        _radius = radius,
        super(key: key);

  final String _content;
  final double _padding;
  final VoidCallback _onClick;
  final double _radius; //圆角

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _onClick,
      style: ButtonStyle(
          textStyle: MaterialStateProperty.all(const TextStyle(
            fontSize: 14,
            color: Color(0xFF0086FB),
            decoration: TextDecoration.none,
          )),
          backgroundColor: MaterialStateProperty.all(Colors.white),
          foregroundColor: MaterialStateProperty.all(const Color(0xFF0086FB)),
          side: MaterialStateProperty.all(
            const BorderSide(
              color: Color(0xFF0086FB),
              width: 1,
            ),
          ),
          padding: MaterialStateProperty.all(
              EdgeInsets.only(left: _padding, right: _padding)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(_radius))))),
      child: Text(_content, style: const TextStyle(fontSize: 14)),
    );
  }
}
