import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:earnwise_app/core/di/di.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/toast.dart';
import 'package:earnwise_app/domain/models/call_model.dart';
import 'package:earnwise_app/domain/repositories/call_repository.dart';
import 'package:earnwise_app/presentation/features/conversations/screens/video_call_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

final callNotifier = ChangeNotifierProvider((ref) => CallProvider());

class CallProvider extends ChangeNotifier {
  late final CallRepository callRepository;

  CallProvider() {
    callRepository = di.get();
  }

  bool _isBookingCall = false;
  bool get isBookingCall => _isBookingCall;

  bool _isLoadingUserCallHistory = false;
  bool get isLoadingUserCallHistory => _isLoadingUserCallHistory;

  bool _isAcceptingCall = false;
  bool get isAcceptingCall => _isAcceptingCall;

  bool _isGeneratingCallToken = false;
  bool get isGeneratingCallToken => _isGeneratingCallToken;

  List<CallModel> _userCallHistory = [];
  List<CallModel> get userCallHistory => _userCallHistory;

  bool _isLoadingExpertCallHistory = false;
  bool get isLoadingExpertCallHistory => _isLoadingExpertCallHistory;

  List<CallModel> _expertCallHistory = [];
  List<CallModel> get expertCallHistory => _expertCallHistory;

  List<CallModel> _expertHomeCallHistory = [];
  List<CallModel> get expertHomeCallHistory => _expertHomeCallHistory;

  List<CallModel> _pendingExpertCallHistory = [];
  List<CallModel> get pendingExpertCallHistory => _pendingExpertCallHistory;

  Future<void> bookCall({
    required String expertId, 
    required String scheduledDate, 
    required String subject,
    String? note,
    required String duration,
  }) async {
    _isBookingCall = true;
    notifyListeners();

    final result = await callRepository.bookCall(
      expertId: expertId, 
      scheduledDate: scheduledDate, 
      subject: subject,
      note: note,
      duration: duration,
    );

    result.fold(
      (success) {
        _isBookingCall = false;
        notifyListeners();
        showSuccessToast("Call booked successfully");
        pop();
      },
      (failure) {
        _isBookingCall = false;
        notifyListeners();
        showErrorToast(failure);
      }
    );
  }

  Future<void> getUserCallHistory({String? status}) async {
    _userCallHistory = [];
    _isLoadingUserCallHistory = true;
    notifyListeners();

    final result = await callRepository.getUserCallHistory(
      status: status
    );

    result.fold(
      (success) {
        _isLoadingUserCallHistory = false;
        _userCallHistory = success;
        notifyListeners();
      },
      (failure) {
        _isLoadingUserCallHistory = false;
        notifyListeners();
        showErrorToast(failure);
      }
    );
  }

  Future<void> getExpertCallHistory({String? status}) async {
    _expertCallHistory = [];
    _isLoadingExpertCallHistory = true;
    notifyListeners();

    final result = await callRepository.getExpertCallHistory(
      status: status
    );
    
    result.fold(
      (success) {
        _isLoadingExpertCallHistory = false;
        _expertCallHistory = success;
        if(status == "pending") {
          _pendingExpertCallHistory = success;
        }
        if(status == "accepted") {
          _expertHomeCallHistory = success;
        }
        notifyListeners();
      },
      (failure) {
        _isLoadingExpertCallHistory = false;
        notifyListeners();
        showErrorToast(failure);
      }
    );
  }

  Future<void> acceptCall({required String callId}) async {
    _isAcceptingCall = true;
    notifyListeners();

    final result = await callRepository.acceptCall(callId: callId);
    result.fold(
      (success) async {
        _isAcceptingCall = false;
        notifyListeners();
        showSuccessToast("Call accepted successfully");
        await getExpertCallHistory(status: "pending");
      },
      (failure) {
        _isAcceptingCall = false;
        notifyListeners();
        showErrorToast(failure);
      }
    );
  }

  Future<void> generateCallToken({
    required String callId, 
    required bool isUser, 
    required String expertId, 
    required String scheduledAt, 
    required int durationMins, 
    required bool isExpert,
    required String expertName,
    required String userName,
    required String userId,
    required String expertAvatarUrl,
  }) async {
    _isGeneratingCallToken = true;
    notifyListeners();

    final result = await callRepository.generateCallToken(callId: callId, isUser: isUser, expertId: expertId);
    result.fold(
      (success) async {
        _isGeneratingCallToken = false;
        notifyListeners();
        showSuccessToast("Call token generated successfully");

        var channelName = success.data["data"]["channel"];
        var token = success.data["data"]["token"];
        var appId = success.data["data"]["appId"];

        push(VideoCallScreen(
          appId: appId, 
          token: token, 
          channel: channelName,
          scheduledAt: DateTime.parse(scheduledAt),
          durationMins: durationMins,
          isExpert: isExpert,
          expertName: expertName,
          userName: userName,
          expertAvatarUrl: expertAvatarUrl,
          expertId: expertId,
          userId: userId,
        ));
        
      },
      (failure) {
        _isGeneratingCallToken = false;
        notifyListeners();
        showErrorToast(failure);
      }
    );
  }
}