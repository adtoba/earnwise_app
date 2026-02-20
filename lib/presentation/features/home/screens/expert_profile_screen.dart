import 'dart:math';

import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/extensions.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/core/providers/review_provider.dart';
import 'package:earnwise_app/domain/models/expert_profile_model.dart';
import 'package:earnwise_app/presentation/features/home/views/about_expert_view.dart';
import 'package:earnwise_app/presentation/features/home/views/expertise_view.dart';
import 'package:earnwise_app/presentation/features/home/views/faq_view.dart';
import 'package:earnwise_app/presentation/features/home/views/reviews_view.dart';
import 'package:earnwise_app/presentation/features/home/views/similar_experts_view.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpertProfileScreen extends ConsumerStatefulWidget {
  const ExpertProfileScreen({super.key, this.expert});

  final ExpertProfileModel? expert;

  @override
  ConsumerState<ExpertProfileScreen> createState() => _ExpertProfileScreenState();
}

class _ExpertProfileScreenState extends ConsumerState<ExpertProfileScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reviewNotifier).getExpertReviews(
        expertId: widget.expert?.id ?? ""
      );
    });
    super.initState();
    
  }

  final List<String> _fallbackImages = const [
    "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&q=80",
    "https://images.unsplash.com/photo-1544723795-3fb6469f5b39?w=400&q=80",
    "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400&q=80",
    "https://images.unsplash.com/photo-1525134479668-1bee5c7c6845?w=400&q=80",
    "https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=400&q=80",
    "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400&q=80",
  ];

  String _randomImageForIndex(int index) {
    final rand = Random(index);
    return _fallbackImages[rand.nextInt(_fallbackImages.length)];
  }
  
  @override
  Widget build(BuildContext context) {
    var firstName = widget.expert?.user?.firstName ?? "";
    var lastName = widget.expert?.user?.lastName ?? "";
    var professionalTitle = widget.expert?.professionalTitle ?? "";
    var rating = widget.expert?.rating ?? 0;
    var reviewsCount = widget.expert?.reviewsCount ?? 0;
    var totalConsultations = widget.expert?.totalConsultations ?? 0;
    var location = widget.expert?.user?.country ?? "";
    var state = widget.expert?.user?.state ?? "";
    
    

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "$firstName $lastName",
          style: TextStyles.largeBold,
        ),
        actions: [
          IconButton(
            onPressed: () {
              
            },
            icon: Icon(Icons.favorite_border),
          ),
          IconButton(
            onPressed: () {
              
            },
            icon: Icon(Icons.share),
          )
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: config.sw(20)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    widget.expert?.user?.profilePicture ?? _randomImageForIndex(0),
                    width: double.infinity,
                    height: config.sh(300),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
              YMargin(20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: config.sw(20)),
                child: Row(
                  children: [
                    Text(
                      "$firstName $lastName",
                      style: TextStyles.h4Bold,
                    ),
                    XMargin(10),
                    Icon(Icons.verified, color: Colors.blue, size: 20),                  
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: config.sw(20)),
                child: Text(
                  professionalTitle,
                  style: TextStyles.largeSemiBold.copyWith(
                    color: Colors.grey
                  ),
                ),
              ),
              YMargin(10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: config.sw(20)),
                child: Row(
                  children: [
                    RatingBar.builder(
                      initialRating: rating,
                      glowColor: Color(0xffFF9F29),
                      allowHalfRating: true,
                      ignoreGestures: true,
                      itemCount: 5,
                      itemSize: 30,
                      itemBuilder: (context, index) => Icon(Icons.star, color: Color(0xffFF9F29)),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                    Text(
                      "${double.parse(rating.toStringAsFixed(2))} ($reviewsCount reviews)",
                      style: TextStyles.largeBold
                    )
                  ],
                ),
              ),
              YMargin(20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: config.sw(20)),
                child: Row(
                children: [
                  Image.asset(
                    "website".png,
                    height: config.sh(20),
                  ),
                  XMargin(10),
                  Image.asset(
                    "instagram".png,
                    height: config.sh(20),
                  ),
                  XMargin(10),
                  Image.asset(
                    "x".png,
                    height: config.sh(20),
                    ),
                  ],
                ),
              ),
              YMargin(20),
              _buildConsultationCard(title: "Typically replies in 3 days", icon: Icons.access_time),
              YMargin(10),
              _buildConsultationCard(title: "$totalConsultations Consultations", icon: Icons.group),
              YMargin(10),
              _buildConsultationCard(title: "${state != "" ? "$state, " : ""}$location", icon: Icons.location_on),
              YMargin(10),
              _buildConsultationCard(title: "100% Response Rate", icon: Icons.check_circle_outline),
              YMargin(10),
              Divider(
                color: Colors.grey.withOpacity(0.2),
                thickness: 1,
              ),

              // About Expert section
              YMargin(20),
              AboutExpertView(
                bio: widget.expert?.bio ?? "",
              ),
              Divider(
                color: Colors.grey.withOpacity(0.2),
                thickness: 1,
              ),

              // Expertise section
              YMargin(20),
              ExpertiseView(
                categories: widget.expert?.categories ?? [],
              ),
              YMargin(20),

              // Faq section
              Divider(
                color: Colors.grey.withOpacity(0.2),
                thickness: 1,
              ),
              YMargin(20),
              FaqView(
                faq: widget.expert?.faq ?? [],
              ),

              // Reviews section
              YMargin(20),
              Divider(
                color: Colors.grey.withOpacity(0.2),
                thickness: 1,
              ),
              YMargin(10),
              ReviewsView(
                expertId: widget.expert?.id ?? "",
              ),

               // Reviews section
              YMargin(20),
              Divider(
                color: Colors.grey.withOpacity(0.2),
                thickness: 1,
              ),

              // Similar experts section
              YMargin(10),
              SimilarExpertsView(),
              YMargin(20)
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: config.sw(10)),
          child: Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  title: "Send Message",
                  subtitle: "\$10 / text",
                  icon: Icons.message,
                  onPressed: () {
                    print("Send Message");
                  }
                )
              ),
              XMargin(10),
              Expanded(
                child: _buildActionButton(
                  title: "Book a Call",
                  subtitle: "\$10 / 15 min",
                  icon: Icons.video_call,
                  onPressed: () {
                    print("Book a Call");
                  }
                )
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildConsultationCard({String? title, IconData? icon}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: config.sw(20)),
      child: Row(
      children: [
        Icon(icon, size: 30),
        XMargin(10),
        Text(
          title ?? "",
            style: TextStyles.largeBold
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({String? title, String? subtitle, IconData? icon, VoidCallback? onPressed}) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: config.sw(10), vertical: config.sh(10)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Palette.primary),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Palette.primary,
              ),
              child: Icon(icon, color: Colors.white),
            ),
            XMargin(10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? "", 
                  textScaler: TextScaler.noScaling,
                  style: TextStyles.mediumBold
                ),
                Text(
                  subtitle ?? "", 
                  textScaler: TextScaler.noScaling,
                  style: TextStyles.largeMedium.copyWith(
                    color: isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light
                  )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}