import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/providers/category_provider.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
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

class _ExploreScreenState extends ConsumerState<ExploreScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryNotifier).getCategories();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  return GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(20)),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.1,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                    ),
                    itemBuilder: (context, index) {
                      final category = categoryProvider.categories[index];
                      return CategoryItem(
                        category: category.name ?? "", 
                        onTap: () {
                          push(CategoryExpertsScreen(category: category.name ?? ""));
                        }
                      );
                    },
                    itemCount: categoryProvider.categories.length,
                  );
                } 
              },
            ),
          )         
        ],
      ),
    );
  }
}