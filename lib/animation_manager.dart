class AnimationManager {
  // Private constructor for the singleton pattern.
  // This prevents creating multiple instances of the manager.
  AnimationManager._privateConstructor();

  // The single, static instance of the class, accessible globally.
  static final AnimationManager instance = AnimationManager._privateConstructor();

  // A set to store the unique keys of pages that have already been animated.
  // Using a Set provides fast checks to see if a page has animated.
  final Set<String> _animatedPages = {};

  /// Checks if a page's animation has already been played.
  ///
  /// [pageKey] A unique string identifying the page (e.g., 'homePage').
  /// Returns `true` if the animation has been played, `false` otherwise.
  bool hasAnimated(String pageKey) {
    return _animatedPages.contains(pageKey);
  }

  /// Marks a page's animation as having been played.
  ///
  /// [pageKey] A unique string identifying the page to mark as animated.
  void setAnimated(String pageKey) {
    _animatedPages.add(pageKey);
  }

  /// Resets all animation flags.
  ///
  /// This method clears the set of animated pages, allowing all animations
  /// to play again. This is essential to call on events like user logout.
  void reset() {
    _animatedPages.clear();
  }
}
