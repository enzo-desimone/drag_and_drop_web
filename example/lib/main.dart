import 'package:drag_and_drop_web/drag_and_drop_web.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drag and Drop Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DragAndDropExample(),
    );
  }
}

class DragAndDropExample extends StatelessWidget {
  const DragAndDropExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drag and Drop Web Example'),
      ),
      body: Center(
        child: DragAndDropWeb(
          onDragWidget: _buildDragUI(),
          onDragDone: _buildSuccessUI(),
          notCompatibleWidget: _buildNotCompatibleUI(),
          onUploadFile: (file) async {
            print("Uploaded file: ${file.name}");
          },
          child: _buildDefaultUI(),
        ),
      ),
    );
  }

  /// Default UI when no drag operation is in progress.
  Widget _buildDefaultUI() {
    return Container(
      height: 200,
      width: 400,
      color: Colors.grey[200],
      child: const Center(
        child: Text(
          'Drag files or directories here',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }

  /// UI displayed when a drag operation is in progress.
  Widget _buildDragUI() {
    return Container(
      height: 200,
      width: 400,
      color: Colors.blue[100],
      child: const Center(
        child: Text(
          'Drop files or directories!',
          style: TextStyle(fontSize: 18, color: Colors.blue),
        ),
      ),
    );
  }

  /// UI displayed when files have been successfully uploaded.
  Widget _buildSuccessUI() {
    return Container(
      height: 200,
      width: 400,
      color: Colors.green[100],
      child: const Center(
        child: Text(
          'Files uploaded successfully!',
          style: TextStyle(fontSize: 18, color: Colors.green),
        ),
      ),
    );
  }

  /// UI displayed when the browser does not support directory drag-and-drop.
  Widget _buildNotCompatibleUI() {
    return Container(
      height: 200,
      width: 400,
      color: Colors.red[100],
      child: const Center(
        child: Text(
          'Your browser does not support directory drag-and-drop',
          style: TextStyle(fontSize: 18, color: Colors.red),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
