import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:process_run/shell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () async {
                // MacOS：在Flutter中导入文件的获取方式
                // 方法：
                //   1.文件夹放到工程根目录下
                //   2.pubspec.yaml文件声明资源文件
                //      assets:
                //          - platform-tools/MacOS/
                // 安装后文件路径：Contents/Frameworks/App.framework/Resources/flutter_assets/platform-tools/MacOS/adb

                // App的可执行文件路径
                String resolvedExecutablePath = Platform.resolvedExecutable;
                // 找到安装包根目录
                String rootPath = p.dirname(p.dirname(resolvedExecutablePath));
                // 定位到adb文件路径
                final adbPath = p.join(
                    rootPath,
                    "Frameworks",
                    "App.framework",
                    "Resources",
                    "flutter_assets",
                    "platform-tools",
                    "MacOS",
                    "adb");
                debugPrint("MacOS:Flutter导入文件 adbPath=$adbPath");
                // 运行adb命令
                try {
                  await Shell().runExecutableArguments(adbPath, ["--version"]);
                } catch (e) {
                  debugPrint("exec catch exception=$e");
                }
              },
              child: const Text("MacOS:Flutter导入文件"),
            ),
            TextButton(
              onPressed: () async {
                // MacOS：在Xcode中导入文件
                // 方法：
                //   1.将文件拷贝到macos/Runner/目录下
                //   2.用Xcode打开macos目录下的Runner.xcworkspace文件
                //   3.Xcode中选中左侧Runner目录后，右键 -> Add Files to "Runner"...
                //   4.在弹出框里面选择你要导入的文件，点击Add即可。
                // 安装后文件路径：Contents/Resources/platform-tools/adb

                // App的可执行文件路径
                String resolvedExecutablePath = Platform.resolvedExecutable;
                // 找到安装包根目录
                String rootPath = p.dirname(p.dirname(resolvedExecutablePath));
                debugPrint("rootPath=$rootPath");
                // 定位到adb文件路径
                final adbPath =
                    p.join(rootPath, "Resources", "platform-tools", "adb");
                debugPrint("MacOS：在Xcode中导入文件 adbPath=$adbPath");
                // 运行adb命令
                try {
                  await Shell().runExecutableArguments(adbPath, ["--version"]);
                } catch (e) {
                  debugPrint("exec catch exception=$e");
                }
              },
              child: const Text("MacOS：在Xcode中导入文件"),
            ),
            TextButton(
              onPressed: () async {
                // Windows: 在Flutter中导入文件
                // 方法：
                //  1.文件夹放到工程根目录
                //  2.pubspec.yaml文件声明资源文件
                //    assets:
                //        - platform-tools/Windows/
                // 安装后文件路径：data\flutter_assets\platformTools\Windows\adb.exe

                // App的可执行文件路径
                String resolvedExecutablePath = Platform.resolvedExecutable;
                String rootPath = p.dirname(resolvedExecutablePath);
                // 定位到adb文件路径
                final adbPath = p.join(rootPath, "data", "flutter_assets",
                    "platform-tools", "Windows", "adb.exe");
                debugPrint("Windows:在CMake里直接拷贝资源到安装包 adbPath=$adbPath");
                // 运行adb命令
                try {
                  await Shell().runExecutableArguments(adbPath, ["--version"]);
                } catch (e) {
                  debugPrint("exec catch exception=$e");
                }
              },
              child: const Text("Windows:在Flutter中导入文件"),
            ),
            TextButton(
              onPressed: () async {
                // Windows:在CMake里直接拷贝资源到安装包
                // 方法：
                //  1.文件加放到windows目录
                //  2.设置windows/CMakeLists.txt文件。在文件最后一个install方法的前面，加上下面的代码
                //    install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/" DESTINATION "${CMAKE_INSTALL_PREFIX}" COMPONENT Runtime)
                // 安装后文件路径：platform-tools\adb.exe

                // App的可执行文件路径
                String resolvedExecutablePath = Platform.resolvedExecutable;
                String rootPath = p.dirname(resolvedExecutablePath);
                // 定位到adb文件路径
                final adbPath = p.join(rootPath, "platform-tools", "adb.exe");
                debugPrint("Windows:在CMake里直接拷贝资源到安装包 adbPath=$adbPath");
                // 运行adb命令
                try {
                  await Shell().runExecutableArguments(adbPath, ["--version"]);
                } catch (e) {
                  debugPrint("exec catch exception=$e");
                }
              },
              child: const Text("Windows:在CMake里直接拷贝资源到安装包"),
            ),
          ],
        ),
      ),
    );
  }
}
