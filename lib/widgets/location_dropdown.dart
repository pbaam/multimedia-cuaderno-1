import 'package:flutter/material.dart';
import 'package:cuaderno1/l10n/app_localizations.dart';

class LocationDropdown extends StatefulWidget {
  final String labelText;
  final String? initialValue;
  final ValueChanged<String> onChanged;

  const LocationDropdown({
    super.key,
    required this.labelText,
    required this.onChanged,
    this.initialValue,
  });

  @override
  State<LocationDropdown> createState() => _LocationDropdownState();
}

class _LocationDropdownState extends State<LocationDropdown> {
  static const List<String> _places = [
    'Barcelona',
    'Madrid',
    'Zaragoza',
    'Valencia',
  ];

  String? _selectedPlace;

  @override
  void initState() {
    super.initState();
    // Only set _selectedPlace if the initialValue exists in _places
    if (widget.initialValue != null && _places.contains(widget.initialValue)) {
      _selectedPlace = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedPlace,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: const OutlineInputBorder(),
      ),
      items: _places.map((String place) {
        return DropdownMenuItem<String>(
          value: place,
          child: Text(place),
        );
      }).toList(),
      onChanged: (String? value) {
        if (value != null) {
          setState(() {
            _selectedPlace = value;
          });
          widget.onChanged(value);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          final l10n = AppLocalizations.of(context)!;
          return l10n.mustEnterBirthPlace;
        }
        return null;
      },
    );
  }
}
