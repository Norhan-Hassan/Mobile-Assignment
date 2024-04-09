import 'package:flutter/material.dart';


Widget buildLevelDropdown({
  required List<String> levels,
  required String? selectedLevel,
  required void Function(String?) onChanged,
}) {
  return DropdownButtonFormField<String>(
    value: selectedLevel,
    onChanged: onChanged,
    items: levels.map((level) {
      return DropdownMenuItem<String>(
        value: level,
        child: Text(level),
      );
    }).toList(),
    decoration: InputDecoration(
      labelText: 'Level',
      hintText: 'Select level',
      prefixIcon: Icon(Icons.format_list_numbered),
      border: OutlineInputBorder(),
    ),
  );
}
