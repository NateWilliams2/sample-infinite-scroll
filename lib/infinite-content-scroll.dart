import 'package:sample_infinite_scroll/globals.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ContentListView extends StatefulWidget {
  @override
  _ContentListViewState createState() => _ContentListViewState();
}

class _ContentListViewState extends State<ContentListView> {
  static const _pageSize = 10;

  final PagingController<int, String> _pagingController =
      PagingController(firstPageKey: 0, invisibleItemsThreshold: 2);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = List<String>();
      for (var i = 0; i < _pageSize; i++) {
        if (Globals.posts.hasNextItem)
          newItems.add(Globals.posts.getNextPost());
      }
      final isLastPage = !Globals.posts.hasNextItem;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
      log("Paging error: $error");
    }
  }

  @override
  Widget build(BuildContext context) => PagedListView<int, String>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<String>(
          itemBuilder: (context, item, index) => Padding(
            padding: const EdgeInsets.fromLTRB(8, 40, 8, 40),
            child: Text(item),
          ),
        ),
      );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

// Fake server for posts
class PostBank {
  List<String> posts = [];
  int index = 0;

  initPosts() {
    for (var i = 0; i < 20; i++) {
      posts.add("Post " + i.toString());
    }
  }

  String getNextPost() {
    return posts[index++];
  }

  get hasNextItem => index < posts.length;
}
