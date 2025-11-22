import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/portion_size.dart';

class PortionSelectorDialog extends StatefulWidget {
  const PortionSelectorDialog({super.key});

  @override
  State<PortionSelectorDialog> createState() => _PortionSelectorDialogState();
}

class _PortionSelectorDialogState extends State<PortionSelectorDialog> {
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
              // Titre
              Row(
                children: [
                  Icon(Icons.restaurant_menu, color: Colors.green.shade600),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Scanner un aliment',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Switch saisie manuelle
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.green.shade600, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Saisie manuelle du produit',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    Switch(
                      value: _useManualEntry,
                      onChanged: (value) {
                        setState(() {
                          _useManualEntry = value;
                          if (!value) {
                            _productNames.clear();
                            _productNameController.clear();
                          }
                        });
                      },
                      activeThumbColor: Colors.green.shade600,
                    ),
                  ],
                ),
              ),

              // Section saisie manuelle
              if (_useManualEntry) ...[
                const SizedBox(height: 20),
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
                        onChanged: (value) => setState(() {}),
                        onSubmitted: (value) => _addProduct(),
                        decoration: InputDecoration(
                          hintText: 'Ex: Pomme Golden',
                          prefixIcon:
                              Icon(Icons.search, color: Colors.green.shade600),
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
              ],

              // Section poids (optionnel)
              if (!_useManualEntry || _productNames.isNotEmpty) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.monitor_weight,
                          color: Colors.blue.shade600, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _useManualEntry
                              ? 'J\'ai pesé mon aliment (optionnel)'
                              : 'J\'ai pesé mon aliment',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      Switch(
                        value: _useWeight,
                        onChanged: (value) {
                          setState(() {
                            _useWeight = value;
                            if (!value) {
                              _weightController.clear();
                            }
                          });
                        },
                        activeThumbColor: Colors.blue.shade600,
                      ),
                    ],
                  ),
                ),
              ],

              // Champ poids
              if (_useWeight) ...[
                const SizedBox(height: 16),
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
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Ex: 150',
                    suffixText: 'g',
                    prefixIcon: Icon(Icons.scale, color: Colors.blue.shade600),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.blue.shade600, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ],

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
                      child: Text(
                        _useManualEntry ? 'Rechercher' : 'Scanner',
                        style: const TextStyle(
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

  bool _isValid() {
    // Si saisie manuelle, au moins un produit doit être ajouté
    if (_useManualEntry) {
      return _productNames.isNotEmpty;
    }

    // Si scan photo, toujours valide (peut scanner directement)
    return true;
  }

  void _onConfirm() {
    final portionInfo = PortionInfo(
      weight: _useWeight && _weightController.text.isNotEmpty
          ? double.parse(_weightController.text)
          : null,
      productName: _useManualEntry &&
              _productNames.isNotEmpty &&
              _productNames.length == 1
          ? _productNames.first
          : null,
      productNames:
          _useManualEntry && _productNames.length > 1 ? _productNames : null,
    );
    Navigator.of(context).pop(portionInfo);
  }
}
