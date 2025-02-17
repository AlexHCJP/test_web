import 'dart:html' as html;
import 'package:flutter/material.dart';

/// The entry point of the application.
void main() {
  runApp(MyApp());
}

/// A stateless widget that serves as the root of the application.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: MyHomePage(),
      );
}

/// A stateful widget that represents the main page of the application.
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

/// The state for [MyHomePage].
class _MyHomePageState extends State<MyHomePage> {
  /// Controller for the URL input field.
  late final TextEditingController _urlController;

  /// The currently loaded image URL.
  String? imageUrl;

  /// Indicates whether the menu is open.
  bool isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController();
    _registerImageElement();
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  /// Exits fullscreen mode and closes the menu.
  void _exitFull() {
    html.document.exitFullscreen();
    _closeMenu();
  }

  /// Requests fullscreen mode and closes the menu.
  void _requestFullScreen() {
    html.document.documentElement?.requestFullscreen();
    _closeMenu();
  }

  /// Toggles fullscreen mode.
  void _toggleFullscreen() {
    if (html.document.fullscreenElement != null) {
      _exitFull();
    } else {
      _requestFullScreen();
    }
  }

  /// Registers an image element in the DOM.
  void _registerImageElement() =>
      html.document.body!.append(html.ImageElement()..id = 'image-element');

  /// Loads an image from the URL entered in the input field.
  void _loadImage() {
    imageUrl = _urlController.text.isNotEmpty ? _urlController.text : null;

    final imgElement =
        html.document.getElementById('image-element') as html.ImageElement?;

    if (imgElement == null) return;

    if (imageUrl != null) {
      imgElement.src = imageUrl!;
      imgElement.style.display = 'block';
    } else {
      imgElement.style.display = 'none';
    }

    setState(() {});
  }

  /// Closes the menu and updates the UI.
  void _closeMenu() {
    isMenuOpen = false;
    setState(() {});
  }

  /// Opens the menu and updates the UI.
  void _onOpenedPopup() {
    isMenuOpen = true;
    setState(() {});
  }

  /// Handles the menu cancellation by closing it.
  void _onCanceled() => _closeMenu();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: GestureDetector(
                        onDoubleTap: _toggleFullscreen,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const HtmlElementView(viewType: 'image-view'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _urlController,
                          decoration: const InputDecoration(
                              hintText: 'Enter image URL'),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _loadImage,
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                          child: Icon(Icons.arrow_forward),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 64),
                ],
              ),
            ),
            if (isMenuOpen)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withAlpha(50),
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.bottomRight,
                ),
              )
          ],
        ),
        floatingActionButton: PopupMenuButton<int>(
          onOpened: _onOpenedPopup,
          onCanceled: _onCanceled,
          icon: const Icon(Icons.add, color: Colors.black),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              onTap: _requestFullScreen,
              child: const Text('Enter fullscreen'),
            ),
            PopupMenuItem(
              value: 2,
              onTap: _exitFull,
              child: const Text('Exit fullscreen'),
            ),
          ],
        ),
      );
}
