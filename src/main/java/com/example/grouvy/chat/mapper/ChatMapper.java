package com.example.grouvy.chat.mapper;

import com.example.grouvy.chat.vo.ChatMessage;
import com.example.grouvy.chat.vo.ChatRoom;
import com.example.grouvy.user.vo.User;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ChatMapper {

  /**
   * 로그인한 사용자와 같은 부서의 직원 리스트르 뿌린다. 단, 사용자는 뿌려지지 않는다.
   *
   * @param departmentNo 사용자 부서 번호
   * @param userId       사용자 아이디
   * @return 같은 부서 직원 리스트
   */
  public List<User> getMyListByDeptNo(int departmentNo, int userId);

  /**
   * 특정 사용자의 아이디로, 그 사용자의 정보를 조회
   *
   * @param userId 사용자의 아이디
   * @return 사용자 이름, 직급명, 부서명, 연락처, 이메일, 사용자 이미지 파일 경로
   */
  public User getUserInfoByUserId(int userId);


  /**
   * 로그인한 사용자와 지정된 사용자의 ID를 사용하여, 두 사용자만 참여한 1:1 채팅방을 조회 후 반환.
   *
   * @param userId       현재 로그인한 사용자의 ID
   * @param selectUserId 지정된 사용자의 ID
   * @return 1:1 채팅방 반환
   */
  public ChatRoom getRoomByUserId(@Param("userId") int userId,
      @Param("selectUserId") int selectUserId);

  /**
   * 1:1 채팅방을 만든다.
   *
   * @param chatRoom 전달 받은 채팅방 정보
   */
  public void insertChatRoom(ChatRoom chatRoom);

  /**
   * roomId에 속한 참가자들을 넣는다.
   *
   * @param roomId 채팅방 ID
   * @param userId 위 채팅방에 참가하는 사용자.
   */
  public void insertChatRoomUser(long roomId, int userId);


  /**
   * 메세지를 DB에 등록 시킨다.
   *
   * @param chatMessage
   */
  public void insertMessage(ChatMessage chatMessage);

  /**
   * roomId로 이 채팅방에 참여한 참여자 정보를 반환
   *
   * @param roomId 채팅방 번호
   * @return 참여자 정보 : userId, name
   */
  public List<User> getChatRoomUserByRoomId(int roomId);

  /**
   * chatMessageId로 실시간으로 수신된 메세지 정보 1개를 반환.
   *
   * @param chatMessageId 메세지 ID
   * @return 1개의 메세지 정보 => messageId, senderId, content, messageType, createdDate,roomId => name,
   * profileImgPath
   */
  public ChatMessage getChatMessage(long chatMessageId);

  /**
   * roomId를 사용하여, 이 채팅방의 메세지 정보를 가져온다.
   *
   * @param roomId 채팅방 번호
   * @return 메세지 리스트
   */
  public List<ChatMessage> getChatMessageByRoomId(int roomId);

  /**
   * 대표이사를 제외한 부서별 직원 리스트를 가져온다.
   * @return 직원 리스트
   */
  public List<User> getAllDeptAndUser();

  /**
   *  채팅방에서 선택된 유저 아이디들과, 선택된 유저가 몇 명인지에 대한 정보를 기반으로,
   *  이 유저들만 존재하는 채팅방이 있는지 조회한다.
    * @param userIds 선택된 유저 id
   * @param listSize 선택된 유저가 몇 명인지
   * @return 이 유저들만 포함된 단일의 채팅방 (ChatRoom)
   */
  public ChatRoom getGroupRoomsByUserId(List<Integer> userIds, int listSize);

}
