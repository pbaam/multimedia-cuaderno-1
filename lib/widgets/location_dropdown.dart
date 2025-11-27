import 'package:flutter/material.dart';
import 'package:cuaderno1/l10n/app_localizations.dart';

import '../models/place.dart';
import '../services/place_repository.dart';

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
  final PlaceRepository _repo = PlaceRepository();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();
  List<Place> _filtered = [];
  bool _showPanel = false;
  bool _blockOnChanged = false;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue ?? '';
    _filtered = _repo.getAllPlaces();
    
    _focus.addListener(() {
      if (!_focus.hasFocus) {
        setState(() => _showPanel = false);
      }
    });
  }

  void _onSearchChanged(String query) {
    if (_blockOnChanged) return;
    setState(() {
      _filtered = _repo.searchPlaces(query);
      _showPanel = true;
    });
  }

  void _selectPlace(String placeName) {
    _blockOnChanged = true;
    _controller.text = placeName;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: placeName.length),
    );
    
    setState(() {
      _showPanel = false;
    });
    
    widget.onChanged(placeName);
    _focus.unfocus();
    
    Future.delayed(Duration(milliseconds: 50), () {
      _blockOnChanged = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final input = _controller.text.trim();
    final hasExactMatch = _filtered.any(
      (p) => p.name.toLowerCase() == input.toLowerCase()
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _controller,
          focusNode: _focus,
          decoration: InputDecoration(
            labelText: widget.labelText,
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(Icons.arrow_drop_down),
              onPressed: () {
                if (_showPanel) {
                  setState(() => _showPanel = false);
                } else {
                  setState(() {
                    _showPanel = true;
                    _filtered = _repo.getAllPlaces();
                  });
                  _focus.requestFocus();
                }
              },
            ),
          ),
          onChanged: _onSearchChanged,
          onTap: () {
            setState(() {
              _showPanel = true;
              if (_controller.text.isEmpty) {
                _filtered = _repo.getAllPlaces();
              }
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.mustEnterBirthPlace;
            }
            return null;
          },
        ),
        if (_showPanel)
          Container(
            margin: const EdgeInsets.only(top: 4),
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.white,
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final place in _filtered)
                    ListTile(
                      title: Text(place.name),
                      onTap: () => _selectPlace(place.name),
                      dense: true,
                    ),
                  if (input.isNotEmpty && !hasExactMatch)
                    ListTile(
                      leading: const Icon(
                        Icons.add_location,
                        color: Colors.blue,
                        size: 20,
                      ),
                      title: Text(
                        '${l10n.other}: $input',
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.blue,
                        ),
                      ),
                      onTap: () => _selectPlace(input),
                      dense: true,
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
    _focus.dispose();
    super.dispose();
  }
}
