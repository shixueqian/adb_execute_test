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
  String? macAdbPath1;
  String? macAdbPath2;
  String? winAdbPath;

  final shell = Shell();

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
              onPressed: () {
                //App的可执行文件路径
                String resolvedExecutablePath = Platform.resolvedExecutable;

                if (Platform.isMacOS) {
                  // 1.MacOS：在Xcode中导入文件的获取方式
                  String rootPath =
                      p.dirname(p.dirname(resolvedExecutablePath));
                  debugPrint("rootPath=$rootPath");
                  macAdbPath1 =
                      p.join(rootPath, "Resources", "platform-tools", "adb");
                  // adb_execute_test.app/Contents/Resources/platform-tools/adb
                  debugPrint("macAdbPath1=$macAdbPath1");

                  // 2.MacOS：在Flutter中导入文件的获取方式
                  macAdbPath2 = p.join(
                      rootPath,
                      "Frameworks",
                      "App.framework",
                      "Resources",
                      "flutter_assets",
                      "platform-tools",
                      "MacOS",
                      "adb");
                  // adb_execute_test.app/Contents/Frameworks/App.framework/Resources/flutter_assets/platform-tools/MacOS/adb
                  debugPrint("macAdbPath2=$macAdbPath2");
                } else if (Platform.isWindows) {
                  // 3.Windows:在Flutter中导入文件的获取方式
                  String rootPath = p.dirname(resolvedExecutablePath);
                  final winAdbPath = p.join(rootPath, "data", "flutter_assets",
                      "platformTools", "Windows", "adb.exe");
                  // data\flutter_assets\platformTools\Windows\adb.exe
                  debugPrint("winAdbPath=$winAdbPath");
                }
              },
              child: const Text("获取adb文件路径"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await shell.runExecutableArguments(macAdbPath1!, ["devices"]);
                } catch (e) {
                  debugPrint("exec catch exception=$e");
                }
              },
              child: const Text("macAdbPath1:执行adb --version"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await shell
                      .runExecutableArguments(macAdbPath2!, ["--version"]);
                } catch (e) {
                  debugPrint("exec catch exception=$e");
                }
              },
              child: const Text("macAdbPath2:执行adb --version"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await shell
                      .runExecutableArguments(winAdbPath!, ["--version"]);
                } catch (e) {
                  debugPrint("exec catch exception=$e");
                }
              },
              child: const Text("winAdbPath:执行adb --version"),
            ),
          ],
        ),
      ),
    );
  }
}
