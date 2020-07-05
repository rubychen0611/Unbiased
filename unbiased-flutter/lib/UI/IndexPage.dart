import 'package:flutter/material.dart';
import 'package:unbiased/UI/HomePage.dart';
import 'package:unbiased/UI/MinePage.dart';
import 'package:unbiased/Common/MyIcons.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IndexState();
  }
}

class _IndexState extends State<IndexPage> {
  int _selectedIndex = 0;

  final pages = [HomePage(), MinePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(MyIcons.balance, size:30),
              //SizedBox(width: 20), // 50宽度
              Text("Unbiased")
            ]
        ),
        centerTitle: true,
        ),
        bottomNavigationBar: BottomNavigationBar( // 底部导航
        items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(MyIcons.news), title: Text('News')),
        BottomNavigationBarItem(icon: Icon(MyIcons.me), title: Text('Mine')),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.teal,
        onTap: _onItemTapped,
        ),
        body:IndexedStack(
          index: this._selectedIndex,
          children: this.pages,),
        );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}