package com.example.grouvy.chat.service;

import com.example.grouvy.chat.dto.ChatMessageDto;
import com.example.grouvy.chat.dto.ChatMyList;
import com.example.grouvy.chat.dto.ChatUserInfo;
import com.example.grouvy.chat.dto.DeptAndUserDto;
import com.example.grouvy.chat.dto.UserDto;
import com.example.grouvy.chat.mapper.ChatMapper;
import com.example.grouvy.chat.vo.ChatMessage;
import com.example.grouvy.chat.vo.ChatRoom;
import com.example.grouvy.user.vo.User;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class ChatService {

  @Autowired
  private ChatMapper chatMapper;

  public User getUserByUserId(int userId) {
    return chatMapper.getUserInfoByUserId(userId);
  }

  // 사용자와 같은 부서 직원 리스트를 반환.
  public List<ChatMyList> getMyListByDeptNo(int departmentNo, int userId) {
    List<User> users = chatMapper.getMyListByDeptNo(departmentNo, userId);
    List<ChatMyList> list = new ArrayList<ChatMyList>();
    for (User user : users) {
      ChatMyList chatMyList = new ChatMyList(user);
      list.add(chatMyList);
    }
    return list;
  }

  //특정 사용자의 상세 정보를 반환.
  public ChatUserInfo getUserInfoByUserId(int userId) {
    User user = chatMapper.getUserInfoByUserId(userId);
    ChatUserInfo chatUserInfo = new ChatUserInfo(user);
    return chatUserInfo;
  }

  /*
     두 사용자의 id를 사용하여, 두 사용자에 대한 채팅방이 존재하는지 조회하고
     - 존재한다면 조회된 채팅방을 반환하고
     - 없다면 새 채팅방을 만들고, DB에 저장하고,
       참여자도 DB에 저장하고,,
   */
  public ChatRoom getOrCreateChatRoomByUserId(int myUserId, int selectUserId) {
    // 존재하는 조회 및 확인.
    ChatRoom existsRoom = chatMapper.getRoomByUserId(myUserId, selectUserId);
    if (existsRoom != null) {
      return existsRoom;
    }

    ChatRoom newRoom = new ChatRoom();
    newRoom.setIsGroup("N");
    newRoom.setRoomName("");

    // 채팅방과 채팅방 참여자들을 DB에 할당한다.
    chatMapper.insertChatRoom(newRoom);
    chatMapper.insertChatRoomUser(newRoom.getRoomId(), myUserId);
    chatMapper.insertChatRoomUser(newRoom.getRoomId(), selectUserId);

    // 그 채팅방을 반환한다.
    return newRoom;
  }

  //컨트롤러에서 인증된 메세지 객체를 보내서 DB에 등록시키기.
  public void insertChatMessage(ChatMessage chatMessage) {
    chatMapper.insertMessage(chatMessage);
  }

  // roomId로 이 채팅방에 존재하는 유저들의 userId와 name을 가진 User 객체를 리스트로 반환.
  public List<User> getChatRoomUserByRoomId(int roomId) {
    return chatMapper.getChatRoomUserByRoomId(roomId);
  }

  // chatMessageId로 그 단일 메세지에 대한 정보를 메세지 DTO 객체로 반환 받는다.
  public ChatMessageDto getChatMessage(long chatMessageId) {
    ChatMessage message = chatMapper.getChatMessage(chatMessageId);
    ChatMessageDto chatMessageDto = new ChatMessageDto(message);

    return chatMessageDto;
  }

  // roomId를 이용해서 이 채팅방에서 남겨진 메세지에 대한 정보들을 list 형태로 반환받는다.
  public List<ChatMessageDto> getChatMessageByRoomId(int roomId) {
    List<ChatMessage> messages = chatMapper.getChatMessageByRoomId(roomId);
    List<ChatMessageDto> list = new ArrayList<>();

    for (ChatMessage message : messages) {
      ChatMessageDto chatMessageDto = new ChatMessageDto(message);
      list.add(chatMessageDto);
    }
    return list;
  }

  // 부서별로 가져온 직원 리스트를 DTO 객체에 담는다.
  public List<DeptAndUserDto> getDeptAndUser() {
    List<User> users = chatMapper.getAllDeptAndUser();                            // 리스트 형식의 User 객체를 일단 받고,
    Map<String,List<UserDto>> map = new LinkedHashMap<String, List<UserDto>>();   // 부서별 직원들을 저장하기 위해, LinkedMap 형식을 만든 다음

    for (User user : users) {                                                     //user 데이터들을 한 명씩 꺼내서,
      String deptName = user.getDepartment().getDepartmentName();
      UserDto userDto = new UserDto(user);
      map.computeIfAbsent(deptName,k -> new ArrayList<>()).add(userDto);   //부서명(키 값)이 map 안에 없으면, 이 키값으로한 리스트를 만들고,
                                                                                 //이 키 값으로한 리스트가 있다면 그 리스트 안에 userDto를 넣는다.
    }

    List<DeptAndUserDto> list = new ArrayList<>();
    for(Map.Entry<String, List<UserDto>> entry : map.entrySet()) {
      list.add(new  DeptAndUserDto(entry.getKey(),entry.getValue()));
    }
    return list;
  }

  public ChatRoom getOrCreateGroupChatRoomByUserIds(List<Integer> userIds, String roomName) {
    int listSize = userIds.size();                // 선택된 유저가 몇 명인지 계산.

    for(Integer userId : userIds) {
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
  }

}
