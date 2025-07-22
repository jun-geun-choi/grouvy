package com.example.grouvy.chat.mapper;

import com.example.grouvy.user.vo.User;
import java.util.List;
import java.util.Optional;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ChatMapper {

  /**
   * 로그인한 사용자와 같은 부서의 직원 리스트르 뿌린다.
   * 단, 사용자는 뿌려지지 않는다.
   * @param departmentNo 사용자 부서 번호
   * @param userId 사용자 아이디
   * @return 같은 부서 직원 리스트
   */
  public List<User> getMyListByDeptNo(int departmentNo, int userId);

  /**
   * 특정 사용자의 아이디로, 그 사용자의 정보를 조회
   * @param userId 사용자의 아이디
   * @return 사용자 이름, 직급명, 부서명, 연락처, 이메일, 사용자 이미지 파일 경로
   */
  public User getUserInfoByUserId(int userId);


  /**
   * 두 사용자가 참여한 채팅방의 ID(ROOM_ID)를 조회한다.
   * 채팅방이 없을 경우, NULL일 수도 있기 때문에 Optional 타입으로 반환한다.
   * @param userId
   * @param selectUserId
   * @return
   */
  public Optional<Integer> getChatRoomIdByUserId(int userId, int selectUserId);

  /**
   * 새롭게 만드는 채팅룸의 ROOM_ID를 생성한다.
   * @return
   */
  public int getRoomId();

  /**
   * int getRoomId()에서 생성된 roomId와 지정한 상대방 사용자 이름으로 채팅방을 만든다.
   * @param roomId
   * @param roomName
   */
  public void insertRoom(@Param("roomId") int roomId, @Param("roomName") String roomName);

  /**
   * 그 채팅방에 사용자들을 추가한다.
   * @param roomId 채팅방 ID
   * @param userId 위 채팅방에 참가하는 사용자.
   */
  public void insertChatRoomUser(int roomId, int userId);

}
