class MiniKeyboard {
  bool isActive = false;
  int prevTap =
      -1; // 0 and 1 correspond to left and right finger. -1 is initial.

  bool press(int key) {
    bool isNew = prevTap != key && isActive; // To indicate whether it's a valid trill tap
    prevTap = isActive ? key : prevTap;
    return isNew;
  }

  void activate() {
    isActive = true;
  }

  void deactivate() {
    isActive = false;
  }
}
