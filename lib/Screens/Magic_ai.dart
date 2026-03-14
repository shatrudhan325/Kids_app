import 'dart:ui';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class MagicAIPage extends StatefulWidget {
  const MagicAIPage({super.key});

  @override
  State<MagicAIPage> createState() => _MagicAIPageState();
}

class _MagicAIPageState extends State<MagicAIPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isAnalyzing = false;
  List<Map<String, String>> _history = []; // Simple local history storage

  // 🔑 REPLACE WITH YOUR ACTUAL KEY
  final String _apiKey = "AIzaSyCRYtmIhMKxKznaqVovqPOkr7OVpJXhnVA";

  /// Core Logic: Communicates with Google Gemini
  Future<void> _analyzeWithGemini(XFile? file, String userText) async {
    // 1. Fixed the check so it doesn't block your real key
    if (_apiKey.isEmpty || _apiKey == "PASTE_YOUR_KEY_HERE") {
      _showResult("Error: Please add a valid API Key! 🔑", isError: true);
      return;
    }

    setState(() => _isAnalyzing = true);

    try {
      // 2. Initialize the model
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);

      final List<Content> content = [];
      String systemPrompt = "Explain simply for a 7-year-old. Use emojis! 🌟";
      String promptText = userText.isEmpty
          ? "What is in this picture?"
          : userText;

      if (file != null) {
        final Uint8List imageBytes = await file.readAsBytes();
        content.add(
          Content.multi([
            TextPart("$systemPrompt $promptText"),
            DataPart('image/jpeg', imageBytes),
          ]),
        );
      } else {
        content.add(Content.text("$systemPrompt $promptText"));
      }

      // 3. Request generation
      final response = await model.generateContent(content);
      final aiText = response.text;

      if (aiText == null) {
        throw Exception("Gemini returned an empty response.");
      }

      setState(() {
        _isAnalyzing = false;
        _history.insert(0, {
          "q": userText.isEmpty ? "Image Scan" : userText,
          "a": aiText,
        });
      });

      _showResult(aiText);
    } catch (e) {
      setState(() => _isAnalyzing = false);

      // THIS WILL HELP YOU DEBUG:
      print("DEBUG ERROR: $e");

      _showResult(
        "Magic failed! Error: ${e.toString().split(':').last}", // Shows the actual error message
        isError: true,
      );
    }
  }

  Future<void> _pickFile(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(
      source: source,
      imageQuality: 80,
    );
    if (file != null) {
      _analyzeWithGemini(file, _searchController.text);
    }
  }

  void _showResult(String text, {bool isError = false}) {
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: const Color(0xFF2A2A4A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title: Text(
            isError ? "Oh No! 😮" : "Gemini Says: ✨",
            style: TextStyle(
              color: isError ? Colors.redAccent : Colors.cyanAccent,
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Awesome!",
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A1A2E), Color(0xFF432C7B)],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildTopNav(context),
                  const SizedBox(height: 20),
                  _buildSearchBar(),
                  const SizedBox(height: 30),
                  _isAnalyzing ? _buildLoadingState() : _buildUploadArea(),
                  const SizedBox(height: 20),
                  if (_history.isNotEmpty) _buildHistoryList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopNav(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        const Text(
          "Magic AI Helper",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white24),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        onSubmitted: (val) => _analyzeWithGemini(null, val),
        decoration: InputDecoration(
          hintText: "Ask me anything...",
          hintStyle: const TextStyle(color: Colors.white54),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: const Icon(Icons.send_rounded, color: Colors.cyanAccent),
            onPressed: () => _analyzeWithGemini(null, _searchController.text),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadArea() {
    return Row(
      children: [
        Expanded(
          child: _magicButton(
            "Camera",
            Icons.camera_alt_rounded,
            Colors.orangeAccent,
            () => _pickFile(ImageSource.camera),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _magicButton(
            "Gallery",
            Icons.image_rounded,
            Colors.blueAccent,
            () => _pickFile(ImageSource.gallery),
          ),
        ),
      ],
    );
  }

  Widget _magicButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback tap,
  ) {
    return GestureDetector(
      onTap: tap,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: color.withOpacity(0.5), width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 30),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Recent Magic ✨",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  title: Text(
                    _history[index]['q']!,
                    style: const TextStyle(
                      color: Colors.cyanAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    _history[index]['a']!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  onTap: () => _showResult(_history[index]['a']!),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        children: [
          CircularProgressIndicator(color: Colors.cyanAccent),
          SizedBox(height: 20),
          Text(
            "Gemini is thinking... ✨",
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
