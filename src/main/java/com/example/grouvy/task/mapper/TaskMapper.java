package com.example.grouvy.task.mapper;

import com.example.grouvy.task.dto.request.Feedback;
import com.example.grouvy.task.dto.response.*;
import com.example.grouvy.task.vo.TaskFile;
import com.example.grouvy.task.vo.TaskReceiver;
import com.example.grouvy.task.vo.TaskVo;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface TaskMapper {
    List<ModalFile> getAllFilesByUserId(int userId);

    void insertTask(TaskVo task);

    void insertReceiver(TaskReceiver taskReceiver);

    void insertTaskFile(TaskFile taskFile);

    List<Todo> getTodosByUserId(int userId);

    ReceiveUserFeedback getReceiveUserFeedbackByTaskId(int taskId);

    TaskDetail getTaskDetailByTaskId(int taskId);

    List<TaskDetail.Cc> getCcsByTaskId(int taskId);

    String getReceiveRoleByTaskIdAndUserId(@Param("taskId") int taskId, @Param("userId") int userId);

    List<TaskFile> getWriterFilesByTaskId(int taskId);

    List<TaskFile> getReceiveUserFilesByTaskId(int taskId);

    void updateReceivers(Feedback feedback);

    TaskVo getTaskByTaskId(int taskId);

    void updateTask(TaskVo task);

    TaskDetail getTodoDetailByTaskId(int taskId);

    TaskFile getTaskFileByFileId(int fileId);

    List<TaskListItem> getTaskListItemByWriterId(@Param("userId") int userId, @Param("type") String type);

    List<TaskListItem> getTaskListItemByReceiveUserId(@Param("userId") int userId, @Param("type") String type);

    List<TaskListItem> getTaskListItemByCcId(@Param("userId") int userId, @Param("type") String type);
}
