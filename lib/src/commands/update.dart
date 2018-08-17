import 'common.dart';

class UpdateCommand extends HaloCommand {
  @override
  String get name => 'update';

  @override
  String get description =>
      'Updates or downloads local copies of all repos specified in projects.txt.';

  @override
  run() async {
    await for (var project in allProjects) {
      if (!await project.directory.exists()) {
        await project.clone();
      } else {
        await project.update();
      }
    }
  }
}
