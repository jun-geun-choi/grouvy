

function connectNoticeSocket() {
  let stompClient = null;
  const socket = new SockJS('/ws');
  stompClient = Stomp.over(socket);

  stompClient.connect({},function(){                                         // 수신용 웹소켓이 연결이 되면,
    console.log("수신용 웹소켓 연결 완료");
    stompClient.subscribe('/user/queue/messages',function (message){  // 로그인한 사용자의 username이 웹소켓 서버에 저장이 될 것이고,
      const messageData = JSON.parse(message.body);                                // 성공이 되면 다음과 같은 로직이 실시간으로 실행된다.
      console.log(messageData);

      // 전달받은 데이터를 전부 꺼낸다.
      let userName = messageData.name;
      let content = messageData.content;
      let time = messageData.formattedTime;
      let profile = messageData.profileImgPath;
      let roomId = messageData.roomId;
      let roomName = messageData.roomName;
      let isGroup = messageData.isGroup;
      let selectUserId = messageData.senderId;

      const localRoomId = parseInt(localStorage.getItem("currentRoomId"));    // chatting.jsp에서 저장한 현재 채팅방 번호를 꺼낸다. => 100번 or null
      if(roomId == localRoomId) {                                                         // 같을 경우에 는 아래 알림 띄우는 로직을 실행하지 않는다.
        return;
      }

      // 알림 띄우기
      showNotification(userName, content,time,profile,roomId,roomName, isGroup,selectUserId);  //저 username으로
    });
  });

}