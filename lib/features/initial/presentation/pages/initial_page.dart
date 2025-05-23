import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sorteio_oficial/config/routes/app_routes.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF121212),
        title: Text(
          'Como usar o sorteio',
          style: TextStyle(
            fontFamily: 'Bebas',
            fontSize: 35.sp,
            color: Colors.white
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor:  Color(0xFF121212),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Center(child: Text('Tutorial', style: TextStyle(fontSize: 45, color: Colors.white, ),)),
              SizedBox(height: 32.h),
              const _Item(
                emoji: '1️⃣',
                title: 'Valide o Código',
                description: 'Digite o código fornecido pela software house.',
              ),
              const _Item(
                emoji: '2️⃣',
                title: 'Cadastre os Participantes',
                description: 'Realize os cadastros nos totens disponíveis.',
              ),
              const _Item(
                emoji: '3️⃣',
                title: 'Vá para aba de Sorteio',
                description:
                    'No totem onde será feito o sorteio, abra a tela de sorteio.',
              ),
              const _Item(
                emoji: '4️⃣j',
                title: 'Sincronize os Dados',
                description:
                    'Clique em “Sincronizar” para juntar os cadastros de todos os totens.',
              ),
              const _Item(
                emoji: '5️⃣',
                title: 'Sorteie o Vencedor',
                description: 'Clique em “Sortear” e veja quem ganhou!',
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.validator);
                  },
                  child: Text(
                    'COMEÇAR',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;

  const _Item({
    required this.emoji,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            emoji,
            style: TextStyle(fontSize: 24.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
