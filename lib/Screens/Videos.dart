import 'package:flutter/material.dart';

class VideosScreen extends StatelessWidget {
  const VideosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF23074D),
      appBar: AppBar(
        title: const Text("📺 Kids TV"),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          _buildCategoryHeader("Trending Now 🔥"),
          _buildHorizontalVideos(),
          _buildCategoryHeader("Nursery Rhymes 🎶"),
          _buildVerticalVideoList(),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildHorizontalVideos() {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        itemCount: 4,
        itemBuilder: (context, i) => Container(
          width: 240,
          margin: const EdgeInsets.only(right: 15),
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: NetworkImage('https://picsum.photos/400/200'),
              fit: BoxFit.cover,
            ),
          ),
          child: const Icon(
            Icons.play_circle_fill,
            color: Colors.white,
            size: 50,
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalVideoList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, i) => ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            'https://picsum.photos/100/100',
            width: 80,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          "Bedtime Story #$i",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: const Text(
          "15:00 Mins",
          style: TextStyle(color: Colors.white54),
        ),
      ),
    );
  }
}
