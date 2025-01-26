import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFE9E6DB),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _HeaderText('OpthaDoc'),
            _HomeImage(
                imagePath: 'assets/images/homepage.jpg',
                maxHeight: screenHeight * 0.4
            ),
            const _SubtitleText('Welcome to OpthaDoc!'),
            const _DescriptionText('Let\'s transform eye care together!'),
            const SizedBox(height: 50),
            _ActionButton(
              text: 'Get Started',
              icon: Icons.festival,
              onPressed: () => Navigator.pushNamed(context, '/CampVerification'),
            ),
            const SizedBox(height: 8),
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
  final double maxHeight;

  const _HomeImage({required this.imagePath, required this.maxHeight});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      height: maxHeight, // Adjust the size as needed
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
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF163352),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.all(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Color(0xFFE9E6DB), size: 25),
              const SizedBox(width: 10),
              Text(
                text,
                style: const TextStyle(color: Color(0xFFE9E6DB), fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
