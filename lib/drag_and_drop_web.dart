import 'package:universal_html/js_util.dart' as js_util;
import 'package:universal_html/js.dart' as js;
import 'package:universal_html/html.dart' as html;
import 'package:flutter/material.dart';
import 'drag_and_drop_status.dart';
export 'drag_and_drop_status.dart';

/// A widget that enables drag-and-drop upload functionality with directory support.
///
/// This widget provides different states (e.g., drag start, drag done)
/// and handles browser compatibility to support directory uploads
/// where possible.
class DragAndDropWeb extends StatelessWidget {
  const DragAndDropWeb({
    super.key,
    required this.child,
    required this.notCompatibleWidget,
    required this.onDragWidget,
    required this.onDragDone,
    required this.onUploadFile,
  });

  /// The widget to display if the browser does not support directory drag-and-drop.
  final Widget notCompatibleWidget;

  /// The default child widget to display when no drag operation is in progress.
  final Widget child;

  /// The widget to display when a drag operation has started.
  final Widget onDragWidget;

  /// The widget to display when a drag-and-drop operation is completed.
  final Widget onDragDone;

  /// Callback function to handle the uploaded file.
  final Future<void> Function(html.File file) onUploadFile;

  @override
  Widget build(BuildContext context) {
    final onDragged = ValueNotifier<DragAndDropStatus>(DragAndDropStatus.drop);

    if (isCompatible) {
      _initializeJSInterop(onDragged);
      return ValueListenableBuilder<DragAndDropStatus>(
        valueListenable: onDragged,
        builder: (context, status, _) {
          switch (status) {
            case DragAndDropStatus.dragStart:
              return onDragWidget;
            case DragAndDropStatus.dragDone:
              return onDragDone;
            default:
              return child;
          }
        },
      );
    }

    return notCompatibleWidget;
  }

  /// Detects the current browser name based on the user agent string.
  String get browserName {
    final userAgent = html.window.navigator.userAgent.toLowerCase();
    if (userAgent.contains('chrome') && !userAgent.contains('edg')) return 'Chrome';
    if (userAgent.contains('edg')) return 'Edge';
    if (userAgent.contains('firefox')) return 'Firefox';
    if (userAgent.contains('safari') && !userAgent.contains('chrome')) return 'Safari';
    if (userAgent.contains('opera') || userAgent.contains('opr')) return 'Opera';
    return 'Unknown';
  }

  /// Checks if the current browser supports drag-and-drop directory uploads.
  bool get isCompatible {
    final testElement = html.document.createElement('div');
    return js_util.hasProperty(testElement, 'webkitGetAsEntry');
  }

  /// Initializes JavaScript event listeners for drag-and-drop functionality.
  ///
  /// This method listens for `drop`, `dragover`, and `dragleave` events
  /// to handle the drag-and-drop operations.
  void _initializeJSInterop(ValueNotifier<DragAndDropStatus> onDragged) {
    html.document.body!.addEventListener('drop', (event) {
      event.preventDefault();
      event.stopPropagation();

      final dataTransfer = (event as html.MouseEvent).dataTransfer;
      _handleFiles(dataTransfer);

      onDragged.value = DragAndDropStatus.dragDone;
    });

    html.document.body!.addEventListener('dragover', (event) {
      event.preventDefault();
      event.stopPropagation();
      onDragged.value = DragAndDropStatus.dragStart;
    });

    html.document.body!.addEventListener('dragleave', (event) {
      onDragged.value = DragAndDropStatus.dragLeave;
    });
  }

  /// Handles the dropped files and directories.
  ///
  /// This method processes each item in the `DataTransfer` object, determining
  /// if it is a file or a directory and handling it accordingly.
  void _handleFiles(html.DataTransfer dataTransfer) {
    final items = List.generate(
      dataTransfer.items?.length ?? 0,
          (i) => dataTransfer.items![i],
    );

    for (final item in items) {
      final entry = js_util.callMethod(item, 'webkitGetAsEntry', []);
      if (entry != null) {
        final isDirectory = js_util.getProperty(entry, 'isDirectory') as bool;
        if (isDirectory) {
          _readDirectory(entry);
        } else {
          js_util.callMethod(entry, 'file', [
            js.allowInterop((file) => _uploadFile(file as html.File)),
          ]);
        }
      }
    }
  }

  /// Recursively reads the content of a directory.
  ///
  /// This method processes each file or subdirectory in the given directory entry.
  void _readDirectory(dynamic entry) {
    final reader = js_util.callMethod(entry, 'createReader', []);

    js_util.callMethod(reader, 'readEntries', [
      js.allowInterop((entries) {
        for (final subEntry in List<dynamic>.from(entries)) {
          final isFile = js_util.getProperty(subEntry, 'isFile') as bool;
          if (isFile) {
            js_util.callMethod(subEntry, 'file', [
              js.allowInterop((file) => _uploadFile(file as html.File)),
            ]);
          } else {
            _readDirectory(subEntry);
          }
        }
      }),
    ]);
  }

  /// Uploads a single file using the provided callback.
  ///
  /// This method calls the `onUploadFile` function to process the uploaded file.
  Future<void> _uploadFile(html.File file) async {
    await onUploadFile(file);
  }
}

