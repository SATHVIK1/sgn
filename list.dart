import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sgnetflix/data/entry.dart';
import 'package:sgnetflix/providers/entry.dart';

class ContentList extends StatelessWidget {
  final String title;
  final List<Entry> contentList;

  const ContentList({
    Key? key,
    required this.title,
    required this.contentList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (contentList.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 220.0,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            scrollDirection: Axis.horizontal,
            itemCount: contentList.length,
            itemBuilder: (context, index) {
              final entry = contentList[index];
              return _ContentThumbnail(entry: entry);
            },
          ),
        ),
      ],
    );
  }
}

class _ContentThumbnail extends StatelessWidget {
  final Entry entry;

  const _ContentThumbnail({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: context.read<EntryProvider>().imageFor(entry),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(width: 120, height: 200);
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          width: 120,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            image: DecorationImage(
              image: MemoryImage(snapshot.data!),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
