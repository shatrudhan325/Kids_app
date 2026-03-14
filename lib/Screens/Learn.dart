// import 'package:flutter/material.dart';
// import 'package:kids_app/Const/Learning_data.dart';

// class LearnScreen extends StatefulWidget {
//   const LearnScreen({super.key});

//   @override
//   State<LearnScreen> createState() => _LearnScreenState();
// }

// class _LearnScreenState extends State<LearnScreen> {
//   String selectedCategory = "Poems";

//   @override
//   Widget build(BuildContext context) {
//     final categories = LearningContent.data.keys.toList();
//     final currentLessons = LearningContent.data[selectedCategory]!;

//     return Scaffold(
//       backgroundColor: const Color(0xFF6E48AA),
//       body: CustomScrollView(
//         physics: const BouncingScrollPhysics(),
//         slivers: [
//           _buildSliverAppBar("Learning Path"),
//           SliverToBoxAdapter(child: _buildCategoryTabs(categories)),
//           SliverPadding(
//             padding: const EdgeInsets.all(20),
//             sliver: SliverList(
//               delegate: SliverChildBuilderDelegate((context, index) {
//                 final item = currentLessons[index];

//                 if (selectedCategory == "Poems") {
//                   return _buildPoemCard(item); // 🎵 Special Design
//                 } else {
//                   return _buildLessonTile(item); // 📘 Normal Design
//                 }
//               }, childCount: currentLessons.length),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ---------------- APP BAR ----------------
//   Widget _buildSliverAppBar(String title) {
//     return SliverAppBar(
//       expandedHeight: 100,
//       pinned: true,
//       backgroundColor: const Color(0xFF6E48AA),
//       flexibleSpace: FlexibleSpaceBar(
//         centerTitle: true,
//         title: Text(
//           title,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }

//   // ---------------- CATEGORY TABS ----------------
//   Widget _buildCategoryTabs(List<String> categories) {
//     return SizedBox(
//       height: 60,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 15),
//         itemCount: categories.length,
//         itemBuilder: (context, i) {
//           bool isSelected = selectedCategory == categories[i];

//           return GestureDetector(
//             onTap: () => setState(() => selectedCategory = categories[i]),
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 200),
//               width: 110,
//               margin: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: isSelected ? Colors.orangeAccent : Colors.white10,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(
//                   color: isSelected ? Colors.white : Colors.white24,
//                 ),
//               ),
//               child: Center(
//                 child: Text(
//                   categories[i],
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: isSelected
//                         ? FontWeight.bold
//                         : FontWeight.normal,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // ---------------- NORMAL LESSON TILE ----------------
//   Widget _buildLessonTile(Map<String, dynamic> item) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 18),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(25),
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.all(15),
//         leading: Text(item['icon'], style: const TextStyle(fontSize: 35)),
//         title: Text(
//           item['title'],
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         subtitle: Text(
//           item['sub'],
//           style: const TextStyle(color: Colors.white60),
//         ),
//         trailing: const Icon(
//           Icons.arrow_forward_ios,
//           color: Colors.white24,
//           size: 16,
//         ),
//         onTap: () => _openDetail(item),
//       ),
//     );
//   }

//   // ---------------- SPECIAL POEM CARD ----------------
//   Widget _buildPoemCard(Map<String, dynamic> poem) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [poem["color"].withOpacity(0.7), poem["color"]],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(25),
//         boxShadow: [
//           BoxShadow(
//             color: poem["color"].withOpacity(0.5),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: ListTile(
//         contentPadding: EdgeInsets.zero,
//         leading: Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.3),
//             shape: BoxShape.circle,
//           ),
//           child: Text(poem["icon"], style: const TextStyle(fontSize: 30)),
//         ),
//         title: Text(
//           poem["title"],
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//         subtitle: Text(
//           poem["content"][0], // preview line
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           style: const TextStyle(color: Colors.white70),
//         ),
//         trailing: const Icon(Icons.music_note, color: Colors.white),
//         onTap: () => _openDetail(poem),
//       ),
//     );
//   }

//   // ---------------- NAVIGATION ----------------
//   void _openDetail(Map<String, dynamic> item) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ContentDetailScreen(
//           title: item['title'],
//           content: List<String>.from(item['content']),
//           themeColor: item['color'],
//         ),
//       ),
//     );
//   }
// }

// // ================= DETAIL SCREEN =================

// class ContentDetailScreen extends StatelessWidget {
//   final String title;
//   final List<String> content;
//   final Color themeColor;

//   const ContentDetailScreen({
//     super.key,
//     required this.title,
//     required this.content,
//     required this.themeColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: themeColor,
//       appBar: AppBar(
//         title: Text(title),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: PageView.builder(
//         itemCount: content.length,
//         itemBuilder: (context, index) {
//           return Center(
//             child: Container(
//               width: 300,
//               height: 400,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(30),
//                 boxShadow: const [
//                   BoxShadow(color: Colors.black26, blurRadius: 15),
//                 ],
//               ),
//               child: Center(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Text(
//                     content[index],
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: themeColor,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kids_app/Const/Learning_data.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  String selectedCategory = "Poems";

  @override
  Widget build(BuildContext context) {
    final categories = LearningContent.data.keys.toList();
    final currentLessons = LearningContent.data[selectedCategory]!;

    return Scaffold(
      backgroundColor: const Color(0xFF6E48AA),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar("Learning Path"),
          SliverToBoxAdapter(child: _buildCategoryTabs(categories)),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = currentLessons[index];

                if (selectedCategory == "Poems") {
                  return _buildPoemCard(item);
                } else {
                  return _buildLessonTile(item);
                }
              }, childCount: currentLessons.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(String title) {
    return SliverAppBar(
      expandedHeight: 100,
      pinned: true,
      backgroundColor: const Color(0xFF6E48AA),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: const Text(
          "Learning Path",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs(List<String> categories) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: categories.length,
        itemBuilder: (context, i) {
          bool isSelected = selectedCategory == categories[i];

          return GestureDetector(
            onTap: () => setState(() => selectedCategory = categories[i]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 110,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.orangeAccent : Colors.white10,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  categories[i],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLessonTile(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: Text(item['icon'], style: const TextStyle(fontSize: 35)),
        title: Text(
          item['title'],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          item['sub'],
          style: const TextStyle(color: Colors.white60),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white24,
          size: 16,
        ),
        onTap: () => _openDetail(item),
      ),
    );
  }

  Widget _buildPoemCard(Map<String, dynamic> poem) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [poem["color"].withOpacity(0.7), poem["color"]],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Text(poem["icon"], style: const TextStyle(fontSize: 30)),
        title: Text(
          poem["title"],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        subtitle: Text(
          poem["content"][0],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: const Icon(Icons.music_note, color: Colors.white),
        onTap: () => _openDetail(poem),
      ),
    );
  }

  void _openDetail(Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContentDetailScreen(
          title: item['title'],
          content: List<String>.from(item['content']),
          themeColor: item['color'],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////
///                TTS DETAIL SCREEN                  ///
////////////////////////////////////////////////////////

class ContentDetailScreen extends StatefulWidget {
  final String title;
  final List<String> content;
  final Color themeColor;

  const ContentDetailScreen({
    super.key,
    required this.title,
    required this.content,
    required this.themeColor,
  });

  @override
  State<ContentDetailScreen> createState() => _ContentDetailScreenState();
}

class _ContentDetailScreenState extends State<ContentDetailScreen> {
  final FlutterTts flutterTts = FlutterTts();
  bool isHindi = false;

  @override
  void initState() {
    super.initState();
    _detectLanguage();
    _setupTTS();

    Future.delayed(const Duration(milliseconds: 500), () {
      speak(widget.content.first);
    });
  }

  void _detectLanguage() {
    if (widget.title.contains("स्वर") || widget.title.contains("व्यंजन")) {
      isHindi = true;
    }
  }

  Future _setupTTS() async {
    await flutterTts.setSpeechRate(0.45); // Natural speed
    await flutterTts.setPitch(1.0);
    await flutterTts.setVolume(1.0);

    if (isHindi) {
      await flutterTts.setLanguage("hi-IN");
    } else {
      await flutterTts.setLanguage("en-US");
    }

    // Try to select best available voice
    var voices = await flutterTts.getVoices;

    if (voices != null) {
      for (var voice in voices) {
        if (isHindi && voice["locale"].toString().contains("hi")) {
          await flutterTts.setVoice(voice);
          break;
        } else if (!isHindi && voice["locale"].toString().contains("en-US")) {
          await flutterTts.setVoice(voice);
          break;
        }
      }
    }
  }

  // 🔥 Remove emoji before speaking
  String cleanText(String text) {
    final emojiRegex = RegExp(
      r'[\u{1F300}-\u{1FAFF}\u{2600}-\u{26FF}]',
      unicode: true,
    );
    return text.replaceAll(emojiRegex, "").trim();
  }

  Future speak(String text) async {
    await flutterTts.stop();
    await flutterTts.speak(cleanText(text));
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.themeColor,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: () => speak(widget.content.join(" ")),
          ),
        ],
      ),
      body: PageView.builder(
        itemCount: widget.content.length,
        onPageChanged: (index) {
          speak(widget.content[index]);
        },
        itemBuilder: (context, index) {
          return Center(
            child: Container(
              width: 300,
              height: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 15),
                ],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    widget.content[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: widget.themeColor,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
