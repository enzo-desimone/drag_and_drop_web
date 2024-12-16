# DragAndDropWeb Plugin

**DragAndDropWeb** is a Flutter widget that enables drag-and-drop file and directory uploads for Flutter Web applications. It provides a user-friendly interface with customizable states and browser compatibility handling.

---

## Features

- **File and Directory Uploads**: Drag and drop individual files or entire directories (browser support required).
- **Dynamic UI States**: Reacts to drag-and-drop events (`dragStart`, `dragDone`, etc.).
- **Browser Compatibility**:
    - Fully compatible with browsers like **Chrome**, **Edge**, and **Opera**.
    - Fallback widget for unsupported browsers like **Firefox** and **Safari**.
- **Customizable Widgets**: Define custom widgets for different drag-and-drop states.

---

## Browser Compatibility

| Browser   | Compatibility | Notes                                           |
|-----------|---------------|-------------------------------------------------|
| Chrome    | ✅            | Fully supported.                               |
| Edge      | ✅            | Fully supported.                               |
| Firefox   | ❌            | Directory uploads not supported.               |
| Safari    | ❌            | Directory uploads not supported.               |
| Opera     | ✅            | Fully supported.                               |

For unsupported browsers, a custom `notCompatibleWidget` can be displayed.

---

## Setup Instructions

### 1. Add to `index.html`

To ensure drag-and-drop works correctly, update your `index.html` file:

1. Open the `web/index.html` file.
2. Add the following attributes and script to enable `webkitGetAsEntry` for drag-and-drop functionality:
   ```html
   <body ondragover="event.preventDefault();" ondrop="event.preventDefault();">
     <script>
       HTMLElement.prototype.webkitGetAsEntry = function () {
         return this.webkitGetAsEntry ? this.webkitGetAsEntry() : null;
       };
     </script>
   </body>
   ```
3. Example:
   ```html
   <!DOCTYPE html>
   <html>
   <head>
     <meta charset="UTF-8">
     <title>Drag and Drop Demo</title>
   </head>
   <body ondragover="event.preventDefault();" ondrop="event.preventDefault();">
     <script>
       HTMLElement.prototype.webkitGetAsEntry = function () {
         return this.webkitGetAsEntry ? this.webkitGetAsEntry() : null;
       };
     </script>
     <script src="main.dart.js" type="application/javascript"></script>
   </body>
   </html>
   ```

---

## Class: DragAndDropWeb

This is the main widget for integrating drag-and-drop functionality.

### Properties

| Property              | Type                                 | Description                                                                                   |
|-----------------------|--------------------------------------|-----------------------------------------------------------------------------------------------|
| `child`               | `Widget`                            | The default widget displayed when no drag operation is in progress.                          |
| `onDragWidget`        | `Widget`                            | The widget displayed when a drag operation starts.                                           |
| `onDragDone`          | `Widget`                            | The widget displayed when a drag operation completes successfully.                           |
| `notCompatibleWidget` | `Widget`                            | The widget displayed if the browser does not support directory drag-and-drop.                |
| `onUploadFile`        | `Future<void> Function(html.File)`   | Callback function to handle each uploaded file.                                              |

---

## Example Project

A fully functional example project demonstrating the use of `DragAndDropWeb` can be found in the [example](./example) directory.

---

## Contribution

Contributions are welcome! If you find a bug or have a feature request, please open an issue or submit a pull request.

---

## License

This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.

