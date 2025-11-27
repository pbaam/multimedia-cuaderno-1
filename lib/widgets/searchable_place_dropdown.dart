import 'package:cuaderno1/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../models/place.dart';
import '../services/place_repository.dart';

class SearchablePlaceDropdown extends StatefulWidget {
  final String? initialValue;
  final Function(String) onPlaceSelected;
  final String labelText;

  const SearchablePlaceDropdown({
    super.key,
    this.initialValue,
    required this.onPlaceSelected,
    required this.labelText,
  });

  @override
  State<SearchablePlaceDropdown> createState() => _SearchablePlaceDropdownState();
}

class _SearchablePlaceDropdownState extends State<SearchablePlaceDropdown> {
  final PlaceRepository _placeRepository = PlaceRepository();
  final TextEditingController _controller = TextEditingController();
  List<Place> _filteredPlaces = [];
  bool _showDropdown = false;
  String? _selectedPlace;

  @override
  void initState() {
    super.initState();
    _selectedPlace = widget.initialValue;
    _controller.text = widget.initialValue ?? '';
    _filteredPlaces = _placeRepository.getAllPlaces();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredPlaces = _placeRepository.searchPlaces(query);
      _showDropdown = true;
    });
  }

  void _selectPlace(String placeName) {
    setState(() {
      _selectedPlace = placeName;
      _controller.text = placeName;
      _showDropdown = false;
    });
    widget.onPlaceSelected(placeName);
  }

  @override
  Widget build(BuildContext context) {
    final allPlaces = _placeRepository.getAllPlaces();
    final searchText = _controller.text;
    final hasExactMatch = allPlaces.any(
      (place) => place.name.toLowerCase() == searchText.toLowerCase(),
    );
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: widget.labelText,
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.arrow_drop_down),
          ),
          onChanged: _onSearchChanged,
          onTap: () {
            setState(() {
              _showDropdown = true;
              _filteredPlaces = _placeRepository.getAllPlaces();
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Debes seleccionar o introducir un lugar de nacimiento';
            }
            return null;
          },
        ),
        if (_showDropdown)
          Container(
            constraints: BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
            child: Material(
              child: ListView(
                shrinkWrap: true,
                children: [
                  // Show filtered places from repository
                  ..._filteredPlaces.map((place) => ListTile(
                        title: Text(place.name),
                        onTap: () => _selectPlace(place.name),
                      )),
                  // Show "Other: <search text>" if no exact match and user is typing
                  if (searchText.isNotEmpty && !hasExactMatch)
                    ListTile(
                      leading: Icon(Icons.add_location, color: Colors.blue),
                      title: Text(
                        '${l10n.other}: $searchText',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.blue,
                        ),
                      ),
                      onTap: () => _selectPlace(searchText),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
