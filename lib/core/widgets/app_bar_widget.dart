import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order/core/theming/colors.dart';
import 'package:order/core/theming/styles.dart';
import 'package:order/features/restaurant/presentation/cubit/restaurant_cubit.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final String? pageName;
  final Widget? titleWidget;
  final bool hideBackButton;
  final List<Widget>? actions;
  final Widget? leading;

  const AppBarWidget({
    Key? key,
    this.pageName,
    this.titleWidget,
    this.hideBackButton = true,
    this.actions,
    this.leading,
  })  : assert(pageName != null || titleWidget != null,
            'Either pageName or titleWidget must be provided'),
        super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  _AppBarWidgetState createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
  }

  void _performSearch(String query, BuildContext context) {
    // Implement your search logic here based on your requirements
    if (query.isEmpty) {
      // If query is empty, show all restaurants
      BlocProvider.of<RestaurantCubit>(context).getAllRestaurants();
    } else {
      // Otherwise, filter based on restaurant name or order title
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [ColorsManager.mainBlue, ColorsManager.moreLighterGray],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      leading: widget.hideBackButton
          ? null
          : widget.leading ??
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
      title: _isSearching
          ? TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
              style: TextStyle(color: Colors.white),
              autofocus: true,
              onChanged: (query) => _performSearch(query, context),
            )
          : widget.titleWidget ??
              Text(
                widget.pageName!,
                style: TextStyles.font22BlackBold.copyWith(color: Colors.white),
              ),
      actions: _isSearching
          ? [
              IconButton(
                icon: const Icon(Icons.cancel),
                onPressed: _stopSearch,
              ),
            ]
          : widget.actions ??
              [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _startSearch,
                ),
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {
                    // Add notification functionality here
                  },
                ),
              ],
    );
  }
}
