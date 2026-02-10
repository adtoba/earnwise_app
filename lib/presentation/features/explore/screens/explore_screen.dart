import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/features/explore/screens/category_experts_screen.dart';
import 'package:earnwise_app/presentation/features/explore/widgets/category_item.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/search_textfield.dart';
import 'package:flutter/material.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    final categories = [
      "Accounting",
      "Investing",
      "Career Coaching",
      "Entrepreneurship",
      "Tax Planning",
      "Marketing",
      "UX Design",
      "Software Engineering",
      "Real Estate",
      "Personal Finance",
    ];

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
            child: GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(20)),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.4,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryItem(
                  category: category, 
                  onTap: () {
                    push(CategoryExpertsScreen(category: category));
                  }
                );
              },
              itemCount: categories.length,
            ),
           )         
         ],
       ),
    );
  }
}