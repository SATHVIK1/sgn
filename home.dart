import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/entry.dart';
import '../widgets/previews.dart';
import '../widgets/content/bar.dart';
import '../widgets/content/header.dart' as header;
import '../widgets/content/list.dart' as list;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _scrollOffset = 0.0;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _scrollOffset = _scrollController.offset;
        });
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final entryProvider = context.watch<EntryProvider>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 70.0),
        child: ContentBar(scrollOffset: _scrollOffset),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: header.ContentHeader(
              featured: entryProvider.featured,
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.only(top: 20),
            sliver: SliverToBoxAdapter(
              child: Previews(
                key: PageStorageKey('previews'),
                title: 'Previews',
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: list.ContentList(
                title: 'Only on PK Netflix',
                contentList: entryProvider.entries
                    .where((e) => e.tags.contains('original'))
                    .toList(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: list.ContentList(
              title: 'New releases',
              contentList: entryProvider.entries
                  .where((e) => e.tags.contains('new'))
                  .toList(),
            ),
          ),
          SliverToBoxAdapter(
            child: list.ContentList(
              title: 'Animation',
              contentList: entryProvider.entries
                  .where((e) => e.tags.contains('animation'))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
