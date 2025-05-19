import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      appBar: AppBar(
        title: const Text('Evento'),
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
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          } else if (state is EventSuccess) {
            final event = state.event;

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: const Color(0xFF0F9D58),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  title: Text(
                    event.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Text(
                      'Toque para continuar para o menu',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.menu);
                  },
                ),
              ),
            );
          }

          return const SizedBox(); // fallback
        },
      ),
    );
  }
}
