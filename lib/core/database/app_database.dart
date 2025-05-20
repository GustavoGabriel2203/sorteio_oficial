import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

// DAOs
import 'package:sorteio_oficial/core/database/dao/customer_dao.dart';
import 'package:sorteio_oficial/core/database/dao/whitelabel_dao.dart';

// Entities
import 'package:sorteio_oficial/core/entitys/customer_entity.dart';
import 'package:sorteio_oficial/core/entitys/whitelabel_entity.dart';

part 'app_database.g.dart'; // Arquivo gerado automaticamente

@Database(
  version: 2,
  entities: [Customer, Whitelabel],
)
abstract class AppDatabase extends FloorDatabase {
  CustomerDao get customerDao;
  WhitelabelDao get whitelabelDao;
}
