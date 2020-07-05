
class User {
  String _email;
  String _name;
  String _password;
  String _role;

  User(this._email, this._password, this._name, this._role);

  get email => _email;
  get password => _password;
  get name => _name;
  get role => _role;

  set email(String email) {
    this._email = email;
  }

  set password(String password) {
    this._password = password;
  }

  set role(String role) {
    this._role = role;
  }

  set name(String name) {
    this._name = name;
  }
}