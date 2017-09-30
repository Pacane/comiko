import 'package:comiko/models.dart';

abstract class EventsService {
  List<Event> getAll();
}

class FakeEventsService extends EventsService {
  List<Event> getAll() => [
        new Event(
          name: "Martin Matte",
          address: "Théâtre Palace Arvida",
          start: new DateTime(2017, 11, 15, 20),
          image: "lib/assets/martin-matte1.jpg",
        ),
        new Event(
          name: "Adib Alkhalidey",
          address: "Théâtre Banque Nationale",
          start: new DateTime(2017, 11, 15, 20),
          image: "lib/assets/adib-alkhalidey-1.jpg",
        ),
        new Event(
          name: "Guillaume Wagner",
          address: "Théâtre du Palais Municipal",
          start: new DateTime(2017, 11, 15, 20),
          image: "lib/assets/guillaume-wagner1.jpg",
        ),
        new Event(
          name: "Jean-Marc Parent",
          address: "Côté-Cour",
          start: new DateTime(2017, 11, 15, 20),
          image: "lib/assets/jean-marc-parent-v3.jpg",
        ),
      ];
}