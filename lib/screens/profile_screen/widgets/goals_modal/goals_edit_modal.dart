import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import '../../../../models/user_profile.dart';
import '../../../../widgets/app_notification.dart';
import '../../../../blocs/profile/profile_bloc.dart';
import '../../../../blocs/profile/profile_event.dart';
import '../../../../blocs/profile/profile_state.dart';

class GoalsEditModal extends StatefulWidget {
  final UserProfile profile;
  final BuildContext parentContext;

  const GoalsEditModal({
    super.key,
    required this.profile,
    required this.parentContext,
  });

  @override
  State<GoalsEditModal> createState() => _GoalsEditModalState();
}

class _GoalsEditModalState extends State<GoalsEditModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _weightLossController;
  late TextEditingController _muscleGainController;

  @override
  void initState() {
    super.initState();
    _weightLossController = TextEditingController(
      text: widget.profile.weightLossGoal?.toStringAsFixed(1) ?? '',
    );
    _muscleGainController = TextEditingController(
      text: widget.profile.muscleGainGoal?.toStringAsFixed(1) ?? '',
    );
  }

  @override
  void dispose() {
    _weightLossController.dispose();
    _muscleGainController.dispose();
    super.dispose();
  }

  void _saveGoals() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final bloc = widget.parentContext.read<ProfileBloc>();

      final updateEvent = UpdateGoals(
        weightLoss: _weightLossController.text.isNotEmpty
            ? double.parse(_weightLossController.text)
            : null,
        muscleGain: _muscleGainController.text.isNotEmpty
            ? double.parse(_muscleGainController.text)
            : null,
      );

      bloc.add(updateEvent);
    } catch (e) {
      AppNotification.showError(
          context, 'Erreur lors de la sauvegarde des objectifs.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      bloc: widget.parentContext.read<ProfileBloc>(),
      listener: (context, state) {
        if (state is GoalsUpdateSuccess) {
          AppNotification.showSuccess(context, state.message);
          Navigator.pop(context);
        } else if (state is GoalsUpdateError) {
          AppNotification.showError(context, state.message);
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        bloc: widget.parentContext.read<ProfileBloc>(),
        builder: (context, state) {
          final isLoading = state is GoalsUpdating;

          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Header
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mes objectifs',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          Text(
                            'Définissez vos objectifs personnels',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed:
                            isLoading ? null : () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                // Formulaire
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        // Info card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.green.shade200,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.green.shade700,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Laissez vide si vous n\'avez pas d\'objectif spécifique',
                                  style: TextStyle(
                                    color: Colors.green.shade700,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Perte de poids
                        TextFormField(
                          controller: _weightLossController,
                          enabled: !isLoading,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,1}')),
                          ],
                          decoration: InputDecoration(
                            labelText: 'Perte de poids (kg)',
                            helperText: 'Ex: 5.0 pour perdre 5 kg',
                            prefixIcon: Icon(
                              Icons.trending_down,
                              color: Colors.green.shade600,
                            ),
                            suffixText: 'kg',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final val = double.tryParse(value);
                              if (val == null || val <= 0) {
                                return 'Veuillez entrer un nombre positif';
                              }
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Prise de muscle
                        TextFormField(
                          controller: _muscleGainController,
                          enabled: !isLoading,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,1}')),
                          ],
                          decoration: InputDecoration(
                            labelText: 'Prise de muscle (kg)',
                            helperText: 'Ex: 3.0 pour prendre 3 kg de muscle',
                            prefixIcon: Icon(
                              Icons.fitness_center,
                              color: Colors.green.shade600,
                            ),
                            suffixText: 'kg',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final val = double.tryParse(value);
                              if (val == null || val <= 0) {
                                return 'Veuillez entrer un nombre positif';
                              }
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 32),

                        // Boutons d'action
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: isLoading
                                    ? null
                                    : () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  side: BorderSide(color: Colors.grey.shade300),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Annuler'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: isLoading ? null : _saveGoals,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade600,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text('Enregistrer'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
