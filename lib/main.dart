import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Rotas da aplicação
import 'package:sorteio_oficial/config/routes/app_routes.dart';

// Banco de dados e DAO
import 'package:sorteio_oficial/core/database/app_database.dart';
import 'package:sorteio_oficial/core/database/dao/customer_dao.dart';
import 'package:sorteio_oficial/features/register/data/repository/customer_registration.dart';

// Cubits e Serviços
import 'package:sorteio_oficial/features/register/presentation/cubit/register_cubit.dart';

import 'package:sorteio_oficial/features/events/presentation/cubit/event_cubit.dart';
import 'package:sorteio_oficial/features/events/data/repository/event_repository.dart';
import 'package:sorteio_oficial/features/validator/presentation/cubit/validator_cubit.dart';
import 'package:sorteio_oficial/features/validator/data/repositories/whitelabel_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o banco de dados Floor
  final database = await $FloorAppDatabase
      .databaseBuilder('Customer_database.db')
      .build();

  // Recupera o DAO para clientes
  final customerDao = database.customerDao;

  // Executa o app, passando o DAO
  runApp(MyApp(customerDao: customerDao));
}

class MyApp extends StatelessWidget {
  final CustomerDao customerDao;

  const MyApp({super.key, required this.customerDao});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Cubit para validação de whitelabel
        BlocProvider(create: (_) => ValidatorCubit(WhitelabelRepository())),

        // Cubit para listar eventos da API
        BlocProvider(create: (_) => EventCubit(RemoteEventService())),

        // Cubit de cadastro, com DAO local + serviço remoto de clientes
        BlocProvider(
          create: (_) => RegisterCubit(
            customerDao: customerDao,
            remoteService: RemoteCustomerService(), // CORRETO AQUI
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRoutes.generateRoute,
        initialRoute: AppRoutes.validator,
      ),
    );
  }
}
