import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/toast.dart';
import 'package:earnwise_app/presentation/features/rating/screens/rate_expert_screen.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({
    super.key,
    required this.appId,
    required this.token,
    required this.channel,
    this.scheduledAt,
    this.durationMins,
    this.isExpert = false,
    this.expertName,
    this.expertAvatarUrl,
    this.expertId,
    this.userId,
    this.userName,
  });

  final String appId;
  final String token;
  final String channel;
  final DateTime? scheduledAt;
  final int? durationMins;
  final bool? isExpert;
  final String? expertName;
  final String? userName;
  final String? expertAvatarUrl;
  final String? expertId;
  final String? userId;
  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  static const Duration _initialCountdown = Duration(minutes: 30);

  late final RtcEngine _engine;

  int? _remoteUid;
  bool _localUserJoined = false;
  bool _isMicMuted = false;
  bool _isVideoMuted = false;
  bool _isUsingFrontCamera = true;
  bool _isLocalFullScreen = false;
  bool _isRemoteVideoMuted = false;
  bool _isEndingCall = false;
  bool _didShowTwoMinuteWarning = false;

  Timer? _countdownTimer;
  Duration _remaining = _initialCountdown;

  @override
  void initState() {
    super.initState();
    _initAgora();
    _initializeCountdown();
  }

  Future<void> _initAgora() async {
    await [Permission.microphone, Permission.camera].request();

    _engine = createAgoraRtcEngine();

    await _engine.initialize(
      RtcEngineContext(
        appId: widget.appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );

    await _engine.setClientRole(
      role: ClientRoleType.clientRoleBroadcaster,
    );

    // Hardware acceleration
    await _engine.setParameters('{"che.video.hwdec":true}');
    await _engine.setParameters('{"che.video.hwenc":true}');
    await _engine.setParameters(
      '{"rtc.region":"AF"}'
    );
    await _engine.setParameters(
        '{"rtc.video.degradation_preference":2}');
    await _engine.setParameters(
      '{"rtc.enable_fec":true}',
    );

    await _engine.enableVideo();

    // High quality voice (important for consultations)
    await _engine.setAudioProfile(
      profile: AudioProfileType.audioProfileMusicHighQuality,
      scenario: AudioScenarioType.audioScenarioChatroom,
    );

    // Force 720p capture
    await _engine.setCameraCapturerConfiguration(
      const CameraCapturerConfiguration(
        // dimensions: VideoDimensions(width: 1280, height: 720),
        cameraDirection: CameraDirection.cameraFront,
      ),
    );

    // Optimized encoder config
    await _engine.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 960, height: 540),
        frameRate: 20,
        bitrate: 0,
        // bitrate: 1100,
        // minBitrate: 500,
        orientationMode: OrientationMode.orientationModeAdaptive,
      ),
    );

    await _engine.enableDualStreamMode(enabled: true);

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          setState(() => _localUserJoined = true);
        },
        onUserJoined: (connection, remoteUid, elapsed) async {
          setState(() => _remoteUid = remoteUid);

          await _engine.setRemoteVideoStreamType(
            uid: remoteUid,
            streamType: VideoStreamType.videoStreamHigh,
          );
        },
        onUserMuteVideo: (connection, remoteUid, muted) {
          if(remoteUid == _remoteUid) {
            setState(() => _isRemoteVideoMuted = muted);
          }
        },
        onUserOffline: (connection, remoteUid, reason) {
          setState(() => _remoteUid = null);
        },
        onNetworkQuality: (connection, txQuality, rxQuality, rxQuality2) async {
          if (_remoteUid != null) {
            if (rxQuality.index >= 4) {
              await _engine.setRemoteVideoStreamType(
                uid: _remoteUid!,
                streamType: VideoStreamType.videoStreamLow,
              );
            } else {
              await _engine.setRemoteVideoStreamType(
                uid: _remoteUid!,
                streamType: VideoStreamType.videoStreamHigh,
              );
            }
          }
        },
      ),
    );

    await _engine.startPreview();

    await _engine.joinChannel(
      token: widget.token,
      channelId: widget.channel,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _leaveChannel();
    super.dispose();
  }

  Future<void> _leaveChannel() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  Future<void> _endCall({bool showTimeEndedToast = false}) async {
    if (_isEndingCall) return;
    _isEndingCall = true;
    _countdownTimer?.cancel();
    await _leaveChannel();
    if (showTimeEndedToast) {
      showWarningToast("Call time has ended");
      await Future.delayed(const Duration(milliseconds: 800));
    }
    if (mounted) {
      Navigator.of(context).pop();

      if(widget.isExpert == false) {
        push(RateExpertScreen(
          expertName: widget.expertName,
          expertAvatarUrl: widget.expertAvatarUrl,
          userName: widget.userName,
          expertId: widget.expertId,
          userId: widget.userId,
        ));
      }
      
    }
  }

  void _initializeCountdown() {
    var initial = _initialCountdown;
    if (widget.scheduledAt != null && widget.durationMins != null) {
      final scheduledLocal = widget.scheduledAt!.toLocal();
      final endTime =
          scheduledLocal.add(Duration(minutes: widget.durationMins!));
      final diff = endTime.difference(DateTime.now());
      initial = diff.isNegative ? Duration.zero : diff;
    }

    _startCountdown(initial);
  }

  void _startCountdown(Duration initial) {
    _countdownTimer?.cancel();
    _remaining = initial;

    _countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining.inSeconds <= 1) {
        timer.cancel();
        if (mounted) {
          setState(() => _remaining = Duration.zero);
        }
        _endCall(showTimeEndedToast: true);
        return;
      }
      if (!_didShowTwoMinuteWarning &&
          _remaining.inSeconds <= 120 &&
          _remaining.inSeconds > 0) {
        _didShowTwoMinuteWarning = true;
        showWarningToast("2 minutes remaining");
      }
      if (mounted) {
        setState(() {
          _remaining -= const Duration(seconds: 1);
        });
      }
    });
  }

  Future<void> _toggleMic() async {
    final next = !_isMicMuted;
    await _engine.muteLocalAudioStream(next);
    setState(() => _isMicMuted = next);
  }

  Future<void> _toggleVideo() async {
    final next = !_isVideoMuted;
    await _engine.muteLocalVideoStream(next);
    setState(() => _isVideoMuted = next);
  }

  Future<void> _switchCamera() async {
    await _engine.switchCamera();
    setState(() => _isUsingFrontCamera = !_isUsingFrontCamera);
  }

  String _formatCountdown(Duration duration) {
    final minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                if (_isLocalFullScreen) {
                  setState(() => _isLocalFullScreen = false);
                }
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isLocalFullScreen
                    ? _localVideoView(fullScreen: true)
                    : _remoteVideoView(),
              ),
            ),
          ),

          // Small overlay
          Positioned(
            right: 16,
            top: 90,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isLocalFullScreen = !_isLocalFullScreen;
                });
              },
              child: Container(
                width: 110,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white24),
                ),
                clipBehavior: Clip.antiAlias,
                child: _isLocalFullScreen
                    ? _remoteVideoView()
                    : _localVideoView(),
              ),
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _topBar(),
          ),
          _bottomControls(),
        ],
      ),
    );
  }

  Widget _localVideoView({bool fullScreen = false}) {
    if (!_localUserJoined || _isVideoMuted) {
      return const Center(
        child: Icon(Icons.videocam_off, color: Colors.white70),
      );
    }

    return AgoraVideoView(
      key: const ValueKey('local'),
      controller: VideoViewController(
        rtcEngine: _engine,
        canvas: const VideoCanvas(uid: 0),
      ),
    );
  }

  Widget _remoteVideoView() {
    if (_remoteUid != null) {
      return AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: _isRemoteVideoMuted
          ? _remoteVideoOffPlaceholder()
          : AgoraVideoView(
            key: const ValueKey('remote'),
            controller: VideoViewController.remote(
              rtcEngine: _engine,
              canvas: VideoCanvas(uid: _remoteUid),
              connection: RtcConnection(channelId: widget.channel),
            ),
          ),
      );
    }

    return Center(
      child: Text(
        'Waiting for the other participant...',
        textScaler: TextScaler.noScaling,
        textAlign: TextAlign.center,
        style: TextStyles.mediumRegular,
      ),
    );
  }

  Widget _remoteVideoOffPlaceholder() {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.white24,
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Camera is off",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return SafeArea(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: _circleBtn(
                  Icons.arrow_back,
                  () => Navigator.pop(context),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _formatCountdown(_remaining),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomControls() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,
            children: [
              _circleBtn(
                  _isMicMuted ? Icons.mic_off : Icons.mic,
                  _toggleMic),
              _circleBtn(
                  _isVideoMuted
                      ? Icons.videocam_off
                      : Icons.videocam,
                  _toggleVideo),
              _circleBtn(Icons.cameraswitch,
                  _switchCamera),
              _circleBtn(
                Icons.call_end,
                _endCall,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap,
      {Color? color}) {
    return InkResponse(
      onTap: onTap,
      child: CircleAvatar(
        radius: 26,
        backgroundColor:
            color ?? Colors.black.withOpacity(0.6),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}