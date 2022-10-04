import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:math';//path名をランダムにするために使用

final ioProvider = ChangeNotifierProvider.autoDispose<IoController>(
      (ref) => IoController(),
);



class IoController extends ChangeNotifier {
  IoController(){
    /// 初期化処理をここに書く
    /// コンストラクタで非同期処理をやりたい場合どうすのがいいんでしょう？
    Future(() async {
      content = 'ファイルに書き込まれた時間を表示します';
      final _localPath = await localPath;
      appPath = '$_localPath/playground/';
      appDirectory =Directory(appPath);

      /// 新しくディレクトリをつくる
      await appDirectory.create(recursive: true);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  String appPath='';//変更箇所20220827/初期化した
  String content='';//変更箇所20220827/初期化した
  Directory appDirectory = Directory('');//変更箇所20220827/初期化した


  /// ローカルパスの取得
  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    notifyListeners();
    return directory.path;
  }

  var _randomStr;
  /// 現在時刻の書き込み
  Future<void> write() async {
    //pathの文字列のランダム生成
    const characters = 'abcdefghijklmnopqrstuvwxyz';
    var random = Random();
    _randomStr = String.fromCharCodes(Iterable.generate(
        15, (_) => characters.codeUnitAt(random.nextInt(characters.length))
    ));

    final file = File('$appPath/$_randomStr');
    print('write: ${file.path}');
    await file.writeAsString(DateTime.now().toString());
  }

  /// 現在時刻の読み込み
  Future<void> read() async {
    final file = File('$appPath/$_randomStr');
    content = await file.readAsString();
    notifyListeners();
  }

  List<Item> _items =<Item>[];

  List<Item> get items => _items;

  void add(Item Item){
    _items.add(Item);
    notifyListeners();
  }


}

class Item{
  const Item(this.title);
  final String title;
}