import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/providers/category_provider.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategorySelectionScreen extends ConsumerStatefulWidget {
  const CategorySelectionScreen({super.key,
    required this.initialSelection,
  });

  final List<String> initialSelection;

  @override
  ConsumerState<CategorySelectionScreen> createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends ConsumerState<CategorySelectionScreen> {
  late Set<String> _selected;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryNotifier).getCategories();
    });
    super.initState();
    _selected = widget.initialSelection.toSet();
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = ref.watch(categoryNotifier);
    final categories = categoryProvider.categories;

    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    final borderColor = isDarkMode ? Palette.borderDark : Palette.borderLight;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Categories"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(_selected.toList());
            },
            child: Text(
              "Done",
              style: TextStyles.smallSemiBold.copyWith(color: Palette.primary),
            ),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if(categoryProvider.isLoading) {
            return Center(
              child: CustomProgressIndicator(),
            );
          } else if(categories.isEmpty) {
            return Center(
              child: Text(
                "No categories found",
                style: TextStyles.largeBold
              ),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(16)),
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = _selected.contains(category.name);
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: CheckboxListTile(
                  value: isSelected,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    category.name ?? "",
                    style: TextStyles.mediumSemiBold,
                  ),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _selected.add(category.name ?? "");
                      } else {
                        _selected.remove(category.name ?? "");
                      }
                    });
                  },
                ),
              );
            },
            separatorBuilder: (_, __) => YMargin(10),
            itemCount: categories.length,
          );
        }
      ),
    );
  }
}