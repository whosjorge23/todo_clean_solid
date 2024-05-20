import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_clean_solid/models/todo.dart';

class IsarService {
  late Isar isar;

  Future<Isar> getIsar() async {
    isar = await Isar.open(
      [TodoSchema],
      directory: (await getApplicationSupportDirectory()).path,
    );
    return isar;
  }
}
