//**************************************************************
// Notes view model
// Author:
//**************************************************************
import 'package:stacked/stacked.dart';
import 'package:memory_enhancer_app/file_operations.dart';

FileOperations fileOperations = FileOperations();
String _text = '';

Future notes() async {
  _text = await fileOperations.readNotes();
  return _text;
}

class NotesViewModel extends BaseViewModel {
  void initialize() {}

  @override
  void dispose() {
    super.dispose();
  }
}
