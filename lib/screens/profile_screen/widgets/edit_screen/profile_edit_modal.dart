import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../models/user_profile.dart';
import '../../../../widgets/app_notification.dart';
import '../../../../blocs/profile/profile_bloc.dart';
import '../../../../blocs/profile/profile_event.dart';
import '../../../../blocs/profile/profile_state.dart';
import 'widgets/edit_widgets.dart';
import 'package:flutter/services.dart';

class ProfileEditModal extends StatefulWidget {
  final UserProfile profile;
  final BuildContext parentContext;

  const ProfileEditModal({
    super.key,
    required this.profile,
    required this.parentContext,
  });

  @override
  State<ProfileEditModal> createState() => _ProfileEditModalState();
}

class _ProfileEditModalState extends State<ProfileEditModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late TextEditingController _ageController;
  late TextEditingController _passwordController;

  String? _selectedGender;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _surnameController = TextEditingController(text: widget.profile.surname);
    _weightController = TextEditingController(
        text: widget.profile.weight?.toStringAsFixed(1) ?? '');
    _heightController = TextEditingController(
        text: widget.profile.height?.toStringAsFixed(0) ?? '');
    _ageController =
        TextEditingController(text: widget.profile.age?.toString() ?? '');
    _passwordController = TextEditingController();
    _selectedGender = widget.profile.gender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    print('🔵 _saveProfile appelé');

    if (!_formKey.currentState!.validate()) {
      print('🔴 Validation échouée');
      return;
    }

    print('✅ Validation réussie');

    try {
      final bloc = widget.parentContext.read<ProfileBloc>();
      print('🔵 Bloc récupéré: $bloc');

      final updateEvent = UpdateProfile(
        name: _nameController.text.trim(),
        surname: _surnameController.text.trim(),
        weight: _weightController.text.isNotEmpty
            ? double.parse(_weightController.text)
            : null,
        height: _heightController.text.isNotEmpty
            ? double.parse(_heightController.text)
            : null,
        age: _ageController.text.isNotEmpty
            ? int.parse(_ageController.text)
            : null,
        gender: _selectedGender,
        password: _passwordController.text.isNotEmpty
            ? _passwordController.text
            : null,
      );

      print('🔵 Event créé: ${updateEvent.name} ${updateEvent.surname}');
      bloc.add(updateEvent);
      print('✅ Event ajouté au bloc');
    } catch (e) {
      print('🔴 Erreur lors de l\'ajout de l\'event: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      bloc: widget.parentContext.read<ProfileBloc>(),
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
          AppNotification.showSuccess(context, state.message);
          Navigator.pop(context);
        } else if (state is ProfileUpdateError) {
          AppNotification.showError(context, state.message);
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        bloc: widget.parentContext.read<ProfileBloc>(),
        builder: (context, state) {
          final isLoading = state is ProfileUpdating;

          return Container(
            height: MediaQuery.of(context).size.height * 0.9,
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

                // Header avec bouton fermer
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Modifier mon profil',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
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
                        EditTextField(
                          controller: _nameController,
                          label: 'Prénom',
                          icon: Icons.person,
                          enabled: !isLoading,
                          validator: (v) => v == null || v.isEmpty
                              ? 'Le prénom est requis'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        EditTextField(
                          controller: _surnameController,
                          label: 'Nom de famille',
                          icon: Icons.person_outline,
                          enabled: !isLoading,
                          validator: (v) => v == null || v.isEmpty
                              ? 'Le nom est requis'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        EditTextField(
                          controller: _weightController,
                          label: 'Poids (kg)',
                          icon: Icons.monitor_weight,
                          keyboardType: TextInputType.number,
                          enabled: !isLoading,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,1}'))
                          ],
                        ),
                        const SizedBox(height: 16),
                        EditTextField(
                          controller: _heightController,
                          label: 'Taille (cm)',
                          icon: Icons.height,
                          keyboardType: TextInputType.number,
                          enabled: !isLoading,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                        const SizedBox(height: 16),
                        EditTextField(
                          controller: _ageController,
                          label: 'Âge',
                          icon: Icons.cake,
                          keyboardType: TextInputType.number,
                          enabled: !isLoading,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                        const SizedBox(height: 16),
                        EditGenderDropdown(
                          value: _selectedGender,
                          onChanged: (v) => setState(() => _selectedGender = v),
                        ),
                        const SizedBox(height: 16),
                        EditPasswordField(
                          controller: _passwordController,
                          obscure: _obscurePassword,
                          onToggle: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                        const SizedBox(height: 32),
                        EditActionButtons(
                          isLoading: isLoading,
                          onCancel: () => Navigator.pop(context),
                          onSave: _saveProfile,
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
