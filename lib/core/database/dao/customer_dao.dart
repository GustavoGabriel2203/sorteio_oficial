import 'package:floor/floor.dart';
import 'package:sorteio_oficial/core/entitys/customer_entity.dart';

@dao
abstract class CustomerDao {
  @insert
  Future<void> insertCustomer(Customer customer);

  @update
  Future<void> updateCustomer(Customer customer);

  @Query('SELECT * FROM Customers')
  Future<List<Customer>> getCustomers();

  @Query('SELECT * FROM Customers WHERE id = :id')
  Future<Customer?> getCustomerById(int id);

  @Query('SELECT * FROM Customers WHERE email = :email AND event = :eventId')
  Future<Customer?> validateIfCustomerAlreadyExists(String email, int eventId);

  @Query('DELETE FROM Customers WHERE id = :id')
  Future<void> deleteCustomer(int id);

  @Query('UPDATE Customers SET sorted = 1, sync = 0 WHERE id = :id')
  Future<void> updateCustomerSorted(int id);

  @Query('UPDATE Customers SET sorted = 0')
  Future<void> resetSortedCustomers();

  @Query('DELETE FROM Customers')
  Future<void> clearDatabase();

  @Query('SELECT * FROM Customers WHERE event = :eventId AND sync = 0')
  Future<List<Customer>> getUnsyncedCustomersByEvent(int eventId);
}
