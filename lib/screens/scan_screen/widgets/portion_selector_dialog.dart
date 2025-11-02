import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/portion_size.dart';

class PortionSelectorDialog extends StatefulWidget {
  const PortionSelectorDialog({super.key});

  @override
  State<PortionSelectorDialog> createState() => _PortionSelectorDialogState();
}

class _PortionSelectorDialogState extends State<PortionSelectorDialog> {
  PlateSize? _selectedPlateSize;
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  bool _useWeight = false;
  bool _useManualEntry = false;
  final List<String> _productNames = []; // Liste des produits ajoutés

  @override
  void dispose() {
    _weightController.dispose();
    _productNameController.dispose();
    super.dispose();
  }

  void _addProduct() {
    final productName = _productNameController.text.trim();
    if (productName.isNotEmpty && !_productNames.contains(productName)) {
      setState(() {
        _productNames.add(productName);
        _productNameController.clear();
      });
    }
  }

  void _removeProduct(int index) {
    setState(() {
      _productNames.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Quelle est la quantité ?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Switch saisie manuelle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Saisie manuelle du produit',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Switch(
                    value: _useManualEntry,
                    onChanged: (value) {
                      setState(() {
                        _useManualEntry = value;
                      });
                    },
                    activeColor: Colors.green.shade600,
                  ),
                ],
              ),

              // Champ nom du produit
              if (_useManualEntry) ...[
                const SizedBox(height: 16),
                Text(
                  'Nom du produit',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _productNameController,
                        textCapitalization: TextCapitalization.words,
                        onChanged: (value) {
                          setState(() {});
                        },
                        onSubmitted: (value) => _addProduct(),
                        decoration: InputDecoration(
                          hintText: 'Ex: Pomme Golden',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.green.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: Colors.green.shade600, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _productNameController.text.trim().isEmpty
                          ? null
                          : _addProduct,
                      icon: Icon(
                        Icons.add_circle,
                        color: _productNameController.text.trim().isEmpty
                            ? Colors.grey.shade400
                            : Colors.green.shade600,
                        size: 32,
                      ),
                    ),
                  ],
                ),

                // Affichage des tags
                if (_productNames.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _productNames.asMap().entries.map((entry) {
                      final index = entry.key;
                      final name = entry.value;
                      return Chip(
                        label: Text(name),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () => _removeProduct(index),
                        backgroundColor: Colors.green.shade50,
                        deleteIconColor: Colors.green.shade700,
                        labelStyle: TextStyle(
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                        side: BorderSide(color: Colors.green.shade300),
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: 16),
              ],

              const SizedBox(height: 8),

              // Sélecteur assiettes
              if (!_useWeight) ...[
                Text(
                  'Taille de l\'assiette',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 12),
                _buildPlateSizeSelector(),
                const SizedBox(height: 16),
              ],

              // Champ poids
              if (_useWeight) ...[
                Text(
                  'Poids (en grammes)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: 'Ex: 150',
                    suffixText: 'g',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.green.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.green.shade600, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Switch assiette/poids
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _useWeight
                        ? 'Revenir aux assiettes'
                        : 'J\'ai pesé mon aliment',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Switch(
                    value: _useWeight,
                    onChanged: (value) {
                      setState(() {
                        _useWeight = value;
                        if (value) {
                          _selectedPlateSize = null;
                        } else {
                          _weightController.clear();
                        }
                      });
                    },
                    activeColor: Colors.green.shade600,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Boutons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Annuler',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isValid() ? _onConfirm : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor: Colors.grey.shade300,
                      ),
                      child: const Text(
                        'Confirmer',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlateSizeSelector() {
    return Column(
      children: PlateSize.values.map((size) {
        final isSelected = _selectedPlateSize == size;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedPlateSize = size;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: isSelected ? Colors.green.shade50 : Colors.grey.shade50,
                border: Border.all(
                  color:
                      isSelected ? Colors.green.shade600 : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    _getIconForSize(size),
                    color: isSelected
                        ? Colors.green.shade600
                        : Colors.grey.shade600,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      size.label,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? Colors.green.shade800
                            : Colors.grey.shade700,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: Colors.green.shade600,
                      size: 22,
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _getIconForSize(PlateSize size) {
    switch (size) {
      case PlateSize.small:
        return Icons.restaurant;
      case PlateSize.medium:
        return Icons.lunch_dining;
      case PlateSize.large:
        return Icons.dinner_dining;
    }
  }

  bool _isValid() {
    if (_useManualEntry && _productNames.isEmpty) {
      return false;
    }

    if (_useWeight) {
      final text = _weightController.text.trim();
      if (text.isEmpty) return false;
      final weight = int.tryParse(text);
      return weight != null && weight > 0;
    }
    return _selectedPlateSize != null;
  }

  void _onConfirm() {
    final portionInfo = PortionInfo(
      plateSize: _useWeight ? null : _selectedPlateSize,
      weight: _useWeight && _weightController.text.isNotEmpty
          ? double.parse(_weightController.text)
          : null,
      productName: _useManualEntry && _productNames.isNotEmpty
          ? _productNames.join(', ')
          : null,
      productNames: _useManualEntry ? _productNames : null,
    );
    Navigator.of(context).pop(portionInfo);
  }
}
