import 'package:flutter/cupertino.dart';
import 'package:ropstam/models/posts.dart';

class AppState extends ChangeNotifier {
  bool passwordVisible = true;

  updatePasswordVisibility() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  bool loginScreenLoading = false;

  updateLoginScreenLoading(bool loginScreenLoading) {
    this.loginScreenLoading = loginScreenLoading;
    notifyListeners();
  }

  List<Posts> posts = [];
  bool postsLoading = true;
  int? pickTappedIndex;

  void updatePostListModel(List<Posts> posts) {
    this.posts = posts;
    postsLoading = false;
    notifyListeners();
  }
}
