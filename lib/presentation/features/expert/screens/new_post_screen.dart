import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final _postController = TextEditingController();
  final List<String> _images = [];

  final List<String> _sampleImages = [
    "https://img.freepik.com/free-photo/working-business-people-meeting_23-2147694707.jpg?semt=ais_hybrid&w=740&q=80",
    "https://img.freepik.com/free-photo/business-woman-working-laptop_23-2149150994.jpg?semt=ais_hybrid&w=740&q=80",
    "https://img.freepik.com/free-photo/group-diverse-people-having-business-meeting_23-2149045399.jpg?semt=ais_hybrid&w=740&q=80",
    "https://img.freepik.com/free-photo/creative-team-discussing-project_23-2147694706.jpg?semt=ais_hybrid&w=740&q=80",
  ];

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    final borderColor = isDarkMode ? Palette.borderDark : Palette.borderLight;
    final fillColor = isDarkMode ? Palette.darkFillColor : Palette.lightFillColor;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "New Post",
          style: TextStyles.largeBold.copyWith(
            color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.send, color: Palette.primary),
            label: Text(
              "Post",
              style: TextStyles.smallSemiBold.copyWith(color: Palette.primary),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(16)),
        children: [
          TextFormField(
            controller: _postController,
            maxLines: 8,
            style: TextStyles.mediumRegular.copyWith(
              color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
            ),
            decoration: InputDecoration(
              hintText: "What's on your mind?",
              filled: true,
              fillColor: fillColor,
              contentPadding: EdgeInsets.symmetric(horizontal: config.sw(12), vertical: config.sh(12)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Palette.primary),
              ),
            ),
          ),
          YMargin(16),
          Row(
            children: [
              Text(
                "Photos",
                style: TextStyles.mediumSemiBold.copyWith(
                  color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                ),
              ),
              XMargin(8),
              Text(
                "${_images.length}/4",
                style: TextStyles.smallRegular.copyWith(
                  color: isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light,
                ),
              ),
              Spacer(),
              TextButton.icon(
                onPressed: _images.length >= 4
                    ? null
                    : () {
                        setState(() {
                          _images.add(_sampleImages[_images.length % _sampleImages.length]);
                        });
                      },
                icon: Icon(Icons.add, color: Palette.primary),
                label: Text(
                  "Add",
                  style: TextStyles.smallSemiBold.copyWith(color: Palette.primary),
                ),
              ),
            ],
          ),
          YMargin(10),
          if (_images.isEmpty)
            Container(
              padding: EdgeInsets.symmetric(vertical: config.sh(20)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  Icon(Icons.image_outlined, size: 32, color: Palette.primary),
                  YMargin(6),
                  Text(
                    "Add up to 4 images",
                    style: TextStyles.smallRegular.copyWith(
                      color: isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light,
                    ),
                  ),
                ],
              ),
            ),
          if (_images.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _images.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.3,
              ),
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        _images[index],
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _images.removeAt(index);
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, size: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          YMargin(20),
        ],
      ),
    );
  }
}