import 'dart:async';
import 'dart:developer';
import 'dart:ffi';

import 'package:abc/getx.dart';
import 'package:abc/peer_model.dart';
import 'package:abc/vc_controller.dart';
import 'package:abc/vc_methods.dart';
import 'package:abc/widget/chatwidget.dart';
import 'package:abc/widget/studentpolling.dart';
import 'package:abc/widget/titlebar/title_bar.dart';
import 'package:abc/youtube/youtubelive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/state_manager.dart';
import 'package:inapi_core_sdk/inapi_core_sdk.dart';
import 'package:intl/intl.dart';

import 'widget/remote_stream_widget.dart';
import 'dart:ui';

class GlassBox extends StatelessWidget {
  final child;
  const GlassBox({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(2),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            alignment: Alignment.bottomCenter,
            child: child,
          ),
        ),
      ),
    );
  }
}

enum Menu { preview, share, getLink, remove, download }

enum AnimationStyles { defaultStyle, custom, none }

const List<(AnimationStyles, String)> animationStyleSegments =
    <(AnimationStyles, String)>[
  (AnimationStyles.defaultStyle, 'Default'),
  (AnimationStyles.custom, 'Custom'),
  (AnimationStyles.none, 'None'),
];

class MeetingPage extends StatefulWidget {
  String? sessionId;
  String userid;
  String username;
  String packageName;
  List<String> args;
  MeetingPage(
      this.sessionId, this.userid, this.username, this.packageName, this.args,
      {super.key});

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  Timer? timer;

  List img = [
    'assets/image9.jpg',
    'assets/image8.jpg',
    'assets/image7.jpg',
    'assets/image6.jpg',
    'assets/image5.jpg',
    'assets/image4.jpg',
    'assets/image3.jpg',
    'assets/image2.jpg',
    'assets/image9.jpg'
  ];

// Styles
  Color deviderColors = const Color.fromARGB(255, 90, 90, 92);
  Color scaffoldColor = const Color(0xff1B1A1D);
  Color topTextColor = const Color(0xffDFDEDF);
  Color topTextClockColor = const Color(0xffB3B6B5);
  Color timerBoxColor = const Color(0xff2B2D2E);
  Color searchBoxColor = const Color(0xff27292D);
  Color searchBoxTextColor = const Color(0xff747677);
  Color bottomBoxColor = const Color(0xff27292B);
  Color micOffColor = const Color(0xffD95140);

  TextEditingController c = TextEditingController();
  String? selectedAudioOutputDevice;
  String? selectedVideoOutputDevice;

  RxBool pollOption = false.obs;

  Future<void> playSound() async {
    // Path to the .opus file in the assets folder
    final soundPath = 'sound.mp3';

    try {
      // Load and play the .opus sound from the assets   await _audioPlayer.play(AssetSource(soundPath));
    } catch (e) {
      print(soundPath);
      print('Error playing sound: $e');
    }
  }

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //   await InMeetClient.instance.getAvailableDeviceInfo();
    //   Get.find<VcController>().assigningRenderer();
    // });
    onUserJoinMeeting();

    super.initState();
  }

  void onUserJoinMeeting() async {
    print(vcController.videoInputs);
    vcController.inMeetClient.init(
      socketUrl: 'wss://wriety.inmeet.ai',
      projectId: widget.args[0], // Project ID from args
      userName: widget.args[1], // Username from args
      userId: widget.args[2], //
      listener: VcEventsAndMethods(vcController: vcController),
    );

    //  final device ;
    // Join the session with the provided session ID
    await vcController.inMeetClient
        .join(sessionId: widget.sessionId.toString());
    // final device =
    //     await InMeetClient.instance.getAvailableDeviceInfo();

    // await InMeetClient.instance.getAvailableDeviceInfo();
    //

    // log(device.toString());
    log(widget.sessionId.toString());
    log(widget.userid.toString());
    log(widget.username.toString());
    await MeetingService.joinMeeting(
        widget.sessionId.toString(), widget.userid.toString(), widget.username);
    print(
        "User ${widget.username} (${widget.userid}) joined the meeting with session ID ${widget.sessionId}.");
  }

  @override
  void dispose() {
    timer?.cancel();
    if (vcController.selfRole.contains(ParticipantRoles.moderator)) {
      inMeetClient.endMeetingForAll();
      inMeetClient.endBreakoutRooms();
      vcController.isBreakoutStarted = false;
    } else {
      inMeetClient.exitMeeting();
      inMeetClient.disableWebcam();

      print('object');
    }
    // Get.delete<VcController>(force: true);
    // vcController.localRenderer?.dispose();
    super.dispose();
  }

  final inMeetClient = InMeetClient.instance;
  VcController vcController = Get.put(VcController());

  RxString time = ''.obs;

  // Styles
  Color leftBackgroundColor = const Color(0Xff161B21);
  Color rightBackgroundColor = const Color(0Xff1F272F);
  Color greencolor = const Color(0Xff15E8D8);
  Color btnColor = const Color(0Xff2D3237);
  Color chatConColor = const Color(0XffD9D9D9);
  Color chatSelectedColor = const Color(0Xff2D3237);
  Color chatUnSelectedColor = const Color(0XffFFFFFF);
  Color chatBoxColor = const Color(0XffC9E1FF);

  var rightBorderRadious = const Radius.circular(20);
  RxInt rightBarIndex = 0.obs;
  RxBool chatMood = true.obs;
  RxBool topicChecValue = true.obs;

  // String _selectedValue = 'Option 1'; // Default selected value
  // List<String> _dropdownItems = ['Option 1', 'Option 2', 'Option 3'];

  Widget showDropdown({
    required BuildContext context,
    required List<String> items,
    required String selectedValue,
    required void Function(String?) onChanged,
  }) {
    return DropdownButton<String>(
      value: selectedValue,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  AnimationStyle? _animationStyle;
  @override
  Widget build(BuildContext context) {
    TextStyle rightBarTopTextStyle = const TextStyle(
        fontFamily: 'ocenwide', color: Colors.white, fontSize: 16);

    final offButtonTheme = IconButton.styleFrom(
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
    );

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 44, 44, 44),
        body: GetBuilder<VcController>(builder: (vcController) {
          if (!vcController.isRoomJoined.value) {
            return Center(
              child: Text(
                'Wait for a moment',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            );
            // playSound();
          }
          return Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    // Left side main screen
                    Positioned.fill(
                        child: Row(
                      children: [
                        // Left

                        Expanded(
                          child: Container(
                            color: leftBackgroundColor,
                          ),
                        ),

                        // Ignore
                        Container(
                          width: 430,
                          color: Colors.transparent,
                        ),
                      ],
                    )),

                    // right side main screen
                    Positioned.fill(
                        child: Row(
                      children: [
                        // Left main screen content

                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Image.asset(
                                      'assets/icons/logo.png',
                                      height: 40,
                                    ),
                                    const SizedBox(
                                      width: 50,
                                    ),
                                    // const Padding(
                                    //     padding: EdgeInsets.only(bottom: 2),
                                    //     child: Icon(
                                    //       Icons.arrow_back_ios_new_rounded,
                                    //       color: Colors.white,
                                    //       size: 15,
                                    //     )),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(widget.packageName.toString(),
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'ocenwide',
                                            color: Colors.white)),
                                    const Expanded(child: SizedBox()),
                                    // Container(
                                    //   padding: const EdgeInsets.symmetric(
                                    //       vertical: 5, horizontal: 10),
                                    //   decoration: BoxDecoration(
                                    //       color: chatConColor.withOpacity(0.3),
                                    //       borderRadius:
                                    //           BorderRadius.circular(20)),
                                    //   child: const Text(
                                    //     '30 : 40 M',
                                    //     style: TextStyle(
                                    //         fontSize: 14,
                                    //         fontFamily: 'ocenwide',
                                    //         color: Colors.white),
                                    //   ),
                                    // ),
                                    const SizedBox(
                                      width: 40,
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(children: [
                                  // YoutubeLive(),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            margin: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: greencolor,
                                                  blurRadius: 12,
                                                ),
                                              ],
                                              border: Border.all(
                                                  width: 5, color: greencolor),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: const Color.fromARGB(
                                                  255, 44, 44, 44),
                                            ),
                                            child: Stack(
                                              children: [
                                                // Display the host's main video (or local video as a fallback)
                                                if (vcController
                                                    .peersList.values
                                                    .any((peer) =>
                                                        (peer.isScreenSharing ??
                                                            false) &&
                                                        (peer.roles?.contains(
                                                                ParticipantRoles
                                                                    .moderator) ??
                                                            false)))
                                                  RemoteStreamWidget(
                                                    peer: vcController
                                                        .peersList.values
                                                        .firstWhere((peer) =>
                                                            (peer.isScreenSharing ??
                                                                false) &&
                                                            (peer.roles?.contains(
                                                                    ParticipantRoles
                                                                        .moderator) ??
                                                                false)),
                                                  )
                                                else if (vcController
                                                    .peersList.values
                                                    .any((peer) =>
                                                        peer.isScreenSharing ??
                                                        false))
                                                  RemoteStreamWidget(
                                                    peer: vcController
                                                        .peersList.values
                                                        .firstWhere((peer) =>
                                                            peer.isScreenSharing ??
                                                            false),
                                                  )
                                                else if (vcController
                                                        .localScreenShare !=
                                                    null)
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                    child: RTCVideoView(
                                                      vcController
                                                          .localScreenShare!,
                                                      objectFit:
                                                          RTCVideoViewObjectFit
                                                              .RTCVideoViewObjectFitCover,
                                                    ),
                                                  )
                                                else if (vcController
                                                        .localRenderer !=
                                                    null)
                                                  RemoteStreamWidget(
                                                    peer: Peer(
                                                      id: 'local', // Dummy peer for local video display
                                                      displayName:
                                                          'You', // Local display name
                                                      renderer: vcController
                                                          .localRenderer,
                                                    ),
                                                  )
                                                else
                                                  Center(
                                                    child: Text(
                                                      InMeetClient
                                                          .instance.userName,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 40,
                                                      ),
                                                    ),
                                                  ),

                                                // Display remote screen share video as an overlay if someone is sharing their screen
                                                if (vcController
                                                    .peersList.values
                                                    .any((peer) =>
                                                        peer.isScreenSharing ??
                                                        false))
                                                  Positioned(
                                                    bottom: 10,
                                                    right:
                                                        10, // Position the overlay in the bottom-right corner
                                                    child: Container(
                                                      width:
                                                          200, // Adjust width for the overlay
                                                      height:
                                                          150, // Adjust height for the overlay
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        border: Border.all(
                                                            color: Colors.white,
                                                            width: 2),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child:
                                                            RemoteStreamWidget(
                                                          peer: vcController
                                                              .peersList.values
                                                              .firstWhere((peer) =>
                                                                  peer.isScreenSharing ??
                                                                  false),
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                // Small Preview of Local Video in Bottom-Right Corner (Overlay)
                                                if (vcController
                                                        .localRenderer !=
                                                    null)
                                                  Positioned(
                                                    bottom: 10,
                                                    right:
                                                        10, // Position at the bottom-right corner
                                                    child: Container(
                                                      width:
                                                          100, // Width of the self-video
                                                      height:
                                                          100, // Height of the self-video
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        border: Border.all(
                                                            color: Colors.white,
                                                            width: 2),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child: RTCVideoView(
                                                          vcController
                                                              .localRenderer!,
                                                          mirror:
                                                              true, // Mirror the local video for self-view
                                                          objectFit:
                                                              RTCVideoViewObjectFit
                                                                  .RTCVideoViewObjectFitCover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 25,
                                        )
                                      ],
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: TextButton(
                                              style: TextButton.styleFrom(
                                                backgroundColor:
                                                    Colors.red[400],
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8)),
                                                ),
                                              ),
                                              onPressed: () {
                                                showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (context) =>
                                                      CustomLogoutDialog(
                                                          index: 0),
                                                ).then((value) =>
                                                    value['id'] == 1
                                                        ? Navigator.pop(context)
                                                        : null);
                                              },
                                              child: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 5),
                                                  child: Text(
                                                    'End meeting',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ))),
                                        ),
                                        const Expanded(
                                            flex: 2, child: SizedBox()),
                                        Row(
                                          children: [
                                            Row(
                                              children: [
                                                PopupMenuButton<String>(
                                                  popUpAnimationStyle:
                                                      _animationStyle,
                                                  icon: const Icon(
                                                    Icons
                                                        .arrow_drop_down_outlined,
                                                    size: 20,
                                                    color: Colors.white,
                                                  ),
                                                  onSelected:
                                                      (String selectedItem) {
                                                    // Handle the selected item
                                                    print(
                                                        'Selected: $selectedItem');
                                                  },
                                                  itemBuilder:
                                                      (BuildContext context) {
                                                    // Create a list of PopupMenuEntry
                                                    List<PopupMenuEntry<String>>
                                                        menuItems = [];

                                                    // Add the audio output items
                                                    menuItems.addAll(
                                                        vcController.audioOutput
                                                            .map((e) {
                                                      return PopupMenuItem<
                                                          String>(
                                                        value: e,
                                                        child: Text(
                                                          e,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'ocenwide',
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      );
                                                    }).toList());

                                                    return menuItems;
                                                  },
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                // Display the small FloatingActionButton if there are audio input or output options
                                                if (vcController.audioInput
                                                        .isNotEmpty ||
                                                    vcController
                                                        .audioOutput.isNotEmpty)
                                                  FloatingActionButton(
                                                      heroTag: 'mic',
                                                      backgroundColor: btnColor,
                                                      onPressed: () {
                                                        try {
                                                          if (vcController
                                                                      .micStreamStatus ==
                                                                  ButtonStatus
                                                                      .off &&
                                                              vcController
                                                                  .audioInput
                                                                  .isNotEmpty) {
                                                            vcController
                                                                .changeMicSreamStatus(
                                                                    ButtonStatus
                                                                        .loading);
                                                            inMeetClient.unmuteMic(
                                                                vcController
                                                                    .selectedAudioInputDeviceId);
                                                          } else if (vcController
                                                              .audioInput
                                                              .isNotEmpty) {
                                                            vcController
                                                                .changeMicSreamStatus(
                                                                    ButtonStatus
                                                                        .loading);
                                                            inMeetClient
                                                                .muteMic();
                                                          }
                                                        } catch (e) {
                                                          // Handle any exceptions here, e.g., show an error message
                                                          print('Error: $e');
                                                        }
                                                      },
                                                      child: vcController
                                                                  .micStreamStatus ==
                                                              ButtonStatus.on
                                                          ? Image(
                                                              image: AssetImage(
                                                                  'assets/microphone.png'),
                                                              height: 20,
                                                            )
                                                          : Image(
                                                              image: AssetImage(
                                                                  'assets/mute.png'),
                                                              height: 20,
                                                            ))
                                                // Otherwise, display the regular FloatingActionButton
                                                else
                                                  FloatingActionButton(
                                                    onPressed: () {
                                                      try {
                                                        if (vcController
                                                                    .micStreamStatus ==
                                                                ButtonStatus
                                                                    .off &&
                                                            vcController
                                                                .audioInput
                                                                .isNotEmpty) {
                                                          vcController
                                                              .changeMicSreamStatus(
                                                                  ButtonStatus
                                                                      .loading);
                                                          inMeetClient.unmuteMic(
                                                              vcController
                                                                  .selectedAudioInputDeviceId);
                                                        } else if (vcController
                                                            .audioInput
                                                            .isNotEmpty) {
                                                          vcController
                                                              .changeMicSreamStatus(
                                                                  ButtonStatus
                                                                      .loading);
                                                          inMeetClient
                                                              .muteMic();
                                                        }
                                                      } catch (e) {
                                                        // Handle any exceptions here, e.g., show an error message
                                                        print('Error: $e');
                                                      }
                                                    },
                                                    backgroundColor: btnColor,
                                                    heroTag: 'btn2',
                                                    child: Image.asset(
                                                      'assets/microphone.png',
                                                      height: 20,
                                                      filterQuality:
                                                          FilterQuality.medium,
                                                      scale: 1,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                PopupMenuButton<String>(
                                                  icon: const Icon(
                                                    Icons
                                                        .arrow_drop_down_outlined,
                                                    size: 20,
                                                    color: Colors.white,
                                                  ),
                                                  onSelected:
                                                      (String selectedItem) {
                                                    // Update the selected video output device
                                                    selectedVideoOutputDevice =
                                                        selectedItem;
                                                    vcController.selectDevice(
                                                        DeviceType.videoInput,
                                                        selectedVideoOutputDevice!);
                                                  },
                                                  itemBuilder:
                                                      (BuildContext context) {
                                                    // Generate the menu items from vcController.videoInputs
                                                    return vcController
                                                        .videoInputs
                                                        .map((e) {
                                                      return PopupMenuItem<
                                                          String>(
                                                        value: e,
                                                        child: Text(
                                                          e,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'ocenwide',
                                                            color: Colors
                                                                .black, // You can adjust the color as needed
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      );
                                                    }).toList();
                                                  },
                                                ),
                                                FloatingActionButton(
                                                    onPressed: () async {
                                                      try {
                                                        log(vcController
                                                            .videoInputs
                                                            .toString());
                                                        vcController
                                                            .changeCameraSreamStatus(
                                                                ButtonStatus
                                                                    .loading);
                                                        if (vcController
                                                                .localRenderer ==
                                                            null) {
                                                          await inMeetClient
                                                              .enableWebcam();
                                                        } else {
                                                          await inMeetClient
                                                              .disableWebcam();
                                                          vcController
                                                                  .localRenderer =
                                                              null;
                                                        }
                                                      } catch (e) {}
                                                    },
                                                    backgroundColor: btnColor,
                                                    heroTag: 'btn3',
                                                    child: vcController
                                                                .localRenderer ==
                                                            null
                                                        ? Image.asset(
                                                            'assets/video-call.png',
                                                            height: 20,
                                                            filterQuality:
                                                                FilterQuality
                                                                    .medium,
                                                            scale: 1)
                                                        : Image.asset(
                                                            'assets/video.png',
                                                            height: 20,
                                                            filterQuality:
                                                                FilterQuality
                                                                    .medium,
                                                            scale: 1)),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                FloatingActionButton(
                                                  onPressed: () {
                                                    vcController.raiseHandSelf(
                                                        !vcController
                                                            .selfHandRaised);
                                                  },
                                                  backgroundColor: btnColor,
                                                  heroTag: 'btn4',
                                                  child: Icon(
                                                    vcController.selfHandRaised
                                                        ? Icons.do_not_touch
                                                        : Icons
                                                            .pan_tool_outlined,
                                                    color: Colors.white,
                                                    weight: 5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const Expanded(
                                            flex: 3, child: SizedBox())
                                      ],
                                    ),
                                  )
                                ]),
                              ),
                            ],
                          ),
                        ),
                        // Right
                        Container(
                          width: 450,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                              color: rightBackgroundColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: rightBorderRadious,
                                  bottomLeft: rightBorderRadious)),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 50,
                              ),
                              Obx(
                                () => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        rightBarIndex.value = 0;
                                      },
                                      child: Text(
                                        'Management',
                                        style: rightBarTopTextStyle.copyWith(
                                            color: rightBarIndex.value == 0
                                                ? greencolor
                                                : null),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        rightBarIndex.value = 1;
                                      },
                                      child: Text(
                                        'Chat',
                                        style: rightBarTopTextStyle.copyWith(
                                            color: rightBarIndex.value == 1
                                                ? greencolor
                                                : null),
                                      ),
                                    ),
                                    // TextButton(
                                    //   onPressed: () {
                                    //     rightBarIndex.value = 2;
                                    //   },
                                    //   child: Text(
                                    //     'Participants',
                                    //     style: rightBarTopTextStyle.copyWith(
                                    //         color: rightBarIndex.value == 2
                                    //             ? greencolor
                                    //             : null),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                              Obx(() => Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        if (rightBarIndex.value == 0)
                                          StudentPollPage(
                                            teacherName: widget.username,
                                            sessionId:
                                                widget.sessionId.toString(),
                                          )
                                        else if (rightBarIndex.value == 1)
                                          ChatUi(
                                            widget.sessionId,
                                            widget.userid,
                                          )
                                        else if (rightBarIndex.value == 2)
                                          vcController.peersList.isNotEmpty ||
                                                  vcController.screenShareList
                                                      .isNotEmpty
                                              ? Expanded(
                                                  child: Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 40,
                                                      ),
                                                      Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 15,
                                                          ),
                                                          Container(
                                                            height: 40,
                                                            width: 80,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                color: Colors
                                                                    .transparent,
                                                                border: Border.all(
                                                                    width: 2,
                                                                    color: Colors
                                                                        .white)),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                Text(
                                                                  "${vcController.peersList.length + 1}",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'ocenwide',
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Expanded(
                                                        child:
                                                            ListView.separated(
                                                          separatorBuilder:
                                                              (context,
                                                                      index) =>
                                                                  const SizedBox(
                                                                      width:
                                                                          10),
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      8.0),
                                                          itemCount: vcController
                                                                  .peersList
                                                                  .length +
                                                              vcController
                                                                  .screenShareList
                                                                  .length +
                                                              2,
                                                          itemBuilder:
                                                              (context, index) {
                                                            if (index == 0) {
                                                              return Visibility(
                                                                visible: false,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              15),
                                                                  child:
                                                                      AspectRatio(
                                                                    aspectRatio:
                                                                        16 / 9,
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              12),
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            border:
                                                                                Border.all(width: 2, color: Colors.white),
                                                                            borderRadius: BorderRadius.circular(12),
                                                                            color: leftBackgroundColor),
                                                                        child: vcController.localRenderer ==
                                                                                null
                                                                            ? Center(
                                                                                child: Text(
                                                                                  InMeetClient.instance.userName,
                                                                                  style: const TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontSize: 40,
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            : RTCVideoView(
                                                                                vcController.localRenderer!,
                                                                                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                                                                              ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }

                                                            if (index == 1) {
                                                              if (vcController
                                                                      .localScreenShare ==
                                                                  null) {
                                                                return const SizedBox();
                                                              }
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            8),
                                                                child:
                                                                    AspectRatio(
                                                                  aspectRatio:
                                                                      16 / 9,
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                    child:
                                                                        Stack(
                                                                      children: [
                                                                        RTCVideoView(
                                                                          vcController
                                                                              .localScreenShare!,
                                                                          objectFit:
                                                                              RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                                                                        ),
                                                                        Container(
                                                                          height:
                                                                              double.infinity,
                                                                          width:
                                                                              double.infinity,
                                                                          color:
                                                                              Colors.black26,
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              const Text(
                                                                            'You are sharing your screen',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 22,
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }

                                                            if (index <
                                                                vcController
                                                                        .peersList
                                                                        .length +
                                                                    2) {
                                                              final peer = vcController
                                                                  .peersList
                                                                  .values
                                                                  .elementAt(index -
                                                                      (vcController
                                                                              .screenShareList
                                                                              .isEmpty
                                                                          ? 0
                                                                          : vcController.screenShareList.length -
                                                                              1) -
                                                                      2);
                                                              return RemoteStreamWidget(
                                                                peer: peer,
                                                              );
                                                            } else {
                                                              final peer = vcController
                                                                      .screenShareList[
                                                                  index -
                                                                      vcController
                                                                          .peersList
                                                                          .length -
                                                                      2];
                                                              return RemoteStreamWidget(
                                                                peer: peer,
                                                              );
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : const SizedBox(),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    )),
                    // Expanded(child: TitleBar()),

                    const Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(height: 45, child: TitleBar()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }));
  }
}
