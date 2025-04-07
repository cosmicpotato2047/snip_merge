import 'package:flutter/material.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  int fileCount = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB), // off-white pastel base
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Text(
                  'Merge your MP3 files easily',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Sans',
                    color: Color(0xFF3A3A3A),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),
                const Text(
                  'Select number of files to merge',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF6B6B6B),
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButton<int>(
                  value: fileCount,
                  icon: const Icon(Icons.arrow_drop_down),
                  borderRadius: BorderRadius.circular(16),
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF333333),
                  ),
                  dropdownColor: Colors.white,
                  items: [2, 3, 4, 5].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value files'),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      fileCount = newValue!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB3E5FC), // pastel blue
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/file_select',
                    arguments: fileCount, // 선택한 파일 개수 전달
                  );
                },
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
