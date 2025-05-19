
import 'package:lucid_validation/lucid_validation.dart';
import 'package:sorteio_oficial/core/lucid_validator/lucid_model.dart';

class UserValidator extends LucidValidator<LucidModel> {

UserValidator(){
    ruleFor((user) => user.name, key: 'name');

    ruleFor((user) => user.phone, key: 'phone')
    .notEmpty(message: 'preencha um telefone')
    .validPhoneBR(message: 'Preencha um telefone valido')
    .minLength(10,message: 'O telefone deve ter ao menos 10 números');



    ruleFor((user) => user.email, key: 'email')
    .notEmpty(message: 'preencha um e-mail')
    .validEmail( message: 'preencha um e-mail valido');

}

}