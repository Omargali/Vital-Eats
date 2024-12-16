import 'package:api/api.dart';
import 'package:equatable/equatable.dart';

class MenuProps extends Equatable {
  const MenuProps({required this.restaurant});

  final Restaurant restaurant;

  @override
  List<Object> get props => [restaurant];
}
