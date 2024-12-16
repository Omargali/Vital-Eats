import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide MenuController;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurants_repository/restaurants_repository.dart';
import 'package:vital_eats_2/menu/menu.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({required this.props, super.key});

  final MenuProps props;
  
  @override
  Widget build(BuildContext context){
    return BlocProvider(
      create: (_) => MenuBloc(
        restaurant: props.restaurant,
        restaurantsRepository: context.read<RestaurantsRepository>(),
      )..add(const MenuFetchRequested()),
      child: const MenuView(),
    );
  }
}

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  late MenuController _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = MenuController();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    final menus = context.select((MenuBloc bloc) => bloc.state.menus);
    final restaurant = context.select((MenuBloc bloc) => bloc.state.restaurant);

    return DefaultTabController(
      length: menus.length,
      child: Builder(
        builder: (context) {
          WidgetsBinding.instance.addPostFrameCallback((_){
            _bloc
            ..init(menus)
            ..tabController = DefaultTabController.of(context);
          });
          return AppScaffold(
            top: false,
            body: CustomScrollView(
              controller: _bloc.scrollController,
              slivers: [
                ListenableBuilder(
                  listenable: Listenable.merge([
                    _bloc.isScrolledNotifier,
                    _bloc.colorChangeNotifier,
                    _bloc.preferredSizedNotifier,
                  ]), 
                  builder: (context, _){
                    return SliverAppBar(
                       titleSpacing: AppSpacing.xlg,
                      pinned: true,
                      expandedHeight: 300,
                      forceElevated: true,
                      automaticallyImplyLeading: false,
                      leading: Padding(
                        padding: const EdgeInsets.only(left: AppSpacing.md),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.customReversedAdaptiveColor(
                              light: AppColors.white,
                              dark: context.theme.canvasColor,
                            ),
                          ),
                          child: Tappable.faded(
                            onTap: context.pop,
                            child: Icon(
                              _bloc.isScrolledNotifier.value
                                  ? LucideIcons.x
                                  : Icons.adaptive.arrow_back,
                            ),
                          ),
                        ),
                      ),
                      flexibleSpace: AnnotatedRegion<SystemUiOverlayStyle>(
                        value: context.isAndroid
                            ? SystemUiOverlayTheme.adaptiveOSSystemBarTheme(
                                light: !_bloc.colorChangeNotifier.value,
                                persistLight: context.isDark,
                              )
                            : SystemUiOverlayTheme
                                .adaptiveAndroidTransparentSystemBarTheme(
                                light: !_bloc.colorChangeNotifier.value,
                                persistLight: context.isDark,
                              ),
                        child: FlexibleSpaceBar(
                          expandedTitleScale: 2.2,
                          centerTitle: false,
                          background: MenuAppBarBackgroundImage(
                            imageUrl: restaurant.imageUrl,
                            placeId: restaurant.placeId,
                          ),
                          title: Hero(
                            tag: 'Menu${restaurant.name}',
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: _bloc.preferredSizedNotifier.value,
                              ),
                              child: Text(
                                restaurant.name,
                                maxLines:
                                    _bloc.colorChangeNotifier.value ? 1 : 2,
                                style: context.titleMedium?.copyWith(
                                  fontWeight: AppFontWeight.bold,
                                  color: _bloc.colorChangeNotifier.value
                                      ? context.customReversedAdaptiveColor(
                                          dark: AppColors.white,
                                          light: AppColors.black,
                                        )
                                      : AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      bottom: PreferredSize(
                        preferredSize:
                            Size.fromHeight(_bloc.preferredSizedNotifier.value),
                        child: CircularContainer(
                          height: _bloc.preferredSizedNotifier.value,
                        ),
                      ),
                    );
                  },
                ),
                if(menus.isNotEmpty) ...[
                   ListenableBuilder(
                    listenable: _bloc,
                    builder: (context, _) {
                      if (_bloc.tabs.isEmpty) {
                        return const SliverToBoxAdapter(
                          child: SizedBox.shrink(),
                        );
                      }
                      return MenuTabBar(controller: _bloc);
                    },
                  ),
                   ListenableBuilder(
                    listenable: _bloc,
                    builder: (context, child) {
                      return MenuDiscounts(discounts: _bloc.discounts);
                    },
                  ),
                  for(int i = 0; i < menus.map((e) => e.category).length; i++) ...[
                    MenuSectionHeader(
                      categoryName: menus[i].category, 
                      categoryHeight: _bloc.categoryHeight,
                    ),
                    MenuSectionItems(menu: menus[i]),
                  ],
                ],
              ],
             ),
            );
        },
      ),
    );
  }
}

class CircularContainer extends StatelessWidget {
  const CircularContainer({
    required this.height,
    super.key,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 2.ms,
      height: height,
      decoration: BoxDecoration(
        color: context.theme.canvasColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.lg * 2),
        ),
      ),
    );
  }
}
