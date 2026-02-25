import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/providers/expert_provider.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';

class SelectCallTimeScreen extends ConsumerStatefulWidget {
  const SelectCallTimeScreen({
    super.key,
    this.selectedDuration,
    this.selectedTime,
    this.expertId,
    required this.selectedDate,
  });
  final String? expertId;
  final String? selectedTime;
  final int? selectedDuration;
  final DateTime selectedDate;

  @override
  ConsumerState<SelectCallTimeScreen> createState() => _SelectCallTimeScreenState();
}

class _SelectCallTimeScreenState extends ConsumerState<SelectCallTimeScreen> {
  
  String? _selectedTime;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(expertNotifier).getExpertAvailableSlots(
        expertId: widget.expertId ?? "", 
        date: widget.selectedDate.toIso8601String().split("T").first, 
        duration: widget.selectedDuration ?? 15
      );

      setState(() {
        _selectedTime = widget.selectedTime;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var expertProvider = ref.watch(expertNotifier);
    var availableSlots = expertProvider.availableSlots;
    var isAvailableSlotsLoading = expertProvider.isAvailableSlotsLoading;
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    final cardColor = isDarkMode ? Palette.darkFillColor : Palette.lightFillColor;
    final borderColor = isDarkMode ? Palette.borderDark : Palette.borderLight;
    final secondaryTextColor = isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Select Time",
          style: TextStyles.largeBold,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Available times",
              style: TextStyles.largeSemiBold.copyWith(
                color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
              ),
            ),
            YMargin(4),
            Text(
              "Choose a time for ${widget.selectedDate.toLocal().toString().split(' ').first}",
              style: TextStyles.smallRegular.copyWith(color: secondaryTextColor),
            ),
            YMargin(16),
            Expanded(
              child: isAvailableSlotsLoading 
                ? const Center(child: CircularProgressIndicator()) 
                : availableSlots.isEmpty 
                ? const Center(child: Text("No available slots")) 
                : ListView.separated(
                    itemCount: availableSlots.length,
                    separatorBuilder: (_, _) => YMargin(10),
                    itemBuilder: (context, index) {
                      final start = availableSlots[index].start ?? "";
                      final end = availableSlots[index].end ?? "";

                      final startDate = DateTime.parse(start).toLocal();
                      final endDate = DateTime.parse(end).toLocal();

                      final text = "${Jiffy.parse(startDate.toIso8601String()).format(pattern: "hh:mm a")} - ${Jiffy.parse(endDate.toIso8601String()).format(pattern: "hh:mm a")}";

                      final isSelected = text == _selectedTime;

                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedTime = text;
                          });
                          Navigator.pop(context, {
                            "scheduledDate": startDate.toIso8601String(),
                            "selectedTime": text
                          });
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: config.sw(14), vertical: config.sh(14)),
                          decoration: BoxDecoration(
                            color: isSelected ? Palette.primary.withOpacity(0.1) : cardColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected ? Palette.primary : borderColor,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 18,
                                color: isSelected ? Palette.primary : secondaryTextColor,
                              ),
                              XMargin(10),
                              Expanded(
                                child: Text(
                                  text,
                                  style: TextStyles.mediumSemiBold.copyWith(
                                    color: isSelected
                                        ? Palette.primary
                                        : isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Icon(Icons.check_circle, color: Palette.primary, size: 18),
                            ],
                          ),
                        ),
                      );
                    },
                ),
            ),
          ],
        ),
      ),
    );
  }
}
