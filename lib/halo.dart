import 'package:args/command_runner.dart';

import 'src/commands/list.dart';
import 'src/commands/pubspec.dart';
import 'src/commands/update.dart';

final CommandRunner haloCommandRunner = new CommandRunner('halo',
    'A heavenly way to ensure that all your projects conform to Dart 2.')
  ..addCommand(PubspecCommand())
  ..addCommand(UpdateCommand())
  ..addCommand(ListCommand());
