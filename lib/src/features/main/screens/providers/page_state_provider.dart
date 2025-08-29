import 'package:flutter_riverpod/flutter_riverpod.dart';

final pageStateProvider = StateNotifierProvider<PageNotifier, PageState>((ref) {
  return PageNotifier();
});

class PageNotifier extends StateNotifier<PageState>{
  PageNotifier():super(PageState());

}

class PageState {
  final double width;
  final double height;
  final double marginTop;
  final double marginLeft;
  final double marginBottom;
  final double marginRight;
  

  PageState({
    this.width = 0,
    this.height = 0,
    this.marginTop = 0, 
    this.marginLeft = 0, 
    this.marginBottom = 0, 
    this.marginRight = 0,
  });
}