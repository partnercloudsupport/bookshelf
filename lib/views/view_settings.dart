import 'dart:async';

import 'package:bookshelf/util/util.dart';
import 'package:flutter/material.dart';
import 'package:bookshelf/service/setting.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';

class ViewSettings extends StatefulWidget {
  const ViewSettings({ Key key }) : super(key: key);

  @override
  ViewSettingsState createState() => new ViewSettingsState();
}

class ViewSettingsState extends State<ViewSettings> {
  Map settings;
  String cacheSize;

  @override
  void initState() {
    super.initState();
    _getSettings();
  }

  _toggleScreenAwake() async {
    setState(() => settings['general']['keep-screen-on'] = !settings['general']['keep-screen-on']);
    await setSettings(settings);
  }
  _toggleOpenSearchRecord() async {
    setState(() => settings['general']['record-search-keyword'] = !settings['general']['record-search-keyword']);
    await setSettings(settings);
  }
  _getSettings() async {
    Map data = await getSettings();
    setState(() => settings = data);
    getDiskCachedImagesSize().then((int size) {
      if (size != null) setState(() => cacheSize = fileSize(size));
      else setState(() => cacheSize = '0KB');
    });
  }

  @override
  Widget build(BuildContext context) {
    const EdgeInsetsGeometry tileItemPadding = const EdgeInsets.only(left: 50.0);
    const EdgeInsetsGeometry dividerPadding = const EdgeInsets.only(top: 5.0);

    return new Scaffold(
      appBar: new AppBar(
        title: const Text('设置'),
      ),
      body: new ListView(
        children: <Widget>[
//          new Container(
//            padding: const EdgeInsets.fromLTRB(66.0, 15.0, 0.0, 5.0),
//            child: new Text('阅读器设置', style: new TextStyle(color: Theme.of(context).primaryColor))
//          ),
//          new ListTile(
//            title: new Container(
//              padding: tileItemPadding,
//              child: const Text('漫画/同人志'),
//            ),
//            subtitle: new Container(
//              padding: tileItemPadding,
//              child: const Text('阅读方向: 竖向(从上至下)'),
//            ),
//            onTap: () {
//              _mangaViewerSettings(context).then((val) {
//                print(val);
//              });
//            },
//          ),
//          new ListTile(
//            title: new Container(
//              padding: tileItemPadding,
//              child: const Text('小说'),
//            ),
//            subtitle: new Container(
//              padding: tileItemPadding,
//              child: const Text('阅读方向: 横向(从上至下)'),
//            ),
//            onTap: () {},
//          ),
//          new Padding(
//            padding: dividerPadding,
//            child: new Divider(),
//          ),
          new Container(
              padding: const EdgeInsets.fromLTRB(66.0, 15.0, 0.0, 5.0),
              child: new Text('通用设置', style: new TextStyle(color: Theme.of(context).primaryColor))
          ),
          new SwitchListTile(
            title: new Container(
              padding: tileItemPadding,
              child: const Text('阅读时保持屏幕常亮'),
            ),
            value: settings != null ? settings['general']['keep-screen-on'] : false,
            onChanged: (bool value) {
              _toggleScreenAwake();
            },
          ),
//          new ListTile(
//            title: new Container(
//              padding: tileItemPadding,
//              child: const Text('书架屏幕方向'),
//            ),
//            subtitle: new Container(
//              padding: tileItemPadding,
//              child: const Text('自动选择'),
//            ),
//            onTap: () {},
//          ),
          new SwitchListTile(
            title: new Container(
              padding: tileItemPadding,
              child: const Text('启用搜索记录'),
            ),
            value: settings != null ? settings['general']['record-search-keyword'] : false,
            onChanged: (bool value) => _toggleOpenSearchRecord(),
          ),
          new Container(
              padding: const EdgeInsets.fromLTRB(66.0, 15.0, 0.0, 5.0),
              child: new Text('杂项', style: new TextStyle(color: Theme.of(context).primaryColor))
          ),
//          new ListTile(
//            title: new Container(
//              padding: tileItemPadding,
//              child: const Text('备份应用数据'),
//            ),
//            subtitle: new Container(
//              padding: tileItemPadding,
//              child: const Text('上次备份时间是21天前'),
//            ),
//            onTap: () {},
//          ),
//          new ListTile(
//            title: new Container(
//              padding: tileItemPadding,
//              child: const Text('还原应用数据'),
//            ),
//            subtitle: new Container(
//              padding: tileItemPadding,
//              child: const Text('还原喜爱列表和阅读列表(在线阅读)'),
//            ),
//            onTap: () {},
//          ),
          new ListTile(
            title: new Container(
              padding: tileItemPadding,
              child: const Text('优化'),
            ),
            subtitle: new Container(
              padding: tileItemPadding,
              child: const Text('整理数据库'),
            ),
            onTap: () {},
          ),
          new ListTile(
            title: new Container(
              padding: tileItemPadding,
              child: const Text('清理缓存'),
            ),
            subtitle: new Container(
              padding: tileItemPadding,
              child: new Text('已占用$cacheSize空间'),
            ),
            onTap: () {
              clearDiskCachedImages().then((bool val) {
                getDiskCachedImagesSize().then((int size) {
                  if (size != null) setState(() => cacheSize = fileSize(size));
                  else setState(() => cacheSize = '0KB');
                });
              });
            },
          ),
        ],
      ),
    );
  }

//  Future<Null> _mangaViewerSettings(BuildContext context) async {
//    return await showDialog(
//        context: context,
//        child: new SimpleDialog(
//          title: const Text('漫画/同人志设置'),
//          children: <Widget>[
//            new SimpleDialogOption(
////              child: new SwitchListTile(
////                title: const Text(''),
////                  value: null,
////                  onChanged: null
////              ),
//            ),
//          ],
//        ),
//    );
//  }
}
