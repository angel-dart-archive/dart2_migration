import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:pub_semver/pub_semver.dart';

import 'common.dart';

class PubspecCommand extends HaloCommand {
  @override
  String get name => 'pubspec';

  @override
  String get description =>
      'Ensures that all projects have an SDK constraint that fits Dart 2.';

  @override
  run() async {
    var strictConstraint = VersionConstraint.parse('>=1.8.0 <3.0.0');

    await for (var project in allProjects) {
      try {
        var pubspec = await project.parsePubspec();
        var sdkConstraint = pubspec.environment['sdk'];

        if (sdkConstraint == null || !sdkConstraint.difference(strictConstraint).isEmpty) {} else{
          print('${project.name} ($sdkConstraint) does not satisfy constraint >=1.8.0 <3.0.0.');
          exitCode = 1;
        }

      } on FileSystemException {
        // Ignore failed pubspec
      }
    }
  }
}
