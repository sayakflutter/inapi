import 'dart:async';
import 'dart:developer';

import 'package:abc/vc_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:inapi_core_sdk/inapi_core_sdk.dart';
import 'package:intl/intl.dart';

import 'widget/remote_stream_widget.dart';

class MeetingPage extends StatefulWidget {
  const MeetingPage({super.key});

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  Timer? timer;

  _topleftVideoIcons() {
    // add your function
  }

  // Styles
  Color deviderColors = const Color(0xff444445);
  Color scaffoldColor = const Color(0xff1B1A1D);
  Color topTextColor = const Color(0xffDFDEDF);
  Color topTextClockColor = const Color(0xffB3B6B5);
  Color timerBoxColor = const Color(0xff2B2D2E);
  Color searchBoxColor = const Color(0xff27292D);
  Color searchBoxTextColor = const Color(0xff747677);
  Color bottomBoxColor = const Color(0xff27292B);
  Color micOffColor = const Color(0xffD95140);

  TextEditingController c = TextEditingController();

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      time.value = DateFormat('HH:mm:ss').format(DateTime.now());
    });
    c.text = 'shubha';
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  final inMeetClient = InMeetClient.instance;
  VcController vcController = Get.put(VcController());

  RxString time = ''.obs;

  @override
  Widget build(BuildContext context) {
    final offButtonTheme = IconButton.styleFrom(
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
    );

    const aspectRatio = 5 / 3;

    return Scaffold(
      backgroundColor: scaffoldColor,
      body: GetBuilder<VcController>(
        builder: (vcController) => Column(
          children: [
            // Top section with controls
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(width: 20),
                                  SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: FloatingActionButton(
                                      shape: ContinuousRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      heroTag: 'btn1',
                                      backgroundColor: Colors.blue,
                                      onPressed: _topleftVideoIcons,
                                      child: Image.asset(
                                        'assets/video-camera.png',
                                        color: Colors.white,
                                        width: 18,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Container(
                                    width: 1,
                                    height: 30,
                                    color: deviderColors,
                                    child: const SizedBox(),
                                  ),
                                  const SizedBox(width: 20),
                                  Text(
                                    '(Backlog 03) - Aibo Redesign Landing Page',
                                    style: TextStyle(
                                      color: topTextColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: timerBoxColor,
                                    ),
                                    child: Obx(() {
                                      List<String> timeParts =
                                          time.value.split(':');
                                      if (timeParts.length != 3) {
                                        return const Text(
                                          'Please Wait',
                                        );
                                      }
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            timeParts[0],
                                            style: TextStyle(
                                              color: topTextColor,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            ':',
                                            style: TextStyle(
                                              color: topTextColor,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            timeParts[1],
                                            style: TextStyle(
                                              color: topTextColor,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            ':',
                                            style: TextStyle(
                                              color: topTextColor,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            timeParts[2],
                                            style: TextStyle(
                                              color: topTextColor,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 200,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 11,
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: searchBoxColor,
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          ImageIcon(
                                            const AssetImage(
                                                'assets/search.png'),
                                            color: topTextColor,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            'Search message...',
                                            style: TextStyle(
                                              color: searchBoxTextColor,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: SizedBox(
                                      height: 42,
                                      width: 42,
                                      child: Image.asset(
                                        'assets/girl_dp.jpg',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  IconButton(
                                    onPressed: () {
                                      vcController.inMeetClient.hosts
                                          .map((e) => print(e.role));
                                    },
                                    icon: const Icon(
                                      Icons.arrow_drop_down_rounded,
                                      size: 30,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    color: deviderColors,
                    child: const SizedBox(),
                  ),
                ),
              ],
            ),
            // Middle section
            if (!vcController.isRoomJoined.value)
              Container(
                child: const Center(
                  child: Text("Entering into Room"),
                ),
              )
            else
              Expanded(
                child: Container(
                  child: GridView.builder(
                    itemCount: vcController.peersList.length +
                        vcController.screenShareList.length +
                        2,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: vcController.peersList.length +
                          vcController.screenShareList.length +
                          2,
                    ),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.lightBlueAccent.shade100,
                              ),
                              child: vcController.localRenderer == null
                                  ? Center(
                                      child: Text(
                                        InMeetClient.instance.userName,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 40,
                                        ),
                                      ),
                                    )
                                  : RTCVideoView(
                                      vcController.localRenderer!,
                                      objectFit: RTCVideoViewObjectFit
                                          .RTCVideoViewObjectFitCover,
                                    ),
                            ),
                          ),
                        );
                      }
                      if (index == 1) {
                        if (vcController.localScreenShare == null) {
                          return Container(
                            width: 10,
                            height: 10,
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              children: [
                                RTCVideoView(
                                  vcController.localScreenShare!,
                                  objectFit: RTCVideoViewObjectFit
                                      .RTCVideoViewObjectFitContain,
                                  mirror: false,
                                  placeholderBuilder: (context) => Text('data'),
                                ),
                                Container(
                                  height: double.infinity,
                                  color: Colors.black26,
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'You are sharing your screen',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      log(vcController.peersList.length.toString());
                      if (index < vcController.peersList.length + 2) {
                        final peer = vcController.peersList.values.elementAt(
                          index -
                              (vcController.screenShareList.isEmpty
                                  ? 0
                                  : vcController.screenShareList.length - 1) -
                              2,
                        );
                        return RemoteStreamWidget(
                          peer: peer,
                          isScreenShare: false,
                        );
                      }
                      final peer = vcController.screenShareList[
                          index - vcController.peersList.length - 2];
                      return RemoteStreamWidget(
                        peer: peer,
                        isScreenShare: false,
                      );
                    },
                  ),
                ),
              ),
            SizedBox(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 20),
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(10),
                          color: bottomBoxColor,
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: SizedBox(
                                width: 90,
                                child: TextField(
                                  controller: c,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: topTextClockColor),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              color: deviderColors,
                              width: 1.5,
                              height: 30,
                              child: const SizedBox(),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.copy_rounded,
                                color: topTextClockColor,
                              ),
                            ),
                            const SizedBox(width: 5),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (vcController.audioInput.isNotEmpty ||
                          vcController.audioOutput.isNotEmpty)
                        FloatingActionButton.small(
                          shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          heroTag: 'mic',
                          backgroundColor: micOffColor,
                          onPressed: () {
                            if (vcController.micStreamStatus ==
                                    ButtonStatus.off &&
                                vcController.audioInput.isNotEmpty) {
                              vcController
                                  .changeMicSreamStatus(ButtonStatus.loading);
                              inMeetClient.unmuteMic(
                                  vcController.selectedAudioInputDeviceId);
                            } else if (vcController.audioInput.isNotEmpty) {
                              vcController
                                  .changeMicSreamStatus(ButtonStatus.loading);
                              inMeetClient.muteMic();
                            }
                          },
                          child: Icon(
                            vcController.micStreamStatus == ButtonStatus.on
                                ? Icons.mic_outlined
                                : Icons.mic_off_outlined,
                            color: Colors.white,
                          ),
                        ),
                      const SizedBox(width: 12),
                      FloatingActionButton.small(
                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        heroTag: 'video',
                        backgroundColor:
                            vcController.cameraStreamStatus == ButtonStatus.off
                                ? Colors.red
                                : bottomBoxColor,
                        onPressed: () async {
                          vcController
                              .changeCameraSreamStatus(ButtonStatus.loading);
                          if (vcController.localRenderer == null) {
                            await inMeetClient.enableWebCam(
                                vcController.selectedVideoInputDeviceId);
                          } else {
                            await inMeetClient.disableWebcam();
                            vcController.localRenderer = null;
                          }
                        },
                        child:
                            vcController.cameraStreamStatus == ButtonStatus.on
                                ? const Icon(
                                    Icons.videocam,
                                    color: Colors.white,
                                  )
                                : const Icon(
                                    Icons.videocam_off,
                                    color: Colors.white,
                                  ),
                      ),
                      const SizedBox(width: 12),
                      if (vcController.screenShareStatus != ButtonStatus.off)
                        FloatingActionButton.small(
                          shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          heroTag: 'screen',
                          backgroundColor: bottomBoxColor,
                          onPressed: vcController.screenShareStatus ==
                                  ButtonStatus.loading
                              ? null
                              : () {
                                  vcController.stopScreenShare();
                                },
                          child: const Icon(
                            Icons.stop_screen_share,
                            color: Colors.white,
                          ),
                        )
                      else
                        FloatingActionButton.small(
                          shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          heroTag: 'screen',
                          backgroundColor: bottomBoxColor,
                          onPressed: vcController.screenShareStatus ==
                                  ButtonStatus.loading
                              ? null
                              : () {
                                  vcController.screenShare();
                                },
                          child: const Icon(
                            Icons.screen_share_outlined,
                            color: Colors.white,
                          ),
                        ),
                      const SizedBox(width: 12),
                      FloatingActionButton.small(
                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        heroTag: 'more',
                        backgroundColor: bottomBoxColor,
                        onPressed: () {},
                        child: const Icon(
                          Icons.more_horiz_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SizedBox(
                          width: 100,
                          height: 45,
                          child: FloatingActionButton(
                            heroTag: 'End Meeting',
                            shape: ContinuousRectangleBorder(
                                borderRadius:
                                    BorderRadiusDirectional.circular(12)),
                            onPressed: () {
                              // if (vcController.selfRole
                              //     .contains(ParticipantRoles.moderator)) {
                              inMeetClient.endMeetingForAll();
                              inMeetClient.endBreakoutRooms();
                              vcController.isBreakoutStarted = false;
                              vcController.peersList.forEach((key, value) {
                                print(key);
                              });
                              // vcController.peersList.forEach((peerId, peer) {
                              //   log(peerId);
                              //   if (peer.renderer != null) {
                              //     // Null check
                              //     vcController.inMeetClient
                              //         .disposeParticipantRenderer(
                              //             peerId, peer.renderer!);
                              //   }
                              // });
                              // } else {
                              //   inMeetClient.exitMeeting();
                              // }
                              // Get.delete<VcController>(force: true);
                              // Get.back();
                            },
                            backgroundColor: micOffColor,
                            child: const Text(
                              'End Meeting',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
