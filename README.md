# application_nutrition

[![Flutter](https://img.shields.io/badge/Flutter-3.35.7-blue?logo=flutter&logoColor=white)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)
[![Build](https://img.shields.io/github/actions/workflow/status/Arman70azer/caroline_app/flutter.yml?branch=main)](https://github.com/Arman70azer/caroline_app/actions)

---

## Description

**NutriSport** est une application mobile Flutter conçue pour aider les utilisateurs à gérer leur nutrition et leur activité physique.  
Elle combine un scanner alimentaire, le suivi du profil utilisateur et la gestion des programmes nutritionnels et sportifs.  

Fonctionnalités principales :  
- **Scanner d’aliments** : analyse rapide des aliments pour obtenir calories et macronutriments.  
- **Profil utilisateur** : suivi des statistiques quotidiennes (calories consommées, eau, exercice) et progression des objectifs.  
- **Programmes nutrition & sport** : affichage et suivi des programmes actifs avec progression et prochains repas/séances.  
- **UI moderne** : design épuré, navigation par onglets et composants interactifs avec Material3 et gradients.

---

## Table des matières

- [Getting Started](#getting-started)
- [Installation](#installation)
- [Architecture du projet](#architecture-du-projet)
- [Organisation du code](#organisation-du-code)
- [Usage](#usage)
- [Contribuer](#contribuer)
- [Licence](#licence)

---

## Getting Started

Ce projet est un point de départ pour une application Flutter modulaire.  

Si c’est votre premier projet Flutter, consultez :  
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)  
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)  
- [Documentation Flutter](https://docs.flutter.dev/)

---

## Installation

1. Cloner le dépôt :  
```bash
git clone https://github.com/ton_utilisateur/ton_repo.git
cd ton_repo
flutter pub get
flutter run
```

## Architecture du projet

L’application suit une architecture modulaire et utilise **Bloc** pour la gestion de l’état.

Modules principaux :  

- **ScanBloc** : gestion du scan alimentaire  
- **ProfileBloc** : gestion du profil utilisateur et statistiques  
- **ProgramsBloc** : gestion des programmes nutritionnels et sportifs  

Chaque écran est découplé et peut être utilisé indépendamment :  

- **ScanScreen**  
- **ProfileScreen**  
- **ProgramsScreen**

## Organisation du code

- **main.dart** : point d’entrée de l’application et configuration de `MultiBlocProvider`.

- **blocs/** : tous les BLoC (`ScanBloc`, `ProfileBloc`, `ProgramsBloc`) ainsi que leurs événements et états.

- **models/** : classes de données (`FoodInfo`, `UserProfile`, `NutritionProgram`).

- **screens/** : écrans principaux (`ScanScreen`, `ProfileScreen`, `ProgramsScreen`).

- **widgets/** : widgets réutilisables (statistiques, cartes de nutriments, barres de progression).

- **utils/** : fonctions utilitaires et constantes (si nécessaire).

## Usage

- Lancer l’application avec `flutter run`.
- Naviguer via le `BottomNavigationBar` pour accéder aux différentes sections.
- Utiliser le bouton **Scanner** pour analyser un aliment et obtenir ses informations nutritionnelles.
- Consulter et suivre vos programmes nutrition et sport depuis l’onglet **Programmes**.
- Mettre à jour votre profil ou rafraîchir les données depuis l’onglet **Profil**.

## License

* Caroline & Arman