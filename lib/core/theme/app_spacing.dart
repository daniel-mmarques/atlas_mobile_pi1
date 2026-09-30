abstract class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  /// Gutter horizontal único (shells + sheets).
  static const double pageHorizontal = 16;

  static const double cardPadding = 16;
  static const double sectionGap = 16;

  static const double navHeight = 64;
  static const double shellHeaderHeight = 56;

  /// Clearance acima da nav flutuante (sem safe area; some MediaQuery.padding).
  static const double shellBottomInset = navHeight + xs;

  /// Alvos de toque / botões (Apple HIG ≥ 44).
  static const double minTouch = 44;
  static const double buttonHeight = 48;
  static const double buttonHeightLg = 52;

  /// Sheet chrome.
  static const double sheetPaddingH = 20;
  static const double sheetPaddingB = 28;
  static const double sheetHandleWidth = 48;
  static const double sheetHandleHeight = 5;

  /// Alturas relativas das bottom sheets (`DraggableScrollableSheet`).
  static const double sheetInitial = 0.95;
  static const double sheetMax = 0.95;
  static const double sheetMin = 0.42;
  static const double sheetMinContent = 0.55;

  /// Ícones por papel.
  static const double iconSm = 18;
  static const double iconMd = 22;
  static const double iconLg = 28;
  static const double iconNav = 28;
  static const double iconBack = 28;
}
