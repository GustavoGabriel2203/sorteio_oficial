// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CustomerDao? _customerDaoInstance;

  WhitelabelDao? _whitelabelDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Customers` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `email` TEXT NOT NULL, `phone` TEXT NOT NULL, `sorted` INTEGER NOT NULL, `event` INTEGER NOT NULL, `sync` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Whitelabels` (`id` INTEGER NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CustomerDao get customerDao {
    return _customerDaoInstance ??= _$CustomerDao(database, changeListener);
  }

  @override
  WhitelabelDao get whitelabelDao {
    return _whitelabelDaoInstance ??= _$WhitelabelDao(database, changeListener);
  }
}

class _$CustomerDao extends CustomerDao {
  _$CustomerDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _customerInsertionAdapter = InsertionAdapter(
            database,
            'Customers',
            (Customer item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'email': item.email,
                  'phone': item.phone,
                  'sorted': item.sorted,
                  'event': item.event,
                  'sync': item.sync
                }),
        _customerUpdateAdapter = UpdateAdapter(
            database,
            'Customers',
            ['id'],
            (Customer item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'email': item.email,
                  'phone': item.phone,
                  'sorted': item.sorted,
                  'event': item.event,
                  'sync': item.sync
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Customer> _customerInsertionAdapter;

  final UpdateAdapter<Customer> _customerUpdateAdapter;

  @override
  Future<List<Customer>> getCustomers() async {
    return _queryAdapter.queryList('SELECT * FROM Customers',
        mapper: (Map<String, Object?> row) => Customer(
            id: row['id'] as int?,
            name: row['name'] as String,
            email: row['email'] as String,
            phone: row['phone'] as String,
            sorted: row['sorted'] as int,
            event: row['event'] as int,
            sync: row['sync'] as int));
  }

  @override
  Future<Customer?> getCustomerById(int id) async {
    return _queryAdapter.query('SELECT * FROM Customers WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Customer(
            id: row['id'] as int?,
            name: row['name'] as String,
            email: row['email'] as String,
            phone: row['phone'] as String,
            sorted: row['sorted'] as int,
            event: row['event'] as int,
            sync: row['sync'] as int),
        arguments: [id]);
  }

  @override
  Future<Customer?> validateIfCustomerAlreadyExists(
    String email,
    int eventId,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM Customers WHERE email = ?1 AND event = ?2',
        mapper: (Map<String, Object?> row) => Customer(
            id: row['id'] as int?,
            name: row['name'] as String,
            email: row['email'] as String,
            phone: row['phone'] as String,
            sorted: row['sorted'] as int,
            event: row['event'] as int,
            sync: row['sync'] as int),
        arguments: [email, eventId]);
  }

  @override
  Future<void> deleteCustomer(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM Customers WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> updateCustomerSorted(int id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE Customers SET sorted = 1, sync = 0 WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> resetSortedCustomers() async {
    await _queryAdapter.queryNoReturn('UPDATE Customers SET sorted = 0');
  }

  @override
  Future<void> clearDatabase() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Customers');
  }

  @override
  Future<List<Customer>> getUnsyncedCustomersByEvent(int eventId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Customers WHERE event = ?1 AND sync = 0',
        mapper: (Map<String, Object?> row) => Customer(
            id: row['id'] as int?,
            name: row['name'] as String,
            email: row['email'] as String,
            phone: row['phone'] as String,
            sorted: row['sorted'] as int,
            event: row['event'] as int,
            sync: row['sync'] as int),
        arguments: [eventId]);
  }

  @override
  Future<int> insertCustomer(Customer customer) {
    return _customerInsertionAdapter.insertAndReturnId(
        customer, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateCustomer(Customer customer) async {
    await _customerUpdateAdapter.update(customer, OnConflictStrategy.abort);
  }
}

class _$WhitelabelDao extends WhitelabelDao {
  _$WhitelabelDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _whitelabelInsertionAdapter = InsertionAdapter(database, 'Whitelabels',
            (Whitelabel item) => <String, Object?>{'id': item.id});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Whitelabel> _whitelabelInsertionAdapter;

  @override
  Future<Whitelabel?> getWhitelabel() async {
    return _queryAdapter.query('SELECT * FROM Whitelabels LIMIT 1',
        mapper: (Map<String, Object?> row) => Whitelabel(id: row['id'] as int));
  }

  @override
  Future<void> clearWhitelabel() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Whitelabels');
  }

  @override
  Future<void> insertWhitelabel(Whitelabel whitelabel) async {
    await _whitelabelInsertionAdapter.insert(
        whitelabel, OnConflictStrategy.replace);
  }
}
