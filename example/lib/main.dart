import 'package:flutter/material.dart';
import 'package:tx_navibar/tx_navibar.dart';

const kHomeMainColor = Color.fromRGBO(94, 58, 178, 1.0);

const kLikesMainColor = Color.fromRGBO(187, 26, 139, 1.0);

const kSearchMainColor = Color.fromRGBO(231, 150, 8, 1.0);

const kProfileMainColor = Color.fromRGBO(24, 131, 154, 1.0);

void main() => runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      home: NavigationKeepAlive(),
    ));

class NavigationKeepAlive extends StatefulWidget {
  @override
  _NavigationKeepAliveState createState() => _NavigationKeepAliveState();
}

class _NavigationKeepAliveState extends State<NavigationKeepAlive>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  var _controller = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

//
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: _generatorWidget({
          "Home": kHomeMainColor,
          "Likes": kLikesMainColor,
          "Search": kSearchMainColor,
          "Profile": kProfileMainColor,
        }),
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: TXBottomNaviBar(
        tabChange: _tabChange,
        items: [
          BottomNaviItem(
              title: "Home",
              icon: "assets/home.png",
              backgroudColor: kHomeMainColor),
          BottomNaviItem(
              title: "Likes",
              icon: "assets/like.png",
              backgroudColor: kLikesMainColor),
          BottomNaviItem(
              title: "Search",
              icon: "assets/search.png",
              backgroudColor: kSearchMainColor),
          BottomNaviItem(
              title: "Profile",
              icon: "assets/person.png",
              backgroudColor: kProfileMainColor),
        ],
      ),
    );
  }

  _tabChange(int index, bool isChange) {
    print("index:$index--isChange:$isChange");
    if (isChange) {
      _controller.jumpToPage(index);
      _currentIndex = index;
      print("_currentIndex:$_currentIndex");
      setState(() {});
    }
  }
}

List<Widget> _generatorWidget(Map<String, Color> map) {
  List<Widget> list = [];
  map.forEach((title, color) {
    list.add(Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: color.withOpacity(0.5),
      ),
      body: Center(
        child: Text(
          "Click and Look the bottom naviBar change",
          style: TextStyle(fontSize: 18),
        ),
      ),
    ));
  });
  return list;
}
