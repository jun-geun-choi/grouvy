package com.example.grouvy.task.service;

import com.example.grouvy.file.mapper.FileMapper;
import com.example.grouvy.file.vo.FileVo;
import com.example.grouvy.notification.service.NotificationService;
import com.example.grouvy.notification.vo.Notification;
import com.example.grouvy.task.dto.request.Feedback;
import com.example.grouvy.task.dto.request.TaskForm;
import com.example.grouvy.task.dto.response.*;
import com.example.grouvy.task.mapper.TaskMapper;
import com.example.grouvy.task.vo.TaskFile;
import com.example.grouvy.task.vo.TaskReceiver;
import com.example.grouvy.task.vo.TaskVo;
import com.example.grouvy.user.exception.AppException;
import com.example.grouvy.user.mapper.UserMapper;
import com.example.grouvy.user.vo.User;
import com.google.cloud.storage.Blob;
import com.google.cloud.storage.BlobId;
import com.google.cloud.storage.BlobInfo;
import com.google.cloud.storage.Storage;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.net.URLConnection;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
public class TaskService {

    @Autowired
    private TaskMapper taskMapper;

    @Autowired
    private FileMapper fileMapper;

    @Autowired
    private ModelMapper modelMapper;

    @Autowired
    private Storage storage;

    @Value("${app.file.save-directory}")
    private String saveDirectory;

    @Value("${spring.cloud.gcp.storage.bucket}")
    private String bucketName;

    //알림조회의존성
    @Autowired
    private NotificationService notificationService;
    @Autowired
    private UserMapper userMapper;

    // 로그인 유저의 개인/부서 파일 모두 가져오기
    public List<ModalFile> getFiles(int userId) {
        return taskMapper.getAllFilesByUserId(userId);
    }

    // 업무등록
    @Transactional
    public void createTask(TaskForm taskForm) {
        // 수신자 아이디
        int receiveUserId = taskForm.getReceiveUserId();
        // 참조자 아이디
        List<Integer> ccUserIds = taskForm.getCcUserIds();
        // 로컬파일
        List<MultipartFile> localFiles = taskForm.getLocalFiles();
        // 문서함 파일 아이디
        List<Integer> existingFileIds = taskForm.getExistingFileIds();

        // 업무자체등록
        TaskVo task = modelMapper.map(taskForm, TaskVo.class);

        task.setWriterId(taskForm.getWriterId());

        taskMapper.insertTask(task);

        // 수신자 등록
        if (receiveUserId != 0) {
            TaskReceiver taskReceiver = new TaskReceiver();
            taskReceiver.setTaskId(task.getTaskId());
            taskReceiver.setRole("receive");
            taskReceiver.setTargetUserId(receiveUserId);
            taskMapper.insertReceiver(taskReceiver);
        }


        // 참조자 등록
        if (ccUserIds != null && !ccUserIds.isEmpty()) {
            for (Integer ccUserId : ccUserIds) {
                TaskReceiver taskCc = new TaskReceiver();
                taskCc.setTaskId(task.getTaskId());
                taskCc.setRole("cc");
                taskCc.setTargetUserId(ccUserId);
                taskMapper.insertReceiver(taskCc);
            }
        }

        // 로컬파일 저장
        if (localFiles != null && !localFiles.isEmpty()) {

            for (MultipartFile localFile : localFiles) {
                // 빈거면 건너뛰기
                if (localFile.isEmpty()) {
                    continue;   // 빈 파일이면 건너뛴다
                }
                // 데이터베이스에 넣을 객체 생성
                TaskFile taskFile = new TaskFile();

                // 1. 파일저장
                try {
                    String originalFileName = localFile.getOriginalFilename();
                    String fileName = UUID.randomUUID().toString() + originalFileName;
                    taskFile.setOriginalName(originalFileName);
                    taskFile.setStoredName(fileName);

                    BlobInfo blobInfo = storage.create(
                            BlobInfo.newBuilder(bucketName, fileName)
                                    .setContentType(localFile.getContentType())
                                    .build(),
                            localFile.getInputStream()
                    );

                } catch (Exception e) {
                    throw new RuntimeException("로컬 첨부파일 저장오류", e);
                }
                taskFile.setSize((int)  localFile.getSize());
                taskFile.setExtension(localFile.getOriginalFilename().substring(localFile.getOriginalFilename().lastIndexOf(".")));
                taskFile.setOriginalName(localFile.getOriginalFilename());
                taskFile.setTaskId(task.getTaskId());
                taskFile.setUploadUserId(task.getWriterId());
                // 2. 파일객체 데이터베이스 저장
                taskMapper.insertTaskFile(taskFile);
            }
        }
        // 문서함 파일 저장
        if (existingFileIds != null && !existingFileIds.isEmpty()) {

            for (Integer existingFileId : existingFileIds) {
                // 문서함에 저장되어 있는 파일정보 객체 가져오기
                FileVo originalFile = fileMapper.getFileByFileId(existingFileId);

                // 새로 저장할 파일 이름
                String newStoredName = UUID.randomUUID().toString() + originalFile.getOriginalName();

                // 확장자로부터 contentType 추정
                String contentType = URLConnection.guessContentTypeFromName(originalFile.getOriginalName());
                if (contentType == null) {
                    // 기본값 지정
                    contentType = "application/octet-stream";
                }

                BlobId sourceBlobId = BlobId.of(bucketName, originalFile.getStoredName());
                BlobInfo targetBlobInfo = BlobInfo.newBuilder(BlobId.of(bucketName, newStoredName))
                        .setContentType(contentType)
                        .build();

                storage.copy(
                        Storage.CopyRequest.newBuilder()
                                .setSource(sourceBlobId)
                                .setTarget(targetBlobInfo)
                                .build()
                );

                TaskFile taskFile = modelMapper.map(originalFile, TaskFile.class);

                taskFile.setStoredName(newStoredName);
                taskFile.setOriginalName(originalFile.getOriginalName());
                taskFile.setExtension(originalFile.getExtension());
                taskFile.setSize(originalFile.getSize());
                taskFile.setTaskId(task.getTaskId());
                taskFile.setUploadUserId(task.getWriterId());

                // 데이터베이스에 저장
                taskMapper.insertTaskFile(taskFile);
            }
        }

        //알림 로직.
        User writer = userMapper.findByUserId(taskForm.getWriterId());
        String taskTitle = taskForm.getTitle();
        String targetUrl = "/task/detail/" + task.getTaskId();

        //수신자에게 알림 발송
        if (receiveUserId != 0 && receiveUserId != writer.getUserId()) {
            Notification notificationToReceiver = Notification.builder()
                    .userId(receiveUserId)
                    .notificationType("신규업무")
                    .notificationContent(writer.getName() + "님이 새로운 업무 '" + taskTitle + "'를 등록했습니다.")
                    .targetUrl(targetUrl)
                    .isRead("N")
                    .build();
            notificationService.createNotification(notificationToReceiver);
        }

        //참조자 알림발송
        if (ccUserIds != null && !ccUserIds.isEmpty()) {
            String contentForCc = writer.getName() + "님이 '" + taskTitle + "' 업무에 당신을 참조자로 지정했습니다.";
            for (Integer ccUserId : ccUserIds) {
                if (ccUserId.equals(taskForm.getWriterId())) continue;

                Notification notificationToCc = Notification.builder()
                        .userId(ccUserId)
                        .notificationType("업무참조")
                        .notificationContent(contentForCc)
                        .targetUrl(targetUrl)
                        .isRead("N")
                        .build();
                notificationService.createNotification(notificationToCc);
            }
        }
    }

    // 타입 및 역할 별 업무 리스트 가져오기
    public List<TaskListItem> getRequestAndReport(int userId, String type, String role) {
        List<TaskListItem> taskListItems = new ArrayList<TaskListItem>();

        // 역할별 매퍼 적용
        if (role.equals("writer")) {
            taskListItems = taskMapper.getTaskListItemByWriterId(userId, type);
        } else if (role.equals("receive")) {
            taskListItems = taskMapper.getTaskListItemByReceiveUserId(userId, type);
        } else if (role.equals("cc")) {
            taskListItems = taskMapper.getTaskListItemByCcId(userId, type);
        }

        // 역할별로 나누고 쿼리문에서 타입나눠서 가져오기
        return taskListItems;
    }

    // 할일리스트 가져오기
    public List<Todo> getTodos(int userId) {

        return taskMapper.getTodosByUserId(userId);
    }
    
    // 업무 상세내용
    @Transactional
    public TaskDetail getDetail(int taskId) {
        /*
            1. 업무내용
                taskId, status, writerId, writerName, writerPositionName, created, updated, due,
                receiverUserId, receiveUserName, receivePositionName, content
         */
        TaskDetail taskDetail = taskMapper.getTaskDetailByTaskId(taskId);

        /*
            2. 참조자 목록
                List<Cc> ccs
                (userId, name, positionName)
         */
        List<TaskDetail.Cc> ccs = taskMapper.getCcsByTaskId(taskId);
        taskDetail.setCcs(ccs);

        /*
            3. 파일목록
         */
        List<TaskFile> writerFiles = taskMapper.getWriterFilesByTaskId(taskId);
        taskDetail.setWriterFiles(writerFiles);
        List<TaskFile> receiveUserFiles = taskMapper.getReceiveUserFilesByTaskId(taskId);
        taskDetail.setFeedbackFiles(receiveUserFiles);

        return taskDetail;
    }

    // 업무 수신자피드백
    public ReceiveUserFeedback getFeedback(int taskId) {

        return taskMapper.getReceiveUserFeedbackByTaskId(taskId);
    }

    // 해당업무의 유저의 역할
    public String getMyRole(int taskId, int userId) {
        TaskDetail detail = taskMapper.getTaskDetailByTaskId(taskId);

        String role;

        if (userId == detail.getWriterId()) {
            role = "writer";
        } else {
            role = taskMapper.getReceiveRoleByTaskIdAndUserId(taskId, userId);
        }
        return role;
    }

    // 수신자의 업무피드백 저장
    @Transactional
    public void saveFeedBack(Feedback feedback) {

        List<MultipartFile> localFiles = feedback.getLocalFeedbackFiles();

        List<Integer> existingFileIds = feedback.getExistingFeedbackFileIds();

        String taskDir = saveDirectory + "/task/";
        // 디렉터리 확인 및 생성
        Path taskPath = Paths.get(taskDir);
        try {
            Files.createDirectories(taskPath);
        } catch (IOException e) {
            throw new RuntimeException("Task 디렉터리 생성 실패: " + taskDir, e);
        }

        // 로컬파일 저장
        if (localFiles != null && !localFiles.isEmpty()) {

            for (MultipartFile localFile : localFiles) {
                // 빈거면 건너뛰기
                if (localFile.isEmpty()) {
                    continue;   // 빈 파일이면 건너뛴다
                }
                // 데이터베이스에 넣을 객체 생성
                TaskFile taskFile = new TaskFile();

                // 1. 파일저장
                try {
                    String originalFileName = localFile.getOriginalFilename();
                    String fileName = UUID.randomUUID().toString() + originalFileName;
                    taskFile.setOriginalName(originalFileName);
                    taskFile.setStoredName(fileName);

                    BlobInfo blobInfo = storage.create(
                            BlobInfo.newBuilder(bucketName, fileName)
                                    .setContentType(localFile.getContentType())
                                    .build(),
                            localFile.getInputStream()
                    );


                } catch (Exception e) {
                    throw new RuntimeException("로컬 첨부파일 저장오류", e);
                }
                taskFile.setSize((int)  localFile.getSize());
                taskFile.setExtension(localFile.getOriginalFilename().substring(localFile.getOriginalFilename().lastIndexOf(".")));
                taskFile.setOriginalName(localFile.getOriginalFilename());
                taskFile.setTaskId(feedback.getTaskId());
                taskFile.setUploadUserId(feedback.getReceiveUserId());
                // 2. 파일객체 데이터베이스 저장
                taskMapper.insertTaskFile(taskFile);
            }
        }
        // 문서함 파일 저장
        if (existingFileIds != null && !existingFileIds.isEmpty()) {

            for (Integer existingFileId : existingFileIds) {
                // 문서함에 저장되어 있는 파일정보 객체 가져오기
                FileVo originalFile = fileMapper.getFileByFileId(existingFileId);

                // 새로 저장할 파일 이름
                String newStoredName = UUID.randomUUID().toString() + originalFile.getOriginalName();

                // 확장자로부터 contentType 추정
                String contentType = URLConnection.guessContentTypeFromName(originalFile.getOriginalName());
                if (contentType == null) {
                    // 기본값 지정
                    contentType = "application/octet-stream";
                }

                BlobId sourceBlobId = BlobId.of(bucketName, originalFile.getStoredName());
                BlobInfo targetBlobInfo = BlobInfo.newBuilder(BlobId.of(bucketName, newStoredName))
                        .setContentType(contentType)
                        .build();

                storage.copy(
                        Storage.CopyRequest.newBuilder()
                                .setSource(sourceBlobId)
                                .setTarget(targetBlobInfo)
                                .build()
                );

                TaskFile taskFile = modelMapper.map(originalFile, TaskFile.class);

                taskFile.setStoredName(newStoredName);
                taskFile.setOriginalName(originalFile.getOriginalName());
                taskFile.setExtension(originalFile.getExtension());
                taskFile.setSize(originalFile.getSize());
                taskFile.setTaskId(feedback.getTaskId());
                taskFile.setUploadUserId(feedback.getReceiveUserId());

                // 데이터베이스에 저장
                taskMapper.insertTaskFile(taskFile);

            }

        }

        taskMapper.updateReceivers(feedback);

        TaskVo task = taskMapper.getTaskByTaskId(feedback.getTaskId());

        if (task.getType().equals("request")) {
            // 요청일때
            if (feedback.getProgressPercent() == 0) {
                // 시작전
                task.setStatus("등록됨");
            } else if (feedback.getProgressPercent() > 0 && feedback.getProgressPercent() < 100) {
                // 처리중
                task.setStatus("처리중");
            } else if (feedback.getProgressPercent() == 100) {
                // 처리완료
                task.setStatus("처리완료");
            }
        } else {
            // 보고일때
            if (feedback.getProgressPercent() == 0) {
                // 시작전
                task.setStatus("등록됨");
            } else if (feedback.getProgressPercent() > 0 && feedback.getProgressPercent() < 100) {
                // 검토중
                task.setStatus("검토중");
            } else if (feedback.getProgressPercent() == 100) {
                // 검토완료
                task.setStatus("검토완료");
            }
        }


        taskMapper.updateTask(task);

        //알림로직.
        User receiver = userMapper.findByUserId(feedback.getReceiveUserId());
        String taskTitle = task.getTitle();
        String targetUrl = "/task/detail/" + task.getTaskId();
        String notificationContent;

        // 진행률 알림 메시지 생성
        if (feedback.getProgressPercent() == 100) {
            String completeMessage = task.getType().equals("request") ? "처리를 완료했습니다." : "검토를 완료했습니다.";
            notificationContent = receiver.getName() + "님이 '" + taskTitle + "' 업무의 " + completeMessage;
        } else {
            notificationContent = receiver.getName() + "님이 '" + taskTitle + "' 업무에 대한 피드백을 등록했습니다.";
        }

        //알림 발송
        Notification notification = Notification.builder()
                .userId(task.getWriterId())
                .notificationType("업무검토")
                .notificationContent(notificationContent)
                .targetUrl(targetUrl)
                .isRead("N")
                .build();
        notificationService.createNotification(notification);
    }

    // 업무반려에 따른 업무 업데이트
    @Transactional
    public void rejectTask(Feedback feedback) {
        // 업무 업데이트
        TaskVo task = taskMapper.getTaskByTaskId(feedback.getTaskId());

        task.setStatus("반려");
        taskMapper.updateTask(task);

        // 수신자 업데이트
        feedback.setProgressPercent(0);
        taskMapper.updateReceivers(feedback);

        //알림로직.
        User receiver = userMapper.findByUserId(feedback.getReceiveUserId());
        String taskTitle = task.getTitle();
        String targetUrl = "/task/detail/" + task.getTaskId();

        //알림 메시지 생성
        String notificationContent = receiver.getName() + "님이 '" + taskTitle + "' 업무를 반려했습니다.";

        //알림 발송
        Notification notification = Notification.builder()
                .userId(task.getWriterId())
                .notificationType("업무반려")
                .notificationContent(notificationContent)
                .targetUrl(targetUrl)
                .isRead("N")
                .build();
        notificationService.createNotification(notification);
    }

    // 할일 디테일 가져오기
    public TaskDetail getTodoDetail(int taskId) {
        TaskDetail taskDetail = taskMapper.getTodoDetailByTaskId(taskId);

        /*
            파일목록
         */
        List<TaskFile> writerFiles = taskMapper.getWriterFilesByTaskId(taskId);
        taskDetail.setWriterFiles(writerFiles);

        return taskDetail;
    }

    // 할 일 완료
    public void completeTodo(int taskId) {
        TaskVo task = taskMapper.getTaskByTaskId(taskId);
        
        task.setStatus("완료");
        taskMapper.updateTask(task);
    }

    // 업무 삭제
    public void deleteTask(List<Integer> taskIds) {
        for (Integer taskId : taskIds) {
            TaskVo task = taskMapper.getTaskByTaskId(taskId);
            task.setIsDeleted("Y");
            taskMapper.updateTask(task);
        }
    }

    // 다운로드할 파일 전달
    @Transactional
    public File getDownloadFile(int fileId) {
        TaskFile taskFile = taskMapper.getTaskFileByFileId(fileId);
        String storedName = taskFile.getStoredName();
        String originalName = taskFile.getOriginalName();

        // 2) 임시파일 경로 준비
        String tmpDir = System.getProperty("java.io.tmpdir");
        File file = new File(tmpDir + storedName);

        // 3) 클라우드에서 내려받아 임시 저장
        Blob blob = storage.get(bucketName, storedName);
        if (blob == null) {
            throw new AppException("파일이 없습니다" + storedName);
        }
        blob.downloadTo(file.toPath());

        // 4) 파일명 변경
//        File originalNamed = new File(tmpDir, originalName);
//        if (file.renameTo(originalNamed)) {
//            return originalNamed;
//        }
        return file;
    }
}
