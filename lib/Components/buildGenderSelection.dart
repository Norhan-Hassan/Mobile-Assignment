import 'package:flutter/material.dart';

Widget buildGenderSelection({
  required List<String> genders,
  required String? selectedGender,
  required void Function(String?)? onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Gender',
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      SizedBox(height: 10),
      Row(
        children: genders.map((gender) {
          return Row(
            children: [
              Radio<String>(
                value: gender,
                groupValue: selectedGender,
                onChanged: onChanged,
                activeColor: Colors.teal,
              ),
              Text(
                gender,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              SizedBox(width: 50),
            ],
          );
        }).toList(),
      ),
    ],
  );
}
