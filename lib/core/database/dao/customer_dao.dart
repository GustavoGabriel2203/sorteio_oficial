import 'package:floor/floor.dart';
import 'package:sorteio_oficial/core/entitys/customer_entity.dart';

@dao
abstract class CustomerDao {
  /// Insere ou atualiza um cliente (substitui se o ID já existir)
  @insert
  Future<void> insertCustomer(Customer customer);

  /// Retorna todos os clientes cadastrados
  @Query('SELECT * FROM Customers')
  Future<List<Customer>> getCustomers();

  /// Busca um cliente pelo ID
  @Query('SELECT * FROM Customers WHERE id = :id')
  Future<Customer?> getCustomerById(int id);

  /// Verifica se já existe um cliente com mesmo e-mail no mesmo evento
  @Query('SELECT * FROM Customers WHERE email = :email AND event = :eventId')
  Future<Customer?> validateIfCustomerAlreadyExists(String email, int eventId);

  /// Remove um cliente pelo ID
  @Query('DELETE FROM Customers WHERE id = :id')
  Future<void> deleteCustomer(int id);

  /// Marca um cliente como sorteado (sorted = 1) e define sync = 0
  @Query('UPDATE Customers SET sorted = 1, sync = 0 WHERE id = :id')
  Future<void> updateCustomerSorted(int id);

  /// Reseta todos os clientes para não sorteados
  @Query('UPDATE Customers SET sorted = 0')
  Future<void> resetSortedCustomers();

  /// Remove todos os clientes da tabela
  @Query('DELETE FROM Customers')
  Future<void> clearDatabase();
}
