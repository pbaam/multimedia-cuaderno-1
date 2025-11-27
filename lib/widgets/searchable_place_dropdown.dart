import 'package:cuaderno1/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

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
  static const List<String> _places = [
    'Barcelona',
    'Madrid',
    'Zaragoza',
    'Valencia',
  ];

  final TextEditingController _controller = TextEditingController();
  List<String> _filteredPlaces = [];
  bool _showDropdown = false;
  String? _selectedPlace;

  @override
  void initState() {
    super.initState();
    _selectedPlace = widget.initialValue;
    _controller.text = widget.initialValue ?? '';
    _filteredPlaces = _places;
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredPlaces = _places;
      } else {
        _filteredPlaces = _places
            .where((place) => place.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
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
    final searchText = _controller.text;
    final hasExactMatch = _places.any(
      (place) => place.toLowerCase() == searchText.toLowerCase(),
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
              _filteredPlaces = _places;
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
                  ..._filteredPlaces.map((place) => ListTile(
                        title: Text(place),
                        onTap: () => _selectPlace(place),
                      )),
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
