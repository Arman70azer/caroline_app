import 'package:flutter/material.dart';

class EditGenderDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const EditGenderDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: 'Genre',
        prefixIcon: Icon(Icons.wc, color: Colors.green.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      items: const [
        DropdownMenuItem(value: 'male', child: Text('Homme')),
        DropdownMenuItem(value: 'female', child: Text('Femme')),
        DropdownMenuItem(value: null, child: Text('Non spécifié')),
      ],
      onChanged: onChanged,
    );
  }
}
