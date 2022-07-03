import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ropstam/global/constants.dart';
import 'package:ropstam/global/utils.dart';
import 'package:ropstam/models/posts.dart';
import 'package:ropstam/state/app_state.dart';

class HomeScreen extends StatefulWidget {
  // ignore: use_key_in_widget_constructors

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  callPostList(context) async {
    Future.delayed(const Duration(milliseconds: 200));
    AppState provider = Provider.of<AppState>(context, listen: false);

    List<Posts> data = await DataUtil.fetchPostsList();
    provider.updatePostListModel(data);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callPostList(context);
  }

  @override
  Widget build(BuildContext context) {
    AppState provider = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreen,
        title: const Text('Posts'),
        centerTitle: true,
      ),
      body: provider.postsLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: provider.posts.length,
              itemBuilder: (context, index) {
                Posts post = provider.posts[index];

                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: kWhite,
                      boxShadow: const [
                        BoxShadow(
                          color: kGrey,
                          blurRadius: 3,
                        )
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 50,
                        child: Text(
                          post.title.toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: kGrey),
                        ),
                      )
                    ],
                  ),
                );
              }),
    );
  }
}
