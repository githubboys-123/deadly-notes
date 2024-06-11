import 'package:flutter/material.dart';

void main() {
  runApp(DeadlyNotesApp());
}

class DeadlyNotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Deadly Notes',  // Updated title
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FoldersPage(),
    );
  }
}

class FoldersPage extends StatefulWidget {
  @override
  _FoldersPageState createState() => _FoldersPageState();
}

class _FoldersPageState extends State<FoldersPage> {
  final List<Map<String, dynamic>> _folders = [];
  final List<Map<String, dynamic>> _recycleBin = [];
  final TextEditingController _textEditingController = TextEditingController();

  void _addFolder() {
    if (_textEditingController.text.isNotEmpty) {
      setState(() {
        _folders.add({
          'name': _textEditingController.text,
          'createdAt': DateTime.now(),
          'type': 'folder',
        });
      });
      _textEditingController.clear();
      Navigator.of(context).pop();
    }
  }

  void _deleteFolder(int index) {
    setState(() {
      _recycleBin.add(_folders[index]);
      _folders.removeAt(index);
    });
  }

  void _restoreFolder(Map<String, dynamic> folder) {
    setState(() {
      _folders.add(folder);
      _recycleBin.remove(folder);
    });
  }

  void _showAddFolderDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Folder'),
          content: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(hintText: 'Enter folder name'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: _addFolder,
            ),
          ],
        );
      },
    );
  }

  void _showRecycleBin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecycleBinPage(
          recycleBin: _recycleBin,
          restoreFolder: _restoreFolder,
          permanentlyDelete: _permanentlyDelete,
        ),
      ),
    );
  }

  void _permanentlyDelete(Map<String, dynamic> item) {
    setState(() {
      _recycleBin.remove(item);
    });
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Folders'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: _showRecycleBin,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _folders.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_folders[index]['name']),
            subtitle: Text('Created at: ${_formatDate(_folders[index]['createdAt'])}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotesPage(folderName: _folders[index]['name']),
                ),
              );
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteFolder(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFolderDialog,
        child: Icon(Icons.create_new_folder),
      ),
    );
  }
}

class NotesPage extends StatefulWidget {
  final String folderName;

  NotesPage({required this.folderName});

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final List<Map<String, dynamic>> _notes = [];
  final List<Map<String, dynamic>> _recycleBin = [];
  final TextEditingController _textEditingController = TextEditingController();

  void _addNote() {
    if (_textEditingController.text.isNotEmpty) {
      setState(() {
        _notes.add({
          'content': _textEditingController.text,
          'createdAt': DateTime.now(),
          'type': 'note',
        });
      });
      _textEditingController.clear();
      Navigator.of(context).pop();
    }
  }

  void _deleteNote(int index) {
    setState(() {
      _recycleBin.add(_notes[index]);
      _notes.removeAt(index);
    });
  }

  void _restoreNote(Map<String, dynamic> note) {
    setState(() {
      _notes.add(note);
      _recycleBin.remove(note);
    });
  }

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Note'),
          content: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(hintText: 'Enter your note'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: _addNote,
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes in ${widget.folderName}'),
      ),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_notes[index]['content']),
            subtitle: Text('Created at: ${_formatDate(_notes[index]['createdAt'])}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteNote(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}

class RecycleBinPage extends StatelessWidget {
  final List<Map<String, dynamic>> recycleBin;
  final Function(Map<String, dynamic>) restoreFolder;
  final Function(Map<String, dynamic>) permanentlyDelete;

  RecycleBinPage({
    required this.recycleBin,
    required this.restoreFolder,
    required this.permanentlyDelete,
  });

  String _formatDate(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recycle Bin'),
      ),
      body: ListView.builder(
        itemCount: recycleBin.length,
        itemBuilder: (context, index) {
          var item = recycleBin[index];
          return ListTile(
            title: Text(item['name'] ?? item['content']),
            subtitle: Text('Deleted at: ${_formatDate(item['createdAt'])}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.restore),
                  onPressed: () {
                    if (item['type'] == 'folder') {
                      restoreFolder(item);
                    } else if (item['type'] == 'note') {
                      // Define restoreNote function if needed
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete_forever),
                  onPressed: () => permanentlyDelete(item),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
