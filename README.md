# tx_navibar

A interesting bottom navibar.
![example.gif](https://github.com/TaurusXi/TxNaviBar/blob/master/example.gif)


## Run the example

You can run this example like this ...

```dash
cd example
flutter create .
flutter run
```


## How To Use

Import the library in your pubspec.yaml as this.

``` tx_navibar: 0.1.1 ```

It is very simple , you can use this package like ... . 

```dart
_tabChange(int index, bool isChange) {
    print("index:$index--isChange:$isChange");
    if (isChange) {
      _controller.jumpToPage(index);
      _currentIndex = index;
      print("_currentIndex:$_currentIndex");
      setState(() {});
    }
  }
var bottomNaviBar = TXBottomNaviBar(
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
      );
```

Continue......

## Getting Started

This project is a starting point for a Dart
[package](https://flutter.io/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
