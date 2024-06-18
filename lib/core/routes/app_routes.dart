enum AppRoutes {
  splash('/'),
  mainScreen('/main_screen'),
  conversor('/conversor'),
  wallet('/wallet');

  const AppRoutes(this.path);
  final String path;
}
