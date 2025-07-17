class GeneralUtilities {
  static bool isTypeCovalentAndAssignable<T, U>(T? a, U? b) {
    if ((b is T) || (a is U) || ((a is U?) && (b is T?))) {
      return true;
    }
    return false;
  }
}
