class AnimationManager {
  // Private constructor
  AnimationManager._privateConstructor();

  // The single, static instance of the class
  static final AnimationManager instance = AnimationManager._privateConstructor();

  // A set to hold the keys of pages that have already animated
  final Set<String> _animatedPages = {};

  // Checks if a page has animated
  bool hasAnimated(String pageKey) {
    return _animatedPages.contains(pageKey);
  }

  // Marks a page as animated
  void setAnimated(String pageKey) {
    _animatedPages.add(pageKey);
  }

  // FIX: Add this reset method to clear the set on logout.
  void reset() {
    _animatedPages.clear();
  }
}
