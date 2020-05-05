import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final String title = 'Setting';
  String _value = null;
  List<String> _values = List<String>();
  var selectedTheme;
  var themes;

  @override
  void initState() {
    _values.addAll(['Red Theme', 'Green Theme', 'Dark Themes']);
    _value = _values.elementAt(0);
  }

  void _onChanged(String value) {
    setState(() {
      _value = value;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[800],
        title: Text(title),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
//              child: ListTile(
//                title: Text(
//                  'Theme',
//                  style: TextStyle(
//                    fontSize: 25.0,
//                    color: Colors.black,
//                    fontWeight: FontWeight.bold,
//                  ),
//                ),
//              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  DropdownButton(
                    value: _value,
                    items: _values.map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.color_lens),
                            Text('$value'),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      _onChanged(value);
                      selectedTheme = value.toString();
                    },
                  ),
                ],
              ),
            ),
            Divider(),
            ListTile(),
            Divider(),
            ListTile(),
            Divider(),
            ListTile(),
            Divider(),
            ListTile(),
            Divider(),
            ListTile(),
            Divider(),
          ],
        ),
      ),
    );
  }
}
