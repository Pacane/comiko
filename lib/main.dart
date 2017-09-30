import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:comiko/app_state.dart';
import 'package:comiko/pages/comedian_page.dart';
import 'package:comiko/pages/event_list_page.dart';
import 'package:comiko/pages/event_page.dart';
import 'package:comiko/pages/upcoming_events_page.dart';
import 'package:comiko/widgets/filter_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:comiko/services.dart';
import 'package:comiko/models.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  static final Store<AppState> store = new Store(
    combineReducers([reducer as Reducer]),
    initialState: new AppState.initial(),
  );

  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
      store: store,
      child: new MaterialApp(
        title: 'Comiko',
        theme: new ThemeData.dark(),
        home: new MyHomePage(title: 'Flutter Demo Home Page', store: store),
        routes: <String, WidgetBuilder>{
          '/event_list': (BuildContext context) => new EventListPage(),
          '/event': (BuildContext context) => new EventPage(),
          '/comedian': (BuildContext context) => new ComedianPage(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Store<AppState> store;
  final String title;

  MyHomePage({
    Key key,
    this.title,
    @required this.store,
  })
      : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState(store: store);
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  List<NavigationIconView> _navigationViews;
  final Store<AppState> store;

  _MyHomePageState({
    @required this.store,
  });

  @override
  void initState() {
    super.initState();
    _navigationViews = <NavigationIconView>[
      new NavigationIconView(
        icon: const Icon(Icons.access_alarm),
        body: new Text("1"),
        title: const Text('Alarm'),
        color: Colors.deepPurple,
        vsync: this,
      ),
      new NavigationIconView(
        icon: new Icon(Icons.card_travel),
        body: new Text("2"),
        title: const Text('Box'),
        color: Colors.deepOrange,
        vsync: this,
      ),
      new NavigationIconView(
        icon: const Icon(Icons.cloud),
        body: new UpcomingEventsPage(store: store),
        title: const Text('Cloud'),
        color: Colors.teal,
        vsync: this,
      ),
      new NavigationIconView(
        icon: const Icon(Icons.favorite),
        body: new Text("4"),
        title: const Text('Favorites'),
        color: Colors.indigo,
        vsync: this,
      ),
    ];

    for (NavigationIconView view in _navigationViews) {
      view.controller.addListener(_rebuild);
    }

    _navigationViews[_currentIndex].controller.value = 1.0;
  }

  @override
  void dispose() {
    for (NavigationIconView view in _navigationViews) {
      view.controller.dispose();
    }

    super.dispose();
  }

  void _rebuild() {
    setState(() {
      // Rebuild in order to animate views.
    });
  }

  Widget _buildTransitionsStack() {
    final List<FadeTransition> transitions = <FadeTransition>[];

    for (NavigationIconView view in _navigationViews) {
      transitions.add(view.transition(context));
    }

    // We want to have the newly animating (fading in) views on top.
    transitions.sort((FadeTransition a, FadeTransition b) {
      final Animation<double> aAnimation = a.listenable;
      final Animation<double> bAnimation = b.listenable;
      final double aValue = aAnimation.value;
      final double bValue = bAnimation.value;
      return aValue.compareTo(bValue);
    });

    return new Stack(children: transitions);
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar botNavBar = new BottomNavigationBar(
      items: _navigationViews
          .map((NavigationIconView navigationView) => navigationView.item)
          .toList(),
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.shifting,
      onTap: (int index) {
        setState(() {
          _navigationViews[_currentIndex].controller.reverse();
          _currentIndex = index;
          _navigationViews[_currentIndex].controller.forward();
        });
      },
    );

    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Comiko'),
      ),
      body: new Center(child: _buildTransitionsStack()),
      bottomNavigationBar: botNavBar,
    );
  }
}

class NavigationIconView {
  NavigationIconView({
    Widget icon,
    Widget body,
    Widget title,
    Color color,
    TickerProvider vsync,
  })
      : _body = body,
        item = new BottomNavigationBarItem(
          icon: icon,
          title: title,
          backgroundColor: color,
        ),
        controller = new AnimationController(
          duration: kThemeAnimationDuration,
          vsync: vsync,
        ) {
    _animation = new CurvedAnimation(
      parent: controller,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
  }

  final Widget _body;
  final BottomNavigationBarItem item;
  final AnimationController controller;
  CurvedAnimation _animation;

  FadeTransition transition(BuildContext context) {
    return new FadeTransition(
      opacity: _animation,
      child: new SlideTransition(
        position: new FractionalOffsetTween(
          begin: const FractionalOffset(0.0, 0.02),
          // Small offset from the top.
          end: FractionalOffset.topLeft,
        )
            .animate(_animation),
        child: _body,
      ),
    );
  }
}
