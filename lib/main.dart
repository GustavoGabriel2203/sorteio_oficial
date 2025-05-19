import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorteio_oficial/config/routes/app_routes.dart';
import 'package:sorteio_oficial/core/database/app_database.dart'; 
import 'package:sorteio_oficial/core/database/dao/customer_dao.dart';
import 'package:sorteio_oficial/features/events/data/repository/event_repository.dart';
import 'package:sorteio_oficial/features/register/presentation/cubit/register_cubit.dart';
import 'package:sorteio_oficial/features/validator/data/repositories/whitelabel_repository.dart';
import 'package:sorteio_oficial/features/validator/presentation/cubit/validator_cubit.dart';
import 'package:sorteio_oficial/features/events/presentation/cubit/event_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o banco de dados
  final database = await $FloorAppDatabase
      .databaseBuilder('Customer_database.db')
      .build();

  // Pega o DAO
  final customerDao = database.customerDao;

  // Injeta o DAO no app
  runApp(MyApp(customerDao: customerDao));
}

class MyApp extends StatelessWidget {
  final CustomerDao customerDao;

  const MyApp({super.key, required this.customerDao});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ValidatorCubit(WhitelabelRepository())),
        BlocProvider(create: (_) => EventCubit(RemoteEventService())),
        BlocProvider(create: (_) => RegisterCubit(customerDao)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRoutes.generateRoute,
        initialRoute: AppRoutes.validator,
      ),
    );
  }
}
