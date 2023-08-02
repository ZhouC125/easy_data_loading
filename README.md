# 添加依赖
1、在`pubspec.yaml`中加入：

```
dependencies:
  easy_data_loading:
    git:
      url: https://github.com/ZhouC125/easy_data_loading.git
```

2、执行flutter命令获取包：
```
flutter pub get`
```

3、引入

```
import 'package:easy_data_loading/easy_data_loading.dart';

```

# 使用


```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('EasyDataLoading'),
    ),
    body:LoadingView(
      dataLoad: (LoadingViewController controller) async{
        await Future.delayed(const Duration(seconds: 2));
        return Future.value({'name':'1'});
      },
      builder: (data,_) {
        return Text(data['name']??'name');
      },
    ),
  );
}
```

`LoadingView` 的成员说明：
| 参数名                           | 类型                          | 描述                                                 | 默认值                                        |
|-------------------------------|-----------------------------|----------------------------------------------------|--------------------------------------------|
| builder               | `Widget Function(T data, LoadingViewController controller)`                      | 需要加载的Widget                                          | 必填                       |
| dataLoad               | `Future<T?> Function(LoadingViewController controller)`                      | 数据加载                                          | 必填                       |
| controller               | `LoadingViewController`                      | 数据加载的控制器                                          | null                                   |
| todoAfterError               | `Future<T?> Function(LoadingViewController controller)`                      | 接口错误加载重试                                          | null                       |
| todoAfterNetworkBlocked               | `Future<T?> Function(LoadingViewController controller)`                      | 网络错误加载重试                                          | null                      |
| networkBlockedDesc               | `String`                      | 网络错误提示文案                                          | 网络连接超时，请检查你的网络环境                      |
| errorDesc               | `String`                      | 接口错误提示文案                                          | 加载失败                      |
| emptyStatus               | `EmptyStatus`                      | 暂无数据                                          | EmptyStatus.noData                      |
| maxHeight               | `double`                      |  最大高度                                         | null                      |
| isKeepAlive               | `bool`                      |  是否保持状态                                         | false                      |
