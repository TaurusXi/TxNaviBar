library google_navibar;

import 'dart:math' as math;

import 'package:flutter/material.dart';

const double kTitleFontSize = 14.0;

typedef TabChange = Function(int, bool);

///  类似Google的底部tab栏
class TXBottomNaviBar extends StatefulWidget {
  final double elevation;

  final Color backgroundColor;

  final double fontSize;

  final List<BottomNaviItem> items;

  final TabChange tabChange;

  TXBottomNaviBar(
      {Key key,
      @required this.items,
      @required this.tabChange,
      this.elevation = 20.0,
      this.backgroundColor = Colors.white,
      this.fontSize = kTitleFontSize})
      : assert(items != null && items.length > 0),
        assert(tabChange != null),
        super(key: key);

  @override
  _TXBottomNaviBarState createState() => _TXBottomNaviBarState();
}

class _TXBottomNaviBarState extends State<TXBottomNaviBar> {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  bool _isAnimationFlag = false;

  bool get isAnimation => _isAnimationFlag;

  set isAnimation(flag) => _isAnimationFlag = flag;

  double _maxTitleWidth = -1.0;

  final textPainter = TextPainter(
    textDirection: TextDirection.ltr,
    maxLines: 1,
    text: TextSpan(
      text: "",
      style: TextStyle(fontSize: kTitleFontSize),
    ),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 计算最大的width
    widget.items.forEach((item) {
      textPainter.text = TextSpan(
          text: item.title, style: TextStyle(fontSize: kTitleFontSize));
      textPainter.layout();
      final _width = textPainter.size.width;
      print("_width:$_width");
      if (_maxTitleWidth < _width) {
        _maxTitleWidth = _width;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double additionalBottomPadding = math.max(
        MediaQuery.of(context).padding.bottom - kTitleFontSize / 2.0, 0.0);
//    print("additionalBottomPadding:$additionalBottomPadding");
    return Semantics(
      explicitChildNodes: true,
      child: Material(
        elevation: widget.elevation,
        color: widget.backgroundColor,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: kBottomNavigationBarHeight + additionalBottomPadding),
          child: Material(
            // Splashes.
            type: MaterialType.transparency,
            child: Padding(
              padding: EdgeInsets.only(bottom: additionalBottomPadding),
              child: MediaQuery.removePadding(
                context: context,
                removeBottom: true,
                child: _createContainer(_createChilds(_maxTitleWidth)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _createContainer(List<Widget> childs) {
    return DefaultTextStyle.merge(
      overflow: TextOverflow.ellipsis,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: childs,
      ),
    );
  }

  List<Widget> _createChilds(double _maxTitleWidth) {
    _TXBottomNaviBarState state = this;
    List<Widget> childs = [];
    widget.items.asMap().forEach((index, item) {
      childs.add(Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: item.create(index, widget.tabChange, state, _maxTitleWidth),
      ));
    });
//    childs.add(Container(
//      color: Colors.black,
//      height: kBottomNavigationBarHeight,
//      width: 5,
//    ));
    return childs;
  }

  void changeIndex(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      widget.tabChange(index, true);
      setState(() {
        _isAnimationFlag = true;
      });
    } else {
      widget.tabChange(index, false);
    }
  }
}

class BottomNaviItem {
  final String title;
  final String icon;
  final Color backgroudColor;

  BottomNaviItem({
    @required this.title,
    @required this.icon,
    @required this.backgroudColor,
  }) : super();

  _BottomNaviItem create(int index, TabChange tabChange,
          _TXBottomNaviBarState parentState, double _maxTitleWidth) =>
      _BottomNaviItem(
        title: this.title,
        icon: this.icon,
        backgroudColor: this.backgroudColor,
        index: index,
        tabChange: tabChange,
        parentState: parentState,
        maxTitleWidth: _maxTitleWidth,
      );
}

/// 底部tab栏包裹的Item
class _BottomNaviItem extends StatefulWidget {
  final String title;
  final String icon;
  final Color backgroudColor;
  final int index;
  final TabChange tabChange;
  final _TXBottomNaviBarState parentState;
  final double maxTitleWidth;

  _BottomNaviItem({
    Key key,
    @required this.title,
    @required this.icon,
    @required this.backgroudColor,
    @required this.index,
    @required this.tabChange,
    @required this.parentState,
    @required this.maxTitleWidth,
  })  : assert(title != null),
        assert(icon != null),
        assert(backgroudColor != null),
        assert(index >= 0),
        assert(tabChange != null),
        assert(parentState != null),
        assert(maxTitleWidth > 0),
        super(key: key);

  @override
  _BottomNaviItemState createState() => _BottomNaviItemState();
}

class _BottomNaviItemState extends State<_BottomNaviItem>
    with
        AutomaticKeepAliveClientMixin<_BottomNaviItem>,
        TickerProviderStateMixin<_BottomNaviItem> {
  bool _isOpen = false;

  bool get isOpen => _isOpen;

  set isOpen(bool isOpen) {}

  AnimationController _animationController;

  Animation<Color> _iconColorAnimation;

  Animation<Color> _backgroudColorAnimation;

  Tween<double> _widthTween;
  Animation<double> _widthAnimation;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final _mainColor = widget.backgroudColor;
    _isOpen = (widget.index == 0);
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _iconColorAnimation = ColorTween(begin: Colors.black87, end: _mainColor)
        .animate(_animationController);

    _backgroudColorAnimation =
        ColorTween(begin: Colors.transparent, end: _mainColor.withOpacity(0.15))
            .animate(_animationController);

    _widthTween = Tween(begin: 0.0, end: 1.0);
    _widthAnimation = _widthTween.animate(_animationController);
    _animationController.addListener(() {
      setState(() {});
    });
    _animationController.addStatusListener((status) {
//      print("status:$status--controller:$_animationController");
      if (status == AnimationStatus.completed) {
        _isOpen = true;
        widget.parentState.isAnimation = false;
      } else if (status == AnimationStatus.dismissed) {
        _isOpen = false;
        widget.parentState.isAnimation = false;
      }
    });
    _isOpen = widget.index == widget.parentState.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    _animationIndex(widget.parentState.selectedIndex);
    Widget child = Container(
      width: widget.parentState.isAnimation
          ? _widthAnimation.value * (widget.maxTitleWidth + 6) + 56.0
          : (isOpen ? (widget.maxTitleWidth + 6) + 56.0 : 56.0),
      child: Stack(
        children: <Widget>[
          Material(
            borderRadius: BorderRadius.circular(20),
            color: widget.parentState.isAnimation
                ? _backgroudColorAnimation.value
                : (isOpen
                    ? widget.backgroudColor.withOpacity(0.15)
                    : Colors.white),
            child: Container(
              width: widget.parentState.isAnimation
                  ? _widthAnimation.value * (widget.maxTitleWidth + 6) + 56.0
                  : (isOpen ? (widget.maxTitleWidth + 6) + 56.0 : 56.0),
              height: 40,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(16.0, 10, 0, 10),
            child: Image.asset(
              widget.icon,
              width: 20,
              height: 20,
              color: widget.parentState.isAnimation
                  ? _iconColorAnimation.value
                  : (isOpen ? widget.backgroudColor : Colors.black87),
            ),
          ),
          Opacity(
            opacity: widget.parentState.isAnimation
                ? _widthAnimation.value
                : (isOpen ? 1.0 : 0.0),
            child: Container(
              width: widget.maxTitleWidth,
              margin: EdgeInsets.fromLTRB(18.0 + 20.0 + 6.0, 12, 0, 0),
              child: Text(
                widget.title,
                maxLines: 1,
                style: TextStyle(
                    color: _iconColorAnimation.value, fontSize: kTitleFontSize),
              ),
            ),
          )
        ],
      ),
    );

    return InkResponse(
      splashColor: widget.backgroudColor.withOpacity(0.15),
      radius: 28,
      enableFeedback: false,
      excludeFromSemantics: false,
      highlightShape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(20),
      onTap: _click,
      child: child,
    );
  }

  _click() {
    if (_isOpen) {
      widget.tabChange(widget.index, false);
      return;
    }
    widget.parentState.changeIndex(widget.index);
  }

  _animationIndex(int index) {
//    print("index:${widget.index}");
    bool needOpen = index == widget.index;
//    if(needOpen == isOpen){
//      return;
//    }
    //  执行动画
    if (needOpen == true) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }
}
