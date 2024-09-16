enum SocketNotifications {
  roomReady,
  roomBack,
  newConsumer,
  consumerClosed,
  consumerPaused,
  consumerResumed,
  newPeer,
  peerClosed,
  activeSpeaker,
  gotRole,
  lostRole,
  moderatorKick,
  cloudRecordingStatus,
  cloudRecordingError,
  breakoutJoin,
  handleBrToMrByHost,
  closeBreakoutRoomToMainRoom,
  breakoutRoomIsStopped,
  setPeerToBrRoomList,
  peerLeaveOrCloseInBrRoom,
  mainRoomPeerJoin,
  sendPeerShareRequest,
  moderatorMuteMic,
  moderatorStopVideo,
  moderatorStopScreenShare,
  raisedHand,
  requestPeerVideoOrAudio,
  setHostControls,
}

Map<String, SocketNotifications> stringToSocketNotifications = {
  "roomReady": SocketNotifications.roomReady,
  "roomBack": SocketNotifications.roomBack,
  "newConsumer": SocketNotifications.newConsumer,
  "consumerClosed": SocketNotifications.consumerClosed,
  "consumerPaused": SocketNotifications.consumerPaused,
  "consumerResumed": SocketNotifications.consumerResumed,
  "newPeer": SocketNotifications.newPeer,
  "peerClosed": SocketNotifications.peerClosed,
  "activeSpeaker": SocketNotifications.activeSpeaker,
  "gotRole": SocketNotifications.gotRole,
  "lostRole": SocketNotifications.lostRole,
  'moderator:kick': SocketNotifications.moderatorKick,
  'cloudRecordingStatus': SocketNotifications.cloudRecordingStatus,
  'startRecordingError': SocketNotifications.cloudRecordingError,
  'breakoutjoin': SocketNotifications.breakoutJoin,
  'handleBrToMrByHost': SocketNotifications.handleBrToMrByHost,
  'closeBreakoutRoomToMainRoom':
      SocketNotifications.closeBreakoutRoomToMainRoom,
  'breakoutRoomIsStopped': SocketNotifications.breakoutRoomIsStopped,
  'setPeerToBrRoomList': SocketNotifications.setPeerToBrRoomList,
  'peerLeaveOrCloseInBrRoom': SocketNotifications.peerLeaveOrCloseInBrRoom,
  'mainRoomPeerJoin': SocketNotifications.mainRoomPeerJoin,
  'sendPeerShareRequest': SocketNotifications.sendPeerShareRequest,
  'moderator:stopVideo': SocketNotifications.moderatorStopVideo,
  'moderator:mute': SocketNotifications.moderatorMuteMic,
  'moderator:stopScreenSharing': SocketNotifications.moderatorStopScreenShare,
  'raisedHand': SocketNotifications.raisedHand,
  'moderator:requestPeerVideoOrAudio':
      SocketNotifications.requestPeerVideoOrAudio,
  'setHostControls': SocketNotifications.setHostControls,
};
