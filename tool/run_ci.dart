import 'package:dev_test/package.dart';
import 'package:process_run/shell.dart';

Future main() async {
  await packageRunCi('.', noAnalyze: true);
  await Shell().run('dart analyze --fatal-warnings .');
}
