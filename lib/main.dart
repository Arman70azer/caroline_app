import 'package:application_nutrition/blocs/profile/profile_event.dart';
import 'package:application_nutrition/blocs/programs/programs_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/scan/scan_bloc.dart';
import 'blocs/profile/profile_bloc.dart';
import 'blocs/programs/programs_bloc.dart';
import 'screens/main_screen.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const MyApp(),
      defaultDevice: Devices
          .android.samsungGalaxyS25, // ici tu choisis ton device par défaut
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriSport',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ScanBloc()),
          BlocProvider(create: (_) => ProfileBloc()..add(LoadProfile())),
          BlocProvider(create: (_) => ProgramsBloc()..add(LoadPrograms())),
        ],
        child: const MainScreen(),
      ),
    );
  }
}
