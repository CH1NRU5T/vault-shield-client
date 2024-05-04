import 'package:client/models/password_model.dart';
import 'package:signals/signals.dart';

final passwordSignal = signal<List<Password>>([]);
void addPassword(Password password) {
  passwordSignal.set([...passwordSignal.value, password]);
}
