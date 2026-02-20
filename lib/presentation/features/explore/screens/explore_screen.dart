import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/providers/category_provider.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/domain/models/category_model.dart';
import 'package:earnwise_app/presentation/features/explore/screens/category_experts_screen.dart';
import 'package:earnwise_app/presentation/features/explore/widgets/category_item.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/custom_progress_indicator.dart';
import 'package:earnwise_app/presentation/widgets/search_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;


  final ValueNotifier<String> _searchQuery = ValueNotifier<String>("");

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryNotifier).getCategories();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var categoryProvider = ref.watch(categoryNotifier);
   

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Find Experts',
          style: TextStyles.largeBold.copyWith(
            fontFamily: TextStyles.fontFamily,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: config.sw(16)),
            child: SearchTextField(
              hint: "Search for a category",
              prefix: Icon(Icons.search),
              onChanged: (val) {
                _searchQuery.value = val;
              },
            ),
          ),   
         //  YMargin(10),
          Expanded(
            child: Builder(
              builder: (context) {
                if(categoryProvider.isLoading) {
                  return Center(
                    child: CustomProgressIndicator(),
                  );
                } else {
                  return ValueListenableBuilder(
                    valueListenable: _searchQuery, 
                    builder: (context, value, child) {
                      if(value.isEmpty) {
                        return _buildSearchResults(categoryProvider.categories);
                      } else {
                        var results = categoryProvider.categories.where((category) => category.name?.toLowerCase().contains(value.toLowerCase()) ?? false).toList();
                        return _buildSearchResults(results);
                      }
                    }
                  );
                } 
              },
            ),
          )         
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<CategoryModel> categories) {
    return GridView.builder(
      key: const PageStorageKey<String>("explore_categories_grid"),
      controller: _scrollController,
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(
        horizontal: config.sw(20), 
        vertical: config.sh(20)
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.1,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        return CategoryItem(
          category: category.name ?? "", 
          onTap: () {
            push(CategoryExpertsScreen(category: category.name ?? ""));
          }
        );
      },
      itemCount: categories.length,
    );
  }
}