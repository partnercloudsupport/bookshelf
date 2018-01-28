import 'package:bookshelf/util/util.dart';
import 'package:flutter/material.dart';

class ViewSettings extends StatefulWidget {
  const ViewSettings({ Key key }) : super(key: key);

  @override
  ViewSettingsState createState() => new ViewSettingsState();
}

class ViewSettingsState extends State<ViewSettings> {
  bool keepScreenAwake = false;
  bool openSearchRecord = true;

  _toggleScreenAwake() async {
    if (keepScreenAwake) {
      if (!(await deactivateKeepScreenOn())) return;
    } else {
      if (!(await activateKeepScreenOn())) return;
    }
    setState(() => keepScreenAwake = !keepScreenAwake);
  }
  _toggleOpenSearchRecord() {
    setState(() => openSearchRecord = !openSearchRecord);
  }

  @override
  Widget build(BuildContext context) {
    const EdgeInsetsGeometry tileItemPadding = const EdgeInsets.only(left: 50.0);
    const EdgeInsetsGeometry dividerPadding = const EdgeInsets.only(top: 5.0);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('设置'),
      ),
      body: new ListView(
        children: <Widget>[
          new Container(
            padding: const EdgeInsets.fromLTRB(66.0, 15.0, 0.0, 5.0),
            child: new Text('阅读器设置', style: new TextStyle(color: Theme.of(context).primaryColor))
          ),
          new ListTile(
            title: new Container(
              padding: tileItemPadding,
              child: const Text('漫画/同人志'),
            ),
            subtitle: new Container(
              padding: tileItemPadding,
              child: const Text('阅读方向: 竖向(从上至下)'),
            ),
            onTap: () {},
          ),
          new ListTile(
            title: new Container(
              padding: tileItemPadding,
              child: const Text('小说'),
            ),
            subtitle: new Container(
              padding: tileItemPadding,
              child: const Text('阅读方向: 横向(从上至下)'),
            ),
            onTap: () {},
          ),
          new Padding(
            padding: dividerPadding,
            child: new Divider(),
          ),
          new Container(
              padding: const EdgeInsets.fromLTRB(66.0, 15.0, 0.0, 5.0),
              child: new Text('通用设置', style: new TextStyle(color: Theme.of(context).primaryColor))
          ),
          new SwitchListTile(
            title: new Container(
              padding: tileItemPadding,
              child: const Text('保持屏幕常亮'),
            ),
            value: keepScreenAwake,
            onChanged: (bool value) {
              _toggleScreenAwake();
            },
          ),
          new ListTile(
            title: new Container(
              padding: tileItemPadding,
              child: const Text('屏幕方向'),
            ),
            subtitle: new Container(
              padding: tileItemPadding,
              child: const Text('自动选择'),
            ),
            onTap: () {},
          ),
          new SwitchListTile(
            title: new Container(
              padding: tileItemPadding,
              child: const Text('搜索记录'),
            ),
//            subtitle: new Container(
//              padding: tileItemPadding,
//              child: new Text(openSearchRecord ? '已启用' : '已禁用'),
//            ),
            value: openSearchRecord,
            onChanged: (bool value) {
              _toggleOpenSearchRecord();
            },
          ),
          new Container(
              padding: const EdgeInsets.fromLTRB(66.0, 15.0, 0.0, 5.0),
              child: new Text('杂项', style: new TextStyle(color: Theme.of(context).primaryColor))
          ),
          new ListTile(
            title: new Container(
              padding: tileItemPadding,
              child: const Text('清空搜索记录'),
            ),
            onTap: () {},
          ),
          new ListTile(
            title: new Container(
              padding: tileItemPadding,
              child: const Text('备份应用数据'),
            ),
            subtitle: new Container(
              padding: tileItemPadding,
              child: const Text('上次备份时间是21天前'),
            ),
            onTap: () {},
          ),
          new ListTile(
            title: new Container(
              padding: tileItemPadding,
              child: const Text('还原应用数据'),
            ),
            subtitle: new Container(
              padding: tileItemPadding,
              child: const Text('还原喜爱列表和阅读列表(在线阅读)'),
            ),
            onTap: () {},
          ),
          new ListTile(
            title: new Container(
              padding: tileItemPadding,
              child: const Text('优化'),
            ),
            subtitle: new Container(
              padding: tileItemPadding,
              child: const Text('上次优化时间是3天前'),
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
              child: const Text('已占用3MB空间'),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
