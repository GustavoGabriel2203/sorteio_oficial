import 'package:flutter/material.dart';
import 'package:sorteio_oficial/config/routes/app_routes.dart';
import 'package:sorteio_oficial/features/menu/presentation/widgets/menubuttom.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Menu',
                style: TextStyle(
                  fontSize: 80,
                  fontFamily: 'Bebas',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

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
                onPressed: () {},
              ),

              // Botão 3
              MenuButton(
                label: 'Realizar Sorteio',
                onPressed: () {
                  // TODO: Implementar lógica futura
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
