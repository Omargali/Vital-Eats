enum AppRoutes {
  auth('/auth'),
  restaurants('/restaurants'),
  orders('/orders'),
  profile('/profile'),
  googleMap('/googleMap'),
  updateEmail('/update-email'),
  search('/search'),
  searchLocation('/searchLocation'),
  
  cart('/cart');

  const AppRoutes(this.route);

  final String route;
}
