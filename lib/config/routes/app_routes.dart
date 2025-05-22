import 'package:flutter/material.dart';
import 'package:sorteio_oficial/features/raffle/presentation/pages/raffle_page.dart';
import 'package:sorteio_oficial/features/events/presentation/pages/event_page.dart';
import 'package:sorteio_oficial/features/menu/presentation/pages/menu_page.dart';
import 'package:sorteio_oficial/features/participants/presentation/pages/participants_page.dart';
import 'package:sorteio_oficial/features/register/presentation/pages/register_page.dart';
import 'package:sorteio_oficial/features/validator/presentation/pages/validator_whitelabel_page.dart';

abstract class AppRoutes {
  static const validator = '/validator';
  static const event = '/event';
  static const menu = '/menu';
  static const register = '/register';
  static const participants = '/participants';
  static const rafflepage = '/rafle';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case validator:
        return MaterialPageRoute(builder: (_) => const ValidatorPage());

      case event:
        final eventId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => EventPage(eventId: eventId),
        );

      case menu:
        return MaterialPageRoute(builder: (_) => MenuPage());

      case register:
        return MaterialPageRoute(builder: (_) => RegisterPage());

      case participants:
        return MaterialPageRoute(builder: (_) => ParticipantsPage());

      case rafflepage:
        return MaterialPageRoute(builder: (_) => RafflePage());
     

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Rota não encontrada')),
          ),
        );
    }
  }
}
