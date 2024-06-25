enum AppRoutes {
  splash('/'),
  quotes('/quotes'),
  conversor('/conversor'),
  wallet('/wallet');

  const AppRoutes(this.path);
  final String path;
}
