// ignore: unnecessary_import

/// 状态枚举
enum LoadingStatus {
  idle, // 初始化
  loading, // 加载中
  loading_suc, // 加载成功
  loading_suc_but_empty, // 加载成功但是数据为空
  network_blocked, // 网络加载错误
  error, // 加载错误
}
///空数据状态
enum EmptyStatus {
  noRecord, //暂无记录
  noData, //暂无数据
  noCertificate, //暂无证书
}

extension EmptyStatusExtension on EmptyStatus {
  String get name {
    switch (this) {
      case EmptyStatus.noRecord:
        return '暂无记录';
      case EmptyStatus.noData:
        return '暂无数据';
      case EmptyStatus.noCertificate:
        return '暂无证书';
    }
  }

  String get icon {
    switch (this) {
      case EmptyStatus.noRecord:
        return 'assets/no_record@2x.png';
      case EmptyStatus.noData:
        return 'assets/no_data.png';
      case EmptyStatus.noCertificate:
        return 'assets/no_certificate@2x.png';
    }
  }
}
