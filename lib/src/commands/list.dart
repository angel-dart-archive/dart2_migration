import 'package:args/command_runner.dart';
import 'common.dart';

class ListCommand extends HaloCommand {
  String get name => 'list';

  String get description => 'Lists all projects Halo is configured to manage.';

  @override
 run() async {
    await for (var project in allProjects) {
      print('* ${project.name} (${project.directory.absolute.path})');
    }
  }
}