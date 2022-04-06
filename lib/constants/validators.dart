import 'package:form_field_validator/form_field_validator.dart';

final nameValidator = MultiValidator([
  RequiredValidator(errorText: "This Field is Required*"),
  MinLengthValidator(3, errorText: 'Name must be 3 letters long'),
]);

final emailValidator = MultiValidator([
  RequiredValidator(errorText: "This field is Required*"),
  EmailValidator(errorText: "Please Enter a Valid Email")
]);

final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'Password is Required*'),
  MinLengthValidator(8, errorText: 'Password must be at least 8 digits long'),
  MaxLengthValidator(16,
      errorText: 'Password must not be greater then 16 letters long'),
  PatternValidator(r'(?=.*?[#?!@$%^&*-])',
      errorText: 'Passwords must have at least one special character')
]);

final fieldValidator = MultiValidator([
  RequiredValidator(errorText: "This Field is Required*"),
]);
