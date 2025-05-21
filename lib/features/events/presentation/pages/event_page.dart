import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sorteio_oficial/config/routes/app_routes.dart';
import 'package:sorteio_oficial/features/events/presentation/cubit/event_cubit.dart';
import 'package:sorteio_oficial/features/events/presentation/cubit/event_state.dart';

class EventPage extends StatefulWidget {
  final int eventId;

  const EventPage({super.key, required this.eventId});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  void initState() {
    super.initState();
    context.read<EventCubit>().loadEventById(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        title: Text(
          'Eventos',
          style: TextStyle(color: Colors.white, fontSize: 20.sp),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<EventCubit, EventState>(
        builder: (context, state) {
          if (state is EventLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EventError) {
            return Center(
              child: Text(
                'Erro ao carregar evento\n${state.message}',
                style: TextStyle(color: Colors.red, fontSize: 16.sp),
                textAlign: TextAlign.center,
              ),
            );
          } else if (state is EventSuccess) {
            final event = state.event;

            return Padding(
              padding: EdgeInsets.all(24.w),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                color: const Color(0xFF0F9D58),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 20.h,
                  ),
                  title: Text(
                    event.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(top: 12.h),
                    child: Text(
                      'Toque para continuar para o menu',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                    ),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.menu);
                  },
                ),
              ),
            );
          }

          return const SizedBox(); 
        },
      ),
    );
  }
}
