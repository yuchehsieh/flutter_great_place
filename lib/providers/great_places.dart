import 'package:flutter/widgets.dart';
import 'package:great_place/models/place.dart';

class GreatPlace with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }
}
