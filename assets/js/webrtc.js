const configuration = {
  iceServers: [
    {
      urls: 'stun:stun.l.google.com:19302'
    }
  ]
};


async function createOffeer(channel) {
  const peerConn = new RTCPeerConnection(configuration);

  peerConn.onicecandidate = (event) => {
    if (event.candidate) {
      channel.push("candidate", { ice: event.candidate });
    }
  };
}
