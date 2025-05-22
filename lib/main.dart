
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Rotas da aplicação
import 'package:sorteio_oficial/config/routes/app_routes.dart';

// Banco de dados e DAOs
import 'package:sorteio_oficial/core/database/app_database.dart';
import 'package:sorteio_oficial/core/database/dao/customer_dao.dart';
import 'package:sorteio_oficial/core/database/dao/whitelabel_dao.dart';

// Repositórios e serviços
import 'package:sorteio_oficial/features/register/data/repository/customer_registration.dart';
import 'package:sorteio_oficial/features/events/data/repository/event_repository.dart';
import 'package:sorteio_oficial/features/validator/data/repositories/whitelabel_repository.dart';
import 'package:sorteio_oficial/features/participants/data/repository/participants_repository.dart';

// Cubits
import 'package:sorteio_oficial/features/register/presentation/cubit/register_cubit.dart';
import 'package:sorteio_oficial/features/events/presentation/cubit/event_cubit.dart';
import 'package:sorteio_oficial/features/validator/presentation/cubit/validator_cubit.dart';
import 'package:sorteio_oficial/features/participants/presentation/cubit/participants_cubit.dart';
import 'package:sorteio_oficial/features/raffle/presentation/cubit/rafle_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o banco de dados Floor
  final database = await $FloorAppDatabase
      .databaseBuilder('Customer_database.db')
      .build();

  // Recupera os DAOs
  final customerDao = database.customerDao;
  final whitelabelDao = database.whitelabelDao;

  // Instância do serviço de participantes com base no DAO
  final participantService = ParticipantService(whitelabelDao);

  runApp(MyApp(
    customerDao: customerDao,
    whitelabelDao: whitelabelDao,
    participantService: participantService,
  ));
}

class MyApp extends StatelessWidget {
  final CustomerDao customerDao;
  final WhitelabelDao whitelabelDao;
  final ParticipantService participantService;

  const MyApp({
    super.key,
    required this.customerDao,
    required this.whitelabelDao,
    required this.participantService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Cubit para validação de whitelabel
        BlocProvider(
          create: (_) => ValidatorCubit(
            WhitelabelRepository(),
            whitelabelDao,
          ),
        ),

        // Cubit para listar eventos da API
        BlocProvider(
          create: (_) => EventCubit(
            RemoteEventService(),
          ),
        ),

        // Cubit de cadastro de cliente
        BlocProvider(
          create: (_) => RegisterCubit(
            customerDao: customerDao,
            remoteService: RemoteCustomerService(),
          ),
        ),

        // Cubit para listar participantes da API
        BlocProvider(
          create: (_) => ParticipantCubit(participantService),
        ),

        // Cubit para lógica de sorteio (usa DAOs e participantCubit)
        BlocProvider(
          create: (context) => RaffleCubit(
            customerDao: customerDao,
            participantCubit: context.read<ParticipantCubit>(),
          ),
        ),
      ],
      child: ScreenUtilInit(
        designSize: Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRoutes.generateRoute,
          initialRoute: AppRoutes.validator,
        ),
      ),
    );
  }
}
