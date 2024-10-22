enum AppRoutes {
  auth('/auth'),
  restaurants('/restaurants'),
  orders('/orders'),
  profile('/profile'),
  updateEmail('/update-email'),
  cart('/cart');

  const AppRoutes(this.route);

  final String route;
}
