import 'package:flutter/material.dart';
import 'package:sgnetflix/assets.dart';

import '../../screens/watchlist.dart';

class ContentBar extends StatelessWidget {
  final double scrollOffset;

  const ContentBar({Key? key, this.scrollOffset = 0.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24.0),
      color: Colors.black.withOpacity((scrollOffset / 350).clamp(0, 1)),
      child: SafeArea(
        child: Row(
          children: [
            Image.asset(Assets.netflixLogo0),
            const SizedBox(
              width: 12.0,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Spacer(),
                  _AppBarButton("TV Shows", () {}),
                  const Spacer(),
                  _AppBarButton("Movies", () {}),
                  const Spacer(),
                  _AppBarButton('My List', () async {
                    await showDialog(
                        context: context,
                        builder: (context) => const WatchlistScreen());
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppBarButton extends StatelessWidget {
  final String title;
  final Function function;

  const _AppBarButton(this.title, this.function);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        function();
      },
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w500),
      ),
    );
  }
}