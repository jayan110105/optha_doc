import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:opthadoc/Camp/camp.dart';

class CampVerification extends StatefulWidget {
  const CampVerification({super.key});

  @override
  State<CampVerification> createState() => _CampVerificationState();
}

class _CampVerificationState extends State<CampVerification> {
  final List<TextEditingController> _controllers = List.generate(3, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(3, (_) => FocusNode());
  final FocusNode _keyboardFocusNode = FocusNode();

  void handleInput(int index, String value) {
    if (value.length > 1) value = value[0].toUpperCase();
    _controllers[index].text = value;
    _controllers[index].selection = TextSelection.fromPosition(TextPosition(offset: value.length));

    // Move to next input if value is entered
    if (value.isNotEmpty && index < 2) {
      _focusNodes[index + 1].requestFocus();
    }

    // Submit if all fields are filled
    if (_controllers.every((controller) => controller.text.isNotEmpty) && value.isNotEmpty) {
      navigateToCampHome();
    }
  }

  void handleKeyDown(LogicalKeyboardKey key) {
    for (int i = 0; i < _controllers.length; i++) {
      if (key == LogicalKeyboardKey.backspace &&
          _controllers[i].text.isEmpty &&
          i > 0 &&
          _focusNodes[i].hasFocus) {
        _focusNodes[i - 1].requestFocus();
        break;
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  void navigateToCampHome() {
    final campCode = _controllers.map((controller) => controller.text).join();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Camp(campCode: campCode),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E6DB),
      body: Focus(
        focusNode: _keyboardFocusNode,
        autofocus: true,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent) {
            handleKeyDown(event.logicalKey);
          }
          return KeyEventResult.handled;
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.withAlpha(10),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.festival, // Equivalent to "Tent" in React
                    size: 36,
                    color: Color(0xFF163351),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Enter Camp Code",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF163351)),
                ),
                const SizedBox(height: 8),
                Text(
                  "Please enter the three-letter unique code for camp",
                  style: TextStyle(fontSize: 14, color: Color(0xFF163351).withValues(alpha: 0.8)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 50,
                      height: 64,
                      child: TextField(
                        controller: _controllers[index],
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          counterText: "",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: const Color(0xFF163351).withValues(alpha: 0.2)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFF163351), width: 2),
                          ),
                          filled: true,
                          fillColor: _controllers[index].text.isNotEmpty
                              ? Colors.blue.withAlpha(10)
                              : Colors.blue.withAlpha(5),
                        ),
                        focusNode: _focusNodes[index],
                        textCapitalization: TextCapitalization.characters,
                        cursorColor: const Color(0xFF163351), // Set the cursor color
                        onChanged: (value) => handleInput(index, value),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _controllers.every((controller) => controller.text.isNotEmpty)
                        ? () => navigateToCampHome
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF163351), // Updated to use `backgroundColor`
                      foregroundColor: Colors.white, // Updated to use `foregroundColor`
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Enter Camp Home"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
