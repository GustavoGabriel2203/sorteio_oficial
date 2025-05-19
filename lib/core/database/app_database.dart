import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sorteio_oficial/core/entitys/customer_entity.dart';
import 'package:sorteio_oficial/core/database/dao/customer_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart'; // Arquivo gerado automaticamente

@Database(version: 1, entities: [Customer])
abstract class AppDatabase extends FloorDatabase {
  CustomerDao get customerDao;
}
