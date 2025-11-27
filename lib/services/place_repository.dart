import '../models/place.dart';

class PlaceRepository {
  static final List<Place> _places = [
    Place(name: 'Madrid'),
    Place(name: 'Zaragoza'),
    Place(name: 'Barcelona'),
    Place(name: 'Valencia'),
  ];

  List<Place> getAllPlaces() => List.unmodifiable(_places);

  List<Place> searchPlaces(String query) {
    if (query.isEmpty) return getAllPlaces();
    
    return _places
        .where((place) => place.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
