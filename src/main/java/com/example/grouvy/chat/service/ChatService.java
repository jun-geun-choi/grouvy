package com.example.grouvy.chat.service;

import com.example.grouvy.chat.dto.ChatMessageDto;
import com.example.grouvy.chat.dto.ChatRoomDto;
import com.example.grouvy.chat.dto.ChatUserInfo;
import com.example.grouvy.chat.dto.DeptAndUserDto;
import com.example.grouvy.chat.dto.ParentDeptDto;
import com.example.grouvy.chat.dto.UserDto;
import com.example.grouvy.chat.mapper.ChatMapper;
import com.example.grouvy.chat.vo.ChatMessage;
import com.example.grouvy.chat.vo.ChatRoom;
import com.example.grouvy.chat.vo.ChatRoomUser;
import com.example.grouvy.chat.vo.ChatWishList;
import com.example.grouvy.department.vo.Department;
import com.example.grouvy.user.vo.User;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class ChatService {

  @Autowired
  private ChatMapper chatMapper;
  @Autowired
  private SimpMessagingTemplate simpMessagingTemplate;

  /**
   * userId롤 유저 1명 정보 반환
   *
   * @param userId
   * @return
   */
  public User getUserByUserId(int userId) {
    return chatMapper.getUserInfoByUserId(userId);
  }

  /**
   * 로그인한 사용자의 경우에 따른 내가 속한 부서의 직원 리스트를 뿌리는 로직. - 대표이사 : 본부 - 하위 부서별 직원 리스트 - 본부장 : 하위 부서별 직원 리스트 -
   * 팀장 ~ 사원 : 본인 부서의 직원 리스트만 반환 로그인한 사용자의 userId로 유저 정보 반환 -> position_name을 추출 -> 직급별로 조건을 걸어 반환값을
   * 정함.
   *
   * @param departmentNo 로그인한 사용자의 부서 Id
   * @param userId       로그인한 사용자의 userId
   * @return
   */
  public List<ParentDeptDto> getMyListByDeptNo(int departmentNo, int userId) {
    User currentUser = chatMapper.getUserInfoByUserId(userId);
    String positionName = currentUser.getPosition().getPositionName();
    //mapper에 전달하기 위한 HashMap 객체 선언
    Map<String, Object> condition = new HashMap<>();

    if ("대표이사".equals(positionName)) {
      condition.put("positionName", positionName);
    } else if ("본부장".equals(positionName)) {
      condition.put("positionName", positionName);
      condition.put("deptId", departmentNo);
    } else      //팀장 ~ 사원의 경우
    {
      condition.put("deptId", departmentNo);
    }

    // 로그인한 사용자에 따라 매퍼 호출..!
    List<User> users = chatMapper.getUserByDepartmentId(condition);

    //key: 본부 이름, value: 하위 부서 Map 객체
    //key: 하위 부서 이름, value: 유저 리스트
    Map<String, Map<String, List<UserDto>>> groupping = new LinkedHashMap<>();

    //쿼리로 조회해온 값을, 반복
    for (User user : users) {
      if (user.getUserId() != userId) {                                             // 본인은 제외
        Department parent = user.getDepartment().getParentDepartment();            //부모 부서
        String parentName = parent != null ? parent.getDepartmentName()
            : "기타";   //부모 부서 이름 = null, 대표이사, 경영본부, 기술본부, 마케팅 본부
        String childName = user.getDepartment()
            .getDepartmentName();               //자식 이름 = 경영본부, 기술본부, 마케팅 본부,총무팀, 회계팀...
        String positon = user.getPosition().getPositionName();

        if (positon.equals(
            "본부장")) {                                                //본부장인 경우, 부모 이름(대표이사)를 자신의 부서 이름으로 변경
          parentName = childName;
        }

        //조회해온 값을 이름별 유저 리스트로 매핑
        groupping.computeIfAbsent(parentName, k -> new LinkedHashMap<>())
            .computeIfAbsent(childName, k -> new ArrayList<>())
            .add(new UserDto(user));
      }
    }

    //이제 리스트에 담아 반환하기
    List<ParentDeptDto> result = new ArrayList<>();
    for (Map.Entry<String, Map<String, List<UserDto>>> parent : groupping.entrySet()) {
      List<DeptAndUserDto> deptAndUserDtos = new ArrayList<>();
      for (Map.Entry<String, List<UserDto>> child : parent.getValue().entrySet()) {
        deptAndUserDtos.add(new DeptAndUserDto(child.getKey(), child.getValue()));
      }
      result.add(new ParentDeptDto(parent.getKey(), deptAndUserDtos));
    }
    return result;
  }

  /**
   * 그냥 부서 정보 전체를 가져온다.
   *
   * @return
   */
  public List<ParentDeptDto> getOrganization() {
    List<ParentDeptDto> list = new ArrayList<>();
    Map<String, Object> condition = new HashMap<>();
    condition.put("positionName", "대표이사");
    List<User> users = chatMapper.getUserByDepartmentId(condition);
    Map<String, Map<String, List<UserDto>>> groupping = new LinkedHashMap<>();

    for (User user : users) {
      Department parent = user.getDepartment().getParentDepartment();
      String parentName = parent != null ? parent.getDepartmentName() : "대표이사 ";
      String childName = user.getDepartment().getDepartmentName();
      String positionName = user.getPosition().getPositionName();

      if (positionName.equals("본부장")) {
        parentName = childName;
      }
      groupping.computeIfAbsent(parentName, k -> new LinkedHashMap<>())
          .computeIfAbsent(childName, k -> new ArrayList<>())
          .add(new UserDto(user));
    }

    for (Map.Entry<String, Map<String, List<UserDto>>> parent : groupping.entrySet()) {
      List<DeptAndUserDto> deptAndUserDtos = new ArrayList<>();
      for (Map.Entry<String, List<UserDto>> child : parent.getValue().entrySet()) {
        deptAndUserDtos.add(new DeptAndUserDto(child.getKey(), child.getValue()));
      }
      list.add(new ParentDeptDto(parent.getKey(), deptAndUserDtos));
    }

    return list;
  }

  public List<ChatRoomDto> getChatRoomList(int userId) {
    List<ChatRoomDto> list = chatMapper.getChatRoomList(userId);
    for(ChatRoomDto dto : list) {
      if(dto.getIsGroup() == "Y") {
        dto.setProfileImgPath("그룹");
      }
      if(dto.getLastMessage() == null) {
        dto.setLastMessage("채팅을 시작하세요!");
      }
    }

    return list;
  }

  /**
   * 나의 위시리스트 목록을 가져온다.
   *
   * @param userId
   * @return
   */
  public List<DeptAndUserDto> getMyWishListByUserId(int userId) {
    List<DeptAndUserDto> list = new ArrayList<>();
    Map<String, List<UserDto>> groupping = new LinkedHashMap<>();
    List<User> users = chatMapper.getMyWishListByUserId(userId);

    for (User user : users) {
      String deptName = user.getDepartment().getDepartmentName();
      groupping.computeIfAbsent(deptName, k -> new ArrayList<>())
          .add(new UserDto(user));
    }

    for (Map.Entry<String, List<UserDto>> child : groupping.entrySet()) {
      list.add(new DeptAndUserDto(child.getKey(), child.getValue()));
    }

    return list;
  }

  /**
   * 특정 사용자 정보를 반환
   *
   * @param userId
   * @return
   */
  public ChatUserInfo getUserInfoByUserId(int userId) {
    User user = chatMapper.getUserInfoByUserId(userId);
    ChatUserInfo chatUserInfo = new ChatUserInfo(user);
    return chatUserInfo;
  }

  /**
   * 사용자들의 id와, 그 인원 수로 채팅방을 조회 해보고, 없으면 새로 만든다.
   *
   * @param
   * @param
   * @return
   */
  public ChatRoom getOrCreateChatRoomByUserId(List<Integer> userIds, String roomName, int userId) {
    Map<String, Object> condition = new HashMap<>();
    if (userIds.size() == 2) {
      condition.put("isActive", "");
      condition.put("userIds", userIds);
      condition.put("listSize", userIds.size());
    }
    if (userIds.size() >= 3) {
      condition.put("isActive", "Y");
      condition.put("userIds", userIds);
      condition.put("listSize", userIds.size());
    }
    // 단일 이냐, 그룹이냐에 따라 채팅방을 불러오자!
    ChatRoom existsRoom = chatMapper.getChatRoomByUserId(condition);

    // 채팅방이 있다면
    if (existsRoom != null) {

      // 그룹이면 그 채팅방을 그대로 반환.
      if (userIds.size() >= 3) {
        return existsRoom;
      }

      // 1:1이면
      if (userIds.size() == 2) {                                       //그게 1:1 이라면,
        int thisRoomId = existsRoom.getRoomId();
        condition.put("roomId", thisRoomId);
        List<ChatRoomUser> users = chatMapper.getChatRoomUserByRoomId(condition);
        for (ChatRoomUser user : users) {
          if (user.getUserId() == userId && "N".equals(user.getIsActive())) {
            user.setIsActive("Y");
            user.setJoinDate(LocalDateTime.now());
            chatMapper.updateChatRoomUser(user);
          }
        }
        return existsRoom;
      } //그 1:1 채팅방을 반환하고
    }

    ChatRoom newRoom = new ChatRoom();
    if (userIds.size() == 2) {
      newRoom.setIsGroup("N");
    } else {
      newRoom.setIsGroup("Y");
      newRoom.setRoomName(roomName);
    }

    // 채팅방과 채팅방 참여자들을 DB에 할당한다.
    chatMapper.insertChatRoom(newRoom);
    for (Integer userId1 : userIds) {
      chatMapper.insertChatRoomUser(newRoom.getRoomId(), userId1);
    }

    // 그 채팅방을 반환한다.
    return newRoom;
  }

//위의 코드랑 합쳐짐.
 /* public ChatRoom getOrCreateGroupChatRoomByUserIds(List<Integer> userIds, String roomName) {

    int listSize = userIds.size();                // 선택된 유저가 몇 명인지 계산.

    for (Integer userId : userIds) {
      if (userId == null) {
        throw new IllegalStateException("선택된 리스트에 null 값이 포함되어 있습니다.");
      }
    }

    ChatRoom existsRoom = chatMapper.getGroupRoomsByUserId(userIds, listSize);
    if (existsRoom != null) {
      return existsRoom;
    }
    ChatRoom newRoom = new ChatRoom();
    newRoom.setIsGroup("Y");
    newRoom.setRoomName(roomName);

    chatMapper.insertChatRoom(newRoom);                             // 채팅방 생성

    for (Integer userId1 : userIds) {
      chatMapper.insertChatRoomUser(newRoom.getRoomId(), userId1);  // 채팅방 참가자 생성
    }

    return newRoom;
  }*/

  /**
   * 채팅방 이동할 때, roomId로 그 채팅방에 대한 정보를 반환 한다.
   *
   * @param roomId
   * @return
   */
  public ChatRoom getChatRoomByRoomId(int roomId) {
    return chatMapper.getChatRoomByRoomId(roomId);
  }

  /**
   * 메세지 DB에 등록 시키기
   *
   * @param chatMessage
   */
  public void insertChatMessage(ChatMessage chatMessage) {
    chatMapper.insertMessage(chatMessage);
  }

  /**
   * roomId로 이 채팅방에 참여 중인 채팅 참여자 정보를 가져온다.
   *
   * @param roomId
   * @return
   */
  public List<ChatRoomUser> getChatRoomUserByRoomId(int roomId) {
    Map<String, Object> condition = new HashMap<>();
    condition.put("roomId", roomId);
    condition.put("isActive", "Y");
    return chatMapper.getChatRoomUserByRoomId(condition);
  }

  /**
   * 이 채팅방의 전체 메세지를 가져온다. - roomId, userId 사용
   * - 먼저 이 채팅방의 가장 최신의 메세지를 가져와서, 로그인한 사용자의 읽은 메세지의 데이터를 변경한다.
   * - 다음 이 채팅방의 메세지들의 unReadCnt를 전부 변경 한다. - roomId를 사용해서 이 메세지의 unreadCnt의 컬럼값을 변경한다.
   * @param roomId
   * @return
   */
  public List<ChatMessageDto>  getChatMessageByRoomId(int roomId, int userId) {
    Long lastestMsgId = chatMapper.getLastestMessageIdByRoomId(roomId);
    if (lastestMsgId != null) {
      chatMapper.updateLastReadMessageId(lastestMsgId, roomId, userId);
      chatMapper.updateUnreadCnt(roomId,userId);

      Map<String, Object> payload = new HashMap<>();
      payload.put("roomId", roomId);
      payload.put("readerId", userId);
      payload.put("readUpTo", lastestMsgId);
      simpMessagingTemplate.convertAndSend("/topic/chat.read?roomId=" + roomId, payload);
    }
    List<ChatMessage> messages = chatMapper.getChatMessageByRoomId(roomId, userId);
    List<ChatMessageDto> list = new ArrayList<>();

    for (ChatMessage message : messages) {
      ChatMessageDto chatMessageDto = new ChatMessageDto(message);
      list.add(chatMessageDto);
    }
    return list;
  }

  // 공부 필요
  public void markRead(int roomId, long readUpTo, int userId) {
    // 1) 이 유저의 last_read_message_id 갱신
    chatMapper.updateLastReadMessageId(readUpTo, roomId, userId);
    // 2) 이 유저가 아니라서 남아있던 메시지들의 UNREAD_CNT 감소 (네가 만든 쿼리 재사용)
    chatMapper.updateUnreadCnt(roomId, userId);
  }



  /**
   * 대화 상대 추가 버튼을 누르면, 부서별 직원 리스트만 반환 부서별 직원 리스트를  가져와 반환한다. - 단, 해당 채팅방에 포함된 유저들은 이 리스트에서 제외시킨다.
   *
   * @return
   */
  public List<DeptAndUserDto> getDeptAndUser(int roomId) {
    // 조건을 담을 Map 생성
    // positionName = "전체" → 모든 직급 대상
    // roomId → 특정 채팅방 ID
    // isActive = "Y" → 현재 활성 상태인 직원만
    Map<String, Object> condition = new HashMap<>();
    condition.put("positionName", "전체");
    condition.put("roomId", roomId);
    condition.put("isActive", "Y");

    // (1) 조건에 맞는 전체 부서별 사용자 목록 조회
    List<User> users = chatMapper.getUserByDepartmentId(condition);

    // (2) 해당 채팅방에 이미 참여 중인 사용자 목록 조회
    List<ChatRoomUser> roomUsers = chatMapper.getChatRoomUserByRoomId(condition);

    // (3) 부서명별로 직원 목록을 담기 위해 LinkedHashMap 사용 (정렬 순서 유지)
    Map<String, List<UserDto>> map = new LinkedHashMap<>();

    // (4) 채팅방에 이미 참여 중인 userId를 Set으로 변환 (검색 속도 ↑)
    Set<Integer> roomUserIds = roomUsers.stream()
        .map(ChatRoomUser::getUserId)
        .collect(Collectors.toSet());

    // (5) 전체 직원 목록 중, 채팅방에 참여하지 않은 직원만 필터링
    List<User> filterUsers = users.stream()
        .filter(user -> !roomUserIds.contains(user.getUserId()))
        .collect(Collectors.toList());

    // (6) 부서명(deptName) 기준으로 Map에 직원(UserDto) 추가
    for (User user : filterUsers) {
      String deptName = user.getDepartment().getDepartmentName();
      // 부서명이 없으면 새 리스트 생성 후 직원 추가
      map.computeIfAbsent(deptName, k -> new ArrayList<>())
          .add(new UserDto(user));
    }

    // (7) Map의 데이터를 DeptAndUserDto 형태로 변환하여 리스트로 반환
    List<DeptAndUserDto> list = new ArrayList<>();
    for (Map.Entry<String, List<UserDto>> entry : map.entrySet()) {
      list.add(new DeptAndUserDto(entry.getKey(), entry.getValue()));
    }

    return list;
  }


  /**
   * "채팅방 나가기 기능" - 먼저 그 채팅방을 조회 하여 참여 중인 참여자들을 가져온다.-> 전체 인원이 1명이면, 그냥 싹다 삭제 - 2명이상일 경우, isActive를
   * N으로 나간 시점 시간을 가져온다.
   *
   * @param roomId
   * @param userId
   */
  public void deleteChatRoomUser(int roomId, int userId) {
    Map<String, Object> condition = new HashMap<>();
    condition.put("roomId", roomId);
    condition.put("isActive", "Y");
    List<ChatRoomUser> chatRoomUsers = chatMapper.getChatRoomUserByRoomId(condition);
    int size = chatRoomUsers.size();
    if (size == 1) {
      chatMapper.deleteMessage(roomId);
      chatMapper.deleteChatRoomUser(roomId);
      chatMapper.deleteChatRoom(roomId);
    }

    for (ChatRoomUser chatRoomUser : chatRoomUsers) {
      if (chatRoomUser.getUserId() == userId) {
        chatRoomUser.setIsActive("N");
        chatRoomUser.setLeftDate(LocalDateTime.now());
        chatMapper.updateChatRoomUser(chatRoomUser);
      }
    }
  }

  /**
   * 1:1 채팅에서만, 채팅 메세지를 보낼 때마다, roomId로 그 채팅방의 유저들을 조회하고, 채팅방을 나간 유저가 있다면, 다시 재입장이 될 수 있도록 한다. -
   * 참여자들을 조회할 때, is_active가 Y,N인 경우 모두 조회해야된다.
   *
   * @param roomId 채팅방 아이디
   */
  public void checkOneToOneChatRoom(int roomId) {
    Map<String, Object> condition = new HashMap<>();
    condition.put("roomId", roomId);
    List<ChatRoomUser> users = chatMapper.getChatRoomUserByRoomId(condition);

    // 어차피 같은 채팅방이므로, 리스트 중 가장 선단에 있는 애를 가져와도 상관 없다.
    String isGroup = users.get(0).getChatRoom().getIsGroup();

    if ("Y".equals(isGroup)) {
      return;
    }

    for (ChatRoomUser user : users) {
      if ("N".equals(user.getIsActive())) {
        user.setIsActive("Y");
        user.setJoinDate(LocalDateTime.now());
        chatMapper.updateChatRoomUser(user);
      }
    }
  }

  /**
   * 친구 추가 버튼을 누르면 DB에 등록하는 로직이다.
   *
   * @param userIds
   * @param userId
   */
  public void addWishList(List<Integer> userIds, int userId) {
    List<Integer> myWishListIds = chatMapper.getMyWishListIds(userId);
    Set<Integer> myWishListIdsSet = new HashSet<>();

    if (myWishListIds != null) {
      myWishListIdsSet.addAll(myWishListIds);
    }

    List<Integer> insertIds = userIds.stream()
        .filter(id -> !myWishListIdsSet.contains(id))
        .filter(id -> id != userId)
        .collect(Collectors.toList());

    if (!insertIds.isEmpty()) {
      List<ChatWishList> wishList = new ArrayList<>();
      for (Integer id : insertIds) {
        ChatWishList chatWishList = new ChatWishList();
        chatWishList.setUserId(userId);
        chatWishList.setSelectedUserId(id);
        chatWishList.setMemo("");
        wishList.add(chatWishList);
      }
      chatMapper.insertChatWishList(wishList);
    }

  }

  /**
   * 메세지를 등록시킬 때, @MessageMapping 메소드에서 ChatMessage 객체를 받아와서, 메시지 테이블 등록 -> 마지막 메세지 채팅방 테이블에 등록 ->
   * 다시 DB에 있는 애 꺼내고 -> DTO 객체 바인딩 후 반환
   *
   * 여기서는 unreadCnt,
   * @param chatMessage : content, roomId, messageType, userId가 자동 바인딩 된 상태.
   * @return
   */
  public ChatMessageDto addMessageService(ChatMessage chatMessage) {
    int userId = chatMessage.getSenderId();
    List<ChatRoomUser> users = chatMapper.getUserIdAndLastReadMsgIdByRoomId(chatMessage.getRoomId());

    int unreadCnt = users.size();
    User user = chatMapper.getUserInfoByUserId(userId);
    chatMessage.setUser(user);
    chatMessage.setUnreadCnt(unreadCnt-1);
    chatMapper.insertMessage(chatMessage);
    ChatMessage newChatMessage = chatMapper.getChatMessage(chatMessage.getChatMessageId());

    ChatRoom chatRoom = chatMapper.getChatRoomByRoomId(chatMessage.getRoomId());
    chatRoom.setLastMessageDate(newChatMessage.getCreatedDate());
    chatRoom.setLastMessageContent(newChatMessage.getContent());
    chatMapper.updateChatRoom(chatRoom);

    ChatMessageDto dto = new ChatMessageDto(newChatMessage);

    return dto;
  }
}