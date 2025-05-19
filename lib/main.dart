import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorteio_oficial/config/routes/app_routes.dart';
import 'package:sorteio_oficial/features/events/data/repository/event_repository.dart';
import 'package:sorteio_oficial/features/register/presentation/cubit/register_cubit.dart';
import 'package:sorteio_oficial/features/validator/data/repositories/whitelabel_repository.dart';
import 'package:sorteio_oficial/features/validator/presentation/cubit/validator_cubit.dart';
import 'package:sorteio_oficial/features/events/presentation/cubit/event_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ValidatorCubit(WhitelabelRepository())),
        BlocProvider(create: (_) => EventCubit(RemoteEventService())),
        BlocProvider(create: (_) => RegisterCubit())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRoutes.generateRoute,
        initialRoute: AppRoutes.validator,
      ),
    );
  }
}
