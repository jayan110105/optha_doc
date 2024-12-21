import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E6DB),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _HeaderText('OpthaDoc'),
            const _HomeImage(imagePath: 'assets/images/homepage.jpg'),
            const _SubtitleText('Welcome to OpthaDoc!'),
            const _DescriptionText('Let\'s transform eye care together!'),
            const SizedBox(height: 50),
            _ActionButton(
              text: 'Camp Mode',
              icon: Icons.festival,
              onPressed: () => Navigator.pushNamed(context, '/camp'),
            ),
            const SizedBox(height: 8),
            _ActionButton(
              text: 'Hospital Mode',
              icon: Icons.apartment,
              onPressed: () => Navigator.pushNamed(context, '/login'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// Reusable header text widget
class _HeaderText extends StatelessWidget {
  final String text;

  const _HeaderText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF163352),
        fontWeight: FontWeight.bold,
        fontSize: 48,
      ),
    );
  }
}

// Reusable image widget
class _HomeImage extends StatelessWidget {
  final String imagePath;

  const _HomeImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      height: 300, // Adjust the size as needed
    );
  }
}

// Reusable subtitle text widget
class _SubtitleText extends StatelessWidget {
  final String text;

  const _SubtitleText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF163352),
        fontWeight: FontWeight.bold,
        fontSize: 23,
      ),
    );
  }
}

// Reusable description text widget
class _DescriptionText extends StatelessWidget {
  final String text;

  const _DescriptionText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xB2163351),
        fontWeight: FontWeight.w500,
        fontSize: 18,
      ),
    );
  }
}

// Reusable button widget
class _ActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF163352),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            padding: const EdgeInsets.all(15),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 30),
              const SizedBox(width: 10),
              Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
