import 'package:flutter/cupertino.dart';
// ignore: unnecessary_import
import 'loading_status.dart';
typedef UpdateDataLoad = void Function();
/// 加载页面控制器
class LoadingViewController extends ChangeNotifier {
  LoadingViewController({this.status = LoadingStatus.loading});
  LoadingStatus status;
  ///更新加载数据
  UpdateDataLoad? updateDataLoad;
  ///完成
  void finish() {
    status = LoadingStatus.loading_suc;
    notifyListeners();
  }

  /// 无数据
  void emptyData() {
    status = LoadingStatus.loading_suc_but_empty;
    notifyListeners();
  }

  ///错误
  void error() {
    status = LoadingStatus.error;
    notifyListeners();
  }

  ///网络错误
  void networkBlocked() {
    status = LoadingStatus.network_blocked;
    notifyListeners();
  }

  ///加载中
  void loading() {
    status = LoadingStatus.loading;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    updateDataLoad = null;
  }
}
