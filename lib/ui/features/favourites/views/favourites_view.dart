import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/dish_summary_model.dart';
import '../../../../data/services/api/recipe_service.dart';
import '../../home/views/widgets/dish_card.dart';

class FavouritesView extends StatefulWidget {
  const FavouritesView({super.key});

  @override
  State<FavouritesView> createState() => _FavouritesViewState();
}

class _FavouritesViewState extends State<FavouritesView> {
  bool _isLoading = true;
  List<DishSummaryModel> _favouriteDishes = [];

  @override
  void initState() {
    super.initState();
    _loadFavourites();
  }

  Future<void> _loadFavourites() async {
    setState(() => _isLoading = true);
    try {
      final list = await context.read<RecipeService>().getFavourites();
      if (mounted) {
        setState(() {
          _favouriteDishes = list;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Favourites'),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.saffronPrimary))
            : _favouriteDishes.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.favorite_border_rounded, size: 64, color: AppColors.saffronPrimary),
                          const SizedBox(height: 16),
                          Text(
                            'No favourites yet',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the heart icon on any recipe card to save it here for quick access.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = 1;
                      double childAspectRatio = 1.15;

                      if (constraints.maxWidth > 900) {
                        crossAxisCount = 4;
                        childAspectRatio = 0.82;
                      } else if (constraints.maxWidth > 650) {
                        crossAxisCount = 3;
                        childAspectRatio = 0.85;
                      } else if (constraints.maxWidth > 420) {
                        crossAxisCount = 2;
                        childAspectRatio = 0.82;
                      } else {
                        crossAxisCount = 1;
                        childAspectRatio = 1.30;
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: childAspectRatio,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                        ),
                        itemCount: _favouriteDishes.length,
                        itemBuilder: (context, index) {
                          return DishCard(dish: _favouriteDishes[index]);
                        },
                      );
                    },
                  ),
      ),
    );
  }
}
