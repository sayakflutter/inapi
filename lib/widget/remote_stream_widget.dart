import 'package:abc/vc_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:inapi_core_sdk/inapi_core_sdk.dart';
import '../peer_model.dart';

class RemoteStreamWidget extends StatefulWidget {
  const RemoteStreamWidget({
    super.key,
    required this.peer,
  });

  final Peer peer;

  @override
  State<RemoteStreamWidget> createState() => _RemoteStreamWidgetState();
}

class _RemoteStreamWidgetState extends State<RemoteStreamWidget> {
  Peer get peer => widget.peer;
  RTCVideoRenderer? renderer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await initializeRenderer();
    });
  }

  Future<void> initializeRenderer() async {
    if (peer.isScreenSharing == true) {
      // Initialize renderer for screen sharing
      renderer = peer.renderer;
    } else if (!(peer.videoPaused ?? true) && renderer == null) {
      // Initialize renderer for video if not screen sharing
      renderer =
          await InMeetClient.instance.initializeParticipantRenderer(peer.id!);
    }
    setState(() {});
  }

  void updateRenderer() async {
    if (peer.isScreenSharing == true) {
      // Switch to screen share renderer
      renderer = peer.renderer;
    } else if (!(peer.videoPaused ?? true)) {
      // Switch back to video renderer if screen sharing is not active
      renderer =
          await InMeetClient.instance.initializeParticipantRenderer(peer.id!);
    } else if (peer.videoPaused ?? true) {
      // Clear renderer if video is paused
      renderer = null;
    }
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant RemoteStreamWidget oldWidget) {
    updateRenderer();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (renderer != null) {
      renderer!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const aspectRatio = 5 / 3;
    return GetBuilder<VcController>(builder: (controller) {
      bool isHost = peer.roles?.contains(ParticipantRoles.moderator) ?? false;

      // Show video or screen share based on peer's state
      if (!isHost && !(peer.isScreenSharing ?? false)) {
        return const SizedBox(); // If not a host and no screen sharing, return an empty widget
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color.fromARGB(255, 44, 44, 44),
                    // border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Stack(
                    children: [
                      // Show the appropriate renderer: screen share or video
                      renderer == null
                          ? Center(
                              child: Text(
                                '${peer.displayName ?? "User"} (Host)', // Show name with "Host" label
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 40),
                              ),
                            )
                          : RTCVideoView(
                              renderer!,
                              objectFit: RTCVideoViewObjectFit
                                  .RTCVideoViewObjectFitCover,
                            ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Row(
                          children: [
                            if (peer.audioMuted ?? true)
                              const Icon(
                                Icons.mic_off,
                                color: Colors.red,
                              ),
                            const SizedBox(width: 8),
                            if (renderer != null)
                              Text(
                                " ${peer.displayName ?? "User"} (Host)", // Always show name with "Host" label
                                style: const TextStyle(
                                    color: Colors.white,
                                    backgroundColor: Colors.black54),
                              ),
                          ],
                        ),
                      ),
                      if (peer.isHandRaised == true)
                        const Positioned(
                          left: 10,
                          bottom: 10,
                          child: Icon(
                            Icons.back_hand,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
                // Display options only if the user has moderator rights
                if (controller.selfRole.contains(ParticipantRoles.moderator))
                  Positioned(
                    right: 12,
                    top: 12,
                    child: PopupMenuButton(
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child:
                                GetBuilder<VcController>(builder: (controller) {
                              return SwitchListTile(
                                value: controller.peersList[peer.id!]?.roles
                                        ?.contains(
                                            ParticipantRoles.moderator) ??
                                    false,
                                onChanged: (value) {
                                  final inMeetClient = InMeetClient.instance;
                                  if (value) {
                                    inMeetClient.giveRoleToParticipant(
                                        peer.id!, ParticipantRoles.moderator);
                                  } else {
                                    inMeetClient.removeRoleFromParticipant(
                                        peer.id!, ParticipantRoles.moderator);
                                  }
                                },
                                title: const Text('Moderator'),
                              );
                            }),
                          ),
                          PopupMenuItem(
                            child: GetBuilder<VcController>(builder: (context) {
                              return SwitchListTile(
                                value: (controller.peersList[peer.id!]?.roles
                                            ?.contains(
                                                ParticipantRoles.presenter) ??
                                        false) ||
                                    (controller.peersList[peer.id!]?.roles
                                            ?.contains(
                                                ParticipantRoles.moderator) ??
                                        false),
                                onChanged: (value) {
                                  final inMeetClient = InMeetClient.instance;
                                  if (value) {
                                    inMeetClient.giveRoleToParticipant(
                                        peer.id!, ParticipantRoles.presenter);
                                  } else {
                                    inMeetClient.removeRoleFromParticipant(
                                        peer.id!, ParticipantRoles.presenter);
                                  }
                                },
                                title: const Text('Presenter'),
                              );
                            }),
                          ),
                        ];
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
