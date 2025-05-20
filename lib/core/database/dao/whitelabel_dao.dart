import 'package:floor/floor.dart';
import 'package:sorteio_oficial/core/entitys/whitelabel_entity.dart';

@dao
abstract class WhitelabelDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertWhitelabel(Whitelabel whitelabel);

  @Query('SELECT * FROM Whitelabels LIMIT 1')
  Future<Whitelabel?> getWhitelabel();

  @Query('DELETE FROM Whitelabels')
  Future<void> clearWhitelabel();
}
