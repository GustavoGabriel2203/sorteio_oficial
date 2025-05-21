import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Adicionado
import 'package:sorteio_oficial/config/routes/app_routes.dart';
import 'package:sorteio_oficial/features/menu/presentation/widgets/menubuttom.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Menu',
                style: TextStyle(
                  fontSize: 80.sp,
                  fontFamily: 'Bebas',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),

              // Botão 1
              MenuButton(
                label: 'Cadastrar Participantes',
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.register);
                },
              ),

              // Botão 2
              MenuButton(
                label: 'Lista de Participantes',
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.participants);
                },
              ),

              // Botão 3
              MenuButton(
                label: 'Realizar Sorteio',
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.rafflepage);
                },
              ),

              // Botão 4
              MenuButton(
                label: 'Sair',
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.validator);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
