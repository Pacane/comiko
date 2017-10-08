import 'package:comiko/app_state.dart';
import 'package:comiko/routing_assistant.dart';
import 'package:comiko/widgets/event_card.dart';
import 'package:comiko/widgets/sort_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:comiko_shared/models.dart';

class UpcomingEventsPage extends StatelessWidget {
  final Store<AppState> store;

  UpcomingEventsPage({@required this.store});

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    return new Scaffold(
      appBar: new AppBar(
        leading: new Container(
          margin: new EdgeInsets.all(12.0),
          child: new Image(
            image: const AssetImage('lib/assets/comiko_logo.png'),
            fit: BoxFit.contain,
          ),
        ),
        title: const Text('Spectacles à venir'),
        actions: [
          new SortPopupMenu(store: store),
          new IconButton(
              icon: new Icon(Icons.search),
              onPressed: () => RoutingAssistant.searchPopup(context, store)),
        ],
      ),
      body: new StoreConnector<AppState, List<EventCardViewModel>>(
        converter: (store) => store.state.events
            .map((Event e) => store.state.createViewModel(e))
            .toList(),
        builder: (context, vms) => new GridView.count(
              crossAxisCount: orientation == Orientation.portrait ? 1 : 3,
              padding: const EdgeInsets.all(8.0),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              children: vms
                  .map((EventCardViewModel vm) =>
                      new EventCard(vm, store: store))
                  .toList(),
            ),
      ),
    );
  }
}
