import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';


final interactiveStateProvider = StateNotifierProvider<InteractiveStateNotifier, InteractiveState>((ref) {
  return InteractiveStateNotifier();
});

class InteractiveStateNotifier extends StateNotifier<InteractiveState>{
  
  InteractiveStateNotifier():super(InteractiveState());

  void updateOrigin(Offset newOrigin){
    state = state.copyWith(origin: newOrigin);
  }

  void updateScale(double newScale){
    state = state.copyWith(scale: newScale);
  }

}

class InteractiveState {
  final Offset origin;
  final double scale;
  final bool isGridActive;

  InteractiveState({
    this.origin = Offset.zero,
    this.scale = 1,
    this.isGridActive = false
  });

  InteractiveState copyWith({
    Offset? origin,
    double? scale,
    bool? isGridActive
  }) => InteractiveState(
    origin: origin ?? this.origin,
    scale: scale ?? this.scale,
    isGridActive: isGridActive ?? this.isGridActive
  );
}