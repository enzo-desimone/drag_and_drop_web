/// Represents the status of a drag-and-drop operation.
enum DragAndDropStatus {
  /// Initial state or when nothing is being dragged.
  drop,

  /// A drag operation has started.
  dragStart,

  /// A drag operation has completed successfully.
  dragDone,

  /// The dragged item has left the drop area.
  dragLeave,
}
