package com.example.grouvy.chat.mapper;

import com.example.grouvy.chat.dto.ChatRoomDto;
import com.example.grouvy.chat.vo.ChatMessage;
import com.example.grouvy.chat.vo.ChatRoom;
import com.example.grouvy.chat.vo.ChatRoomUser;
import com.example.grouvy.chat.vo.ChatWishList;
import com.example.grouvy.user.vo.User;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ChatMapper {

  /**
   * 전체 부서별 직원 데이터
   * 본부의 부서별 직원 데이터
   * 내가 속한 부서의 직원 데이터
   * @param condition
   * @return
   */
  public List<User> getUserByDepartmentId(Map<String,Object> condition);


  /**
   * 특정 사용자의 아이디로, 그 사용자의 정보를 조회
   *
   * @param userId 사용자의 아이디
   * @return 사용자 이름, 직급명, 부서명, 연락처, 이메일, 사용자 이미지 파일 경로
   */
  public User getUserInfoByUserId(int userId);


  /**
   * 로그인한 사용자와 지정된 사용자의 ID를 사용하여, 두 사용자만 참여한 1:1 채팅방을 조회 후 반환.
   * - 폐기 예정 -
   * @param userId       현재 로그인한 사용자의 ID
   * @param selectUserId 지정된 사용자의 ID
   * @return 1:1 채팅방 반환
   */
  public ChatRoom getRoomByUserId111(@Param("userId") int userId,
      @Param("selectUserId") int selectUserId);


  /**
   * 유저 수와 ,id로 채팅방을 조회한다.
   * 1:1의 경우, is_active를 조건으로 필터링 하면 안된다.
   *      -> 상대방이 나갔을 경우, 그 상대방이 다시 나와 채팅방을 열려면,
   *      -> 전에 사용했던 채팅방을 재활용 해야되기 때문이다.
   *      -> 둘다 나가지 않는 이상, 그 둘의 채팅방은 계속 남아있기 때문이다.
   * 그룹의 경우 , 그룹의 경우 is_active를 조건으로 필터링 해야된다.
   * @return 이 유저들만 포함된 단일의 채팅방 (ChatRoom)
   */
  public ChatRoom getChatRoomByUserId(Map<String,Object>condition);

  /**
   * roomId로 채팅방을 반환
   * @param roomId
   * @return
   */
  public ChatRoom getChatRoomByRoomId(@Param("roomId") int roomId);


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
  public void insertChatRoomUser(int roomId, int userId);


  /**
   * 메세지를 DB에 등록 시킨다.
   *
   * @param chatMessage
   */
  public void insertMessage(ChatMessage chatMessage);

  /**
   * roomId로 이 채팅방에 참여한 참여자 정보를 반환
   *
   * @param condition 채팅방 번호
   * @return 참여자 정보 : userId, name, isActive, roomId
   */
  public List<ChatRoomUser> getChatRoomUserByRoomId(Map<String,Object>condition);

  /**
   * chatMessageId로 실시간으로 수신된 메세지 정보 1개를 반환.
   *
   * @param chatMessageId 메세지 ID
   * @return 1개의 메세지 정보 => messageId, senderId, content, messageType, createdDate,roomId => name,
   * profileImgPath
   */
  public ChatMessage getChatMessage(long chatMessageId);

  /**
   * roomId를 사용하여, 이 채팅방의 메세지 리스트를 가져온다.
   * 단, 사용자의 입장시점(or 재입장 시점)따라 개별적으로 가져온다.
   * @param roomId 채팅방 번호
   * @param userId 사용자 Id
   * @return 메세지 리스트
   */
  public List<ChatMessage> getChatMessageByRoomId(int roomId,int userId);

  /**
   * ChatRoomUser의 상태를 변경한다.
   * @param chatRoomUser
   */
  public void updateChatRoomUser(ChatRoomUser chatRoomUser);

  public void deleteMessage(int roomId);
  public void deleteChatRoomUser(int roomId);
  public void deleteChatRoom(int roomId);

  /**
   * 나의 아이디로, 나의 위시리스틑 ID 목록을 가져온다.
   * @param userId
   * @return
   */
  public List<Integer> getMyWishListIds(int userId);

  /**
   * 위시 리스트에 데이터를 추가한다.
   * @param chatWishList
   */
  public void insertChatWishList(List<ChatWishList> chatWishList);

  /**
   * 이 유저의 위시리스트를 가져온다.
   * @param userId
   * @return
   */
  public List<User> getMyWishListByUserId(int userId);

  /**
   * 메세지를 등록할 때마다 이 유저의 채팅방의 마지막 메세지를 저장한다.
   * @param chatRoom
   */
  public void updateChatRoom(ChatRoom chatRoom);

  /**
   * 이 채팅방의 마지막 메세지 ID를 조회해온다.
   * @param roomId
   * @return
   */
  public long  getLastestMessageIdByRoomId(int roomId);

  /**
   * 채팅방 참여자 테이블의 마지막 메세지 아이디를 변경한다.
   * @param messageId
   */
  public void updateLastReadMessageId(long messageId, int  roomId,  int userId);

  /**
   * 채팅방의 메세지의 읽음&안 읽음 로직에 사용할 채팅 참여자의 userId, lastReadMsgId를 조회
   * @param roomId
   * @return
   */
  public List<ChatRoomUser> getUserIdAndLastReadMsgIdByRoomId(int roomId);

  /**
   * 메세지의 안 읽은 수를 업데이트 한다.
   * @param roomId
   * @param userId
   */
  public void updateUnreadCnt(int roomId, int userId);

  /**
   * 로그인한 사용자가 참여한 채팅방 리스트를 가져온다.
   * @param userId
   * @return
   */
  public List<ChatRoomDto> getChatRoomList(int userId);
}
