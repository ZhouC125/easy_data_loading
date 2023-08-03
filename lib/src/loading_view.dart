import 'package:flutter/material.dart';

import 'loading_status.dart';
import 'loading_view_controller.dart';
import 'loading_widget.dart';
import 'platform_progress_indicator.dart';
// ignore: unnecessary_import

class LoadingView<T> extends StatefulWidget {
  const LoadingView({
    Key? key,
    this.controller,
    required this.builder,
    required this.dataLoad,

    /// 需要加载的Widget
    this.todoAfterError,

    /// 错误点击重试
    this.todoAfterNetworkBlocked,

    /// 网络错误点击重试
    this.networkBlockedDesc = '网络连接超时，请检查你的网络环境',
    this.errorDesc = '加载失败',
    this.emptyStatus = EmptyStatus.noData,
    this.maxHeight,
    this.isKeepAlive = false,
  }) : super(key: key);

  ///数据加载的控制器
  final LoadingViewController? controller;

  /// 需要加载的Widget
  final Widget Function(T data, LoadingViewController controller) builder;

  /// 数据加载
  final Future<T?> Function(LoadingViewController controller) dataLoad;

  /// 接口错误加载重试
  final Function(LoadingViewController controller)? todoAfterError;

  /// 网络错误加载重试
  final Function(LoadingViewController controller)? todoAfterNetworkBlocked;

  /// 网络错误提示文案
  final String networkBlockedDesc;

  /// 接口错误提示文案
  final String errorDesc;

  ///暂无数据
  final EmptyStatus emptyStatus;

  /// 最大高度
  final double? maxHeight;

  /// 是否保持状态
  final bool isKeepAlive;



  @override
  State<StatefulWidget> createState() {
    return _LoadingViewState<T>();
  }
}

class _LoadingViewState<T> extends State<LoadingView<T>>
    with AutomaticKeepAliveClientMixin {
  late final LoadingViewController _controller =
      widget.controller ?? LoadingViewController();

  final List<String> errorStack = [];

  ///数据
  T? data;

  @override
  void initState() {
    _controller.addListener(_updateView);
    _controller.updateDataLoad = initDataLoad;
    if (widget.maxHeight != null) LoadingWidget.maxHeight = widget.maxHeight!;
    initDataLoad();
    super.initState();
  }

  ///数据加载
  initDataLoad() async {
    _controller.loading();
    widget.dataLoad.call(_controller).then((value) {
      data = value;
      if (value == null ||value == '') {
        _controller.emptyData();
      } else {
        _controller.finish();
      }
    }).catchError((e, s) {
      errorStack
        ..add(e.toString())
        ..add(s.toString())
        ..add('=     =       =       =         =     =      =     =      =     =');
      try {
        if (e.code == -1) {
          _controller.networkBlocked();
          return;
        }
      } catch (e, s) {
        errorStack
          ..add(e.toString())
          ..add(s.toString())
          ..add('=     =       =       =         =     =      =     =      =     =');
      }
      _controller.error();
      debugPrintStack(stackTrace: s);
      throw Exception(e);
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_updateView);
    _controller.dispose();
    super.dispose();
  }

  /// 更新LoadingStatus
  _updateView() {
    // 避免widget在build时setState()
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint("updateStatus:${_controller.status}");
      if (mounted) setState(() {});
    });
  }

  /// 加载中View
  Widget _buildLoadingView() => LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: widget.maxHeight ?? constraints.maxHeight,
          child: const Center(
            child: PlatformProgressIndicator(),
          ),
        );
      });

  /// body by status
  Widget _buildBody(BuildContext context) {
    switch (_controller.status) {
      case LoadingStatus.idle:
      case LoadingStatus.loading:
        return _buildLoadingView();
      case LoadingStatus.loadingSuc:
        return widget.builder.call(data as T, _controller);
      case LoadingStatus.loadingSucButEmpty:
        return LoadingWidget.buildLoadingSucButEmptyView(
            context, widget.emptyStatus);
      case LoadingStatus.error:
        return LoadingWidget.buildErrorView(
            context, widget.errorDesc, errorStack, () {
          initDataLoad();
          widget.todoAfterError?.call(_controller);
        });
      case LoadingStatus.networkBlocked:
        return LoadingWidget.buildNetworkBlockedView(
            context, widget.networkBlockedDesc, () {
          initDataLoad();
          widget.todoAfterNetworkBlocked?.call(_controller);
        });
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildBody(context);
  }

  @override
  bool get wantKeepAlive => widget.isKeepAlive;
}
