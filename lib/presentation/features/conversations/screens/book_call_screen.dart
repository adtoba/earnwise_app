import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/providers/call_provider.dart';
import 'package:earnwise_app/core/utils/input_validator.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/domain/models/expert_profile_model.dart';
import 'package:earnwise_app/main.dart';
import 'package:earnwise_app/presentation/features/conversations/screens/select_call_time_screen.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/primary_button.dart';
import 'package:earnwise_app/presentation/widgets/search_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class BookCallScreen extends ConsumerStatefulWidget {
  const BookCallScreen({super.key, this.expert});

  final ExpertProfileModel? expert;

  @override
  ConsumerState<BookCallScreen> createState() => _BookCallScreenState();
}

class _BookCallScreenState extends ConsumerState<BookCallScreen> {
  final formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _noteController = TextEditingController();
  final List<int> _durations = const [15, 30, 45, 60];
  int _selectedDuration = 15;
  DateTime _selectedDate = DateTime.now();
  String? _selectedTimeSlot;

  String? scheduledDate;

  @override
  void dispose() {
    _subjectController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var callProvider = ref.watch(callNotifier);
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    final cardColor = isDarkMode ? Palette.darkFillColor : Palette.lightFillColor;
    final borderColor = isDarkMode ? Palette.borderDark : Palette.borderLight;
    final secondaryTextColor = isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Schedule a call',
          style: TextStyles.largeBold
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(16)),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Call details",
                style: TextStyles.largeSemiBold.copyWith(
                  color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                ),
              ),
              YMargin(12),
              SearchTextField(
                controller: _subjectController,
                hint: "Subject",
                validator: InputValidator.validateField,
              ),
              YMargin(10),
              SearchTextField(
                controller: _noteController,
                hint: "Add a short note to the expert",
                maxLines: 5,
                validator: InputValidator.validateField,
              ),
              YMargin(20),
              Text(
                "Call duration",
                style: TextStyles.largeSemiBold.copyWith(
                  color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                ),
              ),
              YMargin(10),
              Wrap(
                spacing: config.sw(10),
                runSpacing: config.sh(8),
                children: _durations.map((duration) {
                  final isSelected = _selectedDuration == duration;
                  return ChoiceChip(
                    label: Text("$duration mins"),
                    selected: isSelected,
                    labelStyle: TextStyles.smallSemiBold.copyWith(
                      color: isSelected
                          ? Colors.white
                          : isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                    ),
                    selectedColor: Palette.primary,
                    backgroundColor: cardColor,
                    checkmarkColor: Colors.white,
                    shape: StadiumBorder(side: BorderSide(color: borderColor)),
                    onSelected: (_) {
                      setState(() {
                        _selectedDuration = duration;
                      });
                    },
                  );
                }).toList(),
              ),
              YMargin(20),
              Text(
                "Select date",
                style: TextStyles.largeSemiBold.copyWith(
                  color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                ),
              ),
              YMargin(10),
              Container(
                // padding: EdgeInsets.all(config.sw(12)),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: CalendarDatePicker(
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  onDateChanged: (date) {
                    setState(() {
                      _selectedDate = date;
                    });

                    String selectedDateStr = date.toIso8601String().split("T").first;
                    String scheduledDateStr = scheduledDate?.split("T").first ?? "";
                    if (selectedDateStr != scheduledDateStr) {
                      setState(() {
                        scheduledDate = null;
                        _selectedTimeSlot = null;
                      });
                    }
                  },
                ),
              ),
              YMargin(20),
              Text(
                "Available times",
                style: TextStyles.largeSemiBold.copyWith(
                  color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                ),
              ),
              YMargin(10),
              InkWell(
                onTap: () async {
                  final selected = await Navigator.push<Map<String, dynamic>>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SelectCallTimeScreen(
                        expertId: widget.expert?.id,
                        selectedDuration: _selectedDuration,
                        selectedTime: _selectedTimeSlot,
                        selectedDate: _selectedDate,
                      ),
                    ),
                  );
                  if (selected != null) {
                    setState(() {
                      scheduledDate = selected["scheduledDate"];
                      _selectedTimeSlot = selected["selectedTime"];
                    });
                  }
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: config.sw(14), vertical: config.sh(14)),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time, color: Palette.primary, size: 18),
                      XMargin(10),
                      Expanded(
                        child: Text(
                          _selectedTimeSlot ?? "Select a time",
                          style: TextStyles.mediumSemiBold.copyWith(
                            color: _selectedTimeSlot == null
                                ? secondaryTextColor
                                : isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                          ),
                        ),
                      ),
                      Icon(Icons.chevron_right, color: secondaryTextColor),
                    ],
                  ),
                ),
              ),
              YMargin(20),
              Text(
                "Video call booking policy",
                style: TextStyles.largeSemiBold.copyWith(
                  color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                ),
              ),
              YMargin(10),
              Container(
                padding: EdgeInsets.all(config.sw(14)),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _PolicyRow(
                      text: "Bookings are confirmed after payment is completed.",
                      textColor: secondaryTextColor,
                    ),
                    YMargin(8),
                    _PolicyRow(
                      text: "You can reschedule up to 24 hours before the call.",
                      textColor: secondaryTextColor,
                    ),
                    YMargin(8),
                    _PolicyRow(
                      text: "Cancelations within 24 hours are not refundable.",
                      textColor: secondaryTextColor,
                    ),
                    YMargin(8),
                    _PolicyRow(
                      text: "Calls are hosted in-app; please be on time.",
                      textColor: secondaryTextColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(16)),
          child: PrimaryButton(
            text: "Book Call",
            isLoading: callProvider.isBookingCall,
            onPressed: () {
              if(formKey.currentState!.validate()) {
                callProvider.bookCall(
                  expertId: widget.expert?.id ?? "", 
                  scheduledDate: scheduledDate ?? "", 
                  subject: _subjectController.text, 
                  note: _noteController.text, 
                  duration: _selectedDuration.toString(),
                );
              }
            },
          )
        )
      ],
    );
  }
}

class _PolicyRow extends StatelessWidget {
  const _PolicyRow({required this.text, required this.textColor});

  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle, size: 16, color: Palette.primary),
        XMargin(8),
        Expanded(
          child: Text(
            text,
            style: TextStyles.smallRegular.copyWith(color: textColor),
          ),
        ),
      ],
    );
  }
}