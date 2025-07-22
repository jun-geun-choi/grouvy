package com.example.grouvy.chat.service;

import com.example.grouvy.chat.dto.ChatMyList;
import com.example.grouvy.chat.dto.ChatUserInfo;
import com.example.grouvy.chat.mapper.ChatMapper;
import com.example.grouvy.user.vo.User;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class ChatService {
  @Autowired
  private ChatMapper  chatMapper;

  // 사용자와 같은 부서 직원 리스트를 반환.
  public List<ChatMyList> getMyListByDeptNo(int departmentNo,int userId) {
    List<User> users =  chatMapper.getMyListByDeptNo(departmentNo,userId);
    List<ChatMyList> list = new ArrayList<ChatMyList>();
    for (User user : users) {
      ChatMyList chatMyList = new ChatMyList(user);
      list.add(chatMyList);
    }
    return list;
  }

  //특정 사용자의 상세 정보를 반환.
  public ChatUserInfo getUserInfoByUserId(int userId) {
    User user =  chatMapper.getUserInfoByUserId(userId);
    ChatUserInfo chatUserInfo = new ChatUserInfo(user);
    return chatUserInfo;
  }

  /* 두 사용자의 ID로 1:1 채팅방이 존재하는지 확인.
     있을 경우, 그 채팅방 ID를 반환

     없다면, 상대방 아이디를 이름으로한 채팅방을 만들고, 그 채팅방에 두 사용자를 추가한 다음.
     새롭게 만든 채팅방의 아이디를 반환
   */
  public int getRoomIdByUserId(int myUserId, int selectUserId) {
    Optional<Integer> optional = chatMapper.getChatRoomIdByUserId(myUserId,selectUserId);
    if (optional.isPresent()) {
      return optional.get();
    }

    User selectUser =  chatMapper.getUserInfoByUserId(selectUserId);
    int roomId = chatMapper.getRoomId();
    chatMapper.insertRoom(roomId, selectUser.getName());

    chatMapper.insertChatRoomUser(roomId, myUserId);
    chatMapper.insertChatRoomUser(roomId, selectUserId);

    return roomId;
  }

}
