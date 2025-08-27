# DragAndDropWeb

<p align="left">
  <img src="./example/drag_and_drop_web.webp" alt="DragAndDropWeb" width="50%" />
</p>

A Flutter widget to **drag & drop files and directories** for **Flutter Web** apps, with customizable UI states and graceful fallbacks for unsupported browsers.

[![Pub Version](https://img.shields.io/pub/v/drag_and_drop_web?style=flat-square&logo=dart)](https://pub.dev/packages/drag_and_drop_web)
![Pub Likes](https://img.shields.io/pub/likes/drag_and_drop_web)
![Pub Points](https://img.shields.io/pub/points/drag_and_drop_web)
![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)

---

## 📱 Supported Platforms

| Android | iOS | macOS | Web | Linux | Windows |
|:-------:|:---:|:-----:|:---:|:-----:|:-------:|
|   ❌    | ❌   |  ❌   | ✔️   |  ❌   |   ❌    |

> This package is designed for **Flutter Web**. It can be included in multi-platform projects, but drag-and-drop functionality is only available on the Web.

---

## 🔍 Overview

`drag_and_drop_web` provides a simple, extensible API to accept **file** and **directory** drops inside your Flutter Web app. It offers:

- ✅ **File & Directory** drops (directory support depends on the browser)
- ✅ **Customizable UI states** for drag start/over/done
- ✅ **Fallback widget** for browsers without directory support
- ✅ Minimal setup: small `index.html` snippet

---

## ⚙️ Installation

Add the dependency:

```yaml
dependencies:
  drag_and_drop_web: ^latest
```

Then run:

```bash
flutter pub get
```

---

## 🚀 Quick Start

### 1) Import

```dart
import 'package:drag_and_drop_web/drag_and_drop_web.dart';
```

### 2) Minimal usage

```dart
DragAndDropWeb(
  child: Text("Drop files here"),
  onDragWidget: Text("Drop now!"),
  onDragDone: Text("Upload complete"),
  notCompatibleWidget: Text("Your browser is not supported"),
  onUploadFile: (file) async {
    print("Uploaded: ${file.name}");
  },
);
```

---

## 🌐 Browser Compatibility

| Browser   | Compatibility | Notes                           |
|-----------|---------------|---------------------------------|
| Chrome    | ✅            | Full support                    |
| Edge      | ✅            | Full support                    |
| Opera     | ✅            | Full support                    |
| Firefox   | ⚠️            | No directory support            |
| Safari    | ⚠️            | No directory support            |

For unsupported cases, set a custom `notCompatibleWidget` to guide your users.

---

## 🧩 Setup (`web/index.html`)

Add these to your `web/index.html` to ensure drag-and-drop works properly and to enable `webkitGetAsEntry` (for directory entries in supported browsers):

```html
<body ondragover="event.preventDefault();" ondrop="event.preventDefault();">
  <script>
    HTMLElement.prototype.webkitGetAsEntry = function () {
      return this.webkitGetAsEntry ? this.webkitGetAsEntry() : null;
    };
  </script>
  <script src="main.dart.js" type="application/javascript"></script>
</body>
```

---

## 📘 API Reference

### Widget: `DragAndDropWeb`

| Property              | Type                                 | Description                                                                 |
|-----------------------|--------------------------------------|-----------------------------------------------------------------------------|
| `child`               | `Widget`                             | Default widget when no drag operation is in progress.                       |
| `onDragWidget`        | `Widget`                             | Widget displayed when a drag operation starts/hover.                        |
| `onDragDone`          | `Widget`                             | Widget displayed when a drag operation completes.                           |
| `notCompatibleWidget` | `Widget`                             | Widget displayed if the browser lacks directory drag-and-drop support.      |
| `onUploadFile`        | `Future<void> Function(html.File)`   | Callback invoked for each dropped file.                                     |

> The widget manages the drag lifecycle (`dragStart`, `dragOver`, `dragLeave`, `dragDone`) internally and swaps UI based on the current state.

---

## 🔄 Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:drag_and_drop_web/drag_and_drop_web.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drag & Drop Demo',
      home: const DemoPage(),
    );
  }
}

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Drag & Drop (Web)")),
      body: Center(
        child: DragAndDropWeb(
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Text("Drop files or directories here"),
          ),
          onDragWidget: const Padding(
            padding: EdgeInsets.all(16),
            child: Text("Release to upload"),
          ),
          onDragDone: const Padding(
            padding: EdgeInsets.all(16),
            child: Text("Upload complete"),
          ),
          notCompatibleWidget: const Padding(
            padding: EdgeInsets.all(16),
            child: Text("Your browser does not support directory drops"),
          ),
          onUploadFile: (file) async {
            // Handle the file (e.g., read bytes, upload, etc.)
            debugPrint("Received: ${file.name} (${file.size} bytes)");
          },
        ),
      ),
    );
  }
}
```

---

## 💡 Common Use Cases

- 📂 **Bulk uploads** from folders
- 🧩 **Custom dropzones** inside complex UIs
- 🧪 **Drag-state driven UI** (e.g., highlight drop area on hover)
- 🧭 **Cross-browser experience** with graceful degradation

---

## 🤝 Contributing

Issues and pull requests are welcome!  
→ Open an issue • Submit a PR

---

## 📃 License

MIT — See [LICENSE](./LICENSE)
