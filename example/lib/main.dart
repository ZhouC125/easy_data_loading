import 'package:easy_data_loading/easy_data_loading.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final LoadingViewController _controller = LoadingViewController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('加载页面'),
        ),
        body: SafeArea(
          child: Column(
            children: [
               Expanded(
                child: Center(
                    child: LoadingView(
                      controller: _controller,
                      dataLoad: (LoadingViewController controller) async{
                        await Future.delayed(const Duration(seconds: 2));
                        return Future.value({'name':'1'});
                      },
                      builder: (data,_) {
                        return Text(data['name']??'name');
                      },
                    ),
                    ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _controller.updateDataLoad?.call();
                        });
                      },
                      child: const Text('刷新'),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                        child: const Text('错误'),
                        onPressed: () {
                          setState(() {
                            _controller.error();
                          });
                        }),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(child: const Text('无数据'),onPressed:(){
                      setState(() {
                        _controller.emptyData();
                      });
                    }),
                  ),
                  Expanded(
                    child: TextButton(child: const Text('网络错误'),onPressed:(){
                      setState(() {
                        _controller.networkBlocked();
                      });
                    }),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
