package com.example.grouvy.file.service;

import com.example.grouvy.file.dto.response.EditFileForm;
import com.example.grouvy.file.dto.request.FileForm;
import com.example.grouvy.file.dto.response.ShareInFile;
import com.example.grouvy.file.mapper.FileMapper;
import com.example.grouvy.file.dto.response.ModalUser;
import com.example.grouvy.file.vo.Category;
import com.example.grouvy.file.vo.FileVo;
import com.example.grouvy.file.vo.FileShare;
import com.example.grouvy.file.vo.Trash;
import com.example.grouvy.notification.service.NotificationService;
import com.example.grouvy.notification.vo.Notification;
import com.example.grouvy.user.exception.AppException;
import com.example.grouvy.user.mapper.UserMapper;
import com.example.grouvy.user.vo.User;
import com.google.cloud.storage.Blob;
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
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;

@Service
public class FileService {

    @Value("${app.file.save-directory}")
    private String saveDirectory;

    @Value("${spring.cloud.gcp.storage.bucket}")
    private String bucketName;

    @Autowired
    private ModelMapper modelMapper;

    @Autowired
    private FileMapper fileMapper;

    @Autowired
    private Storage storage;

    //알림조회의존성
    @Autowired
    private NotificationService notificationService;
    @Autowired
    private UserMapper userMapper;

    // 파일 업로드
    @Transactional
    public void uploadFile(User user, FileForm fileUploadForm) {
        FileVo file = modelMapper.map(fileUploadForm, FileVo.class);

        // 파일 저장과정
        MultipartFile uploadedFile = fileUploadForm.getFile();
        file.setSize((int) uploadedFile.getSize());
        file.setExtension(uploadedFile.getOriginalFilename().substring(uploadedFile.getOriginalFilename().lastIndexOf(".")));
        try {
            String originalFileName = uploadedFile.getOriginalFilename();
            String filename = UUID.randomUUID().toString() + "." + originalFileName;
            file.setOriginalName(originalFileName);
            file.setStoredName(filename);

            BlobInfo blobInfo = storage.create(
                    BlobInfo.newBuilder(bucketName, filename)
                            .setContentType(uploadedFile.getContentType())
                            .build(),
                    uploadedFile.getInputStream()
            );

//            File dest = new File(saveDirectory + "/" + file.getOwnerType(), filename);
//            uploadedFile.transferTo(dest);
        } catch (Exception e) {
            throw new RuntimeException("첨부파일저장오류", e);
        }

        //알림링크
        String uploaderName = user.getName();
        String fileName = file.getOriginalName();

        if (file.getOwnerType().equals("personal")) {
            // 개인파일인 경우
            file.setUploader(user);
            fileMapper.insertPersonalFile(file);
        } else if (file.getOwnerType().equals("department")) {
            // 부서파일인 경우
            file.setUploader(user);
            file.setUploaderDepartment(user.getDepartment());
            fileMapper.insertDepartmentFile(file);
        }

        List<Integer> targetUserIds = fileUploadForm.getTargetUserIds();

        // share 추가
        if (!(targetUserIds == null)) {
            for (Integer targetUserId : targetUserIds) {
                FileShare fileShare = new FileShare();
                fileShare.setFileId(file.getFileId());
                fileShare.setFileOwnerId(user.getUserId());
                fileShare.setTargetUserId(targetUserId);
                fileMapper.insertShare(fileShare);
            }
        }

        // 알림 생성 로직
        if (file.getOwnerType().equals("personal")) {
            // 공유파일
            if (targetUserIds != null && !targetUserIds.isEmpty()) {
                String targetUrl = "/file/share";
                for (Integer targetUserId : targetUserIds) {
                    if (targetUserId.equals(user.getUserId())) continue;

                    Notification notification = Notification.builder()
                            .userId(targetUserId)
                            .notificationType("개인파일 공유")
                            .notificationContent(uploaderName + "님이 '" + fileName + "' 파일을 공유했습니다.")
                            .targetUrl(targetUrl)
                            .isRead("N")
                            .build();
                    notificationService.createNotification(notification);
                }
            }
        } else if (file.getOwnerType().equals("department")) {
            // 부서 파일
            Long departmentId = user.getDepartment().getDepartmentId();
            List<User> departmentMembers = userMapper.findUsersByDeptId(departmentId);
            String targetUrl = "/file/department";

            if (departmentMembers != null) {
                for (User member : departmentMembers) {
                    if (member.getUserId() == user.getUserId()) continue;

                    Notification notification = Notification.builder()
                            .userId(member.getUserId())
                            .notificationType("부서파일 업로드")
                            .notificationContent(uploaderName + "님이 부서 문서함에 '" + fileName + "' 파일을 업로드했습니다.")
                            .targetUrl(targetUrl)
                            .isRead("N")
                            .build();
                    notificationService.createNotification(notification);
                }
            }
        }
    }

    // 개인문서함 목록
    public List<FileVo> getPersonalFiles(int userId) {
        List<FileVo> files = fileMapper.getPersonalFilesByUserId(userId);

        return files;
    }

    // 부서문서함 목록
    public List<FileVo> getDepartmentFiles(int departmentId) {
        return fileMapper.getDepartmentFilesByDepartmentId(departmentId);
    }

    // 파일 휴지통으로 전달
    @Transactional
    public void deleteFiles(List<Integer> fileIds) {
        // 삭제대상 파일번호 리스트 반복
        for (Integer fileId : fileIds) {
            // 파일삭제 업데이트
            FileVo file = fileMapper.getFileByFileId(fileId);
            file.setIsDeleted("Y");
            fileMapper.updateFile(file);
            // 공유대상불러오기
            List<Integer> targetUserIds = fileMapper.getTargetUserIdsByFileId(fileId);
            // 공유삭제
            for (Integer targetUserId : targetUserIds) {
                fileMapper.deleteShareByFileIdAndTargetUserId(fileId, targetUserId);
            }
            // 휴지통에 넣기
            Trash trash = new Trash();
            FileVo trashFile = new FileVo();
            trash.setFile(trashFile);
            trash.getFile().setFileId(fileId);

            fileMapper.insertTrash(trash);
        }


    }

    // 모달 유저 가져오기
    public List<ModalUser> targetList() {
        return fileMapper.getModalUsers();
    }

    // 변경할 파일의 기존 정보 획득
    public EditFileForm getEditFile(int fileId) {

        EditFileForm editFileForm = fileMapper.getEditFileFormWithTargetUserIds(fileId);

        // 타겟유저가 있었으면 이름, 직급 유저정보 담아줌
        List<Integer> ids = editFileForm.getTargetUserIds();
        if (ids != null) {
            for (Integer userId : ids) {
                editFileForm.getTargetUsers().add(
                        fileMapper.getTargetUserByUserId(userId)
                );
            }
        }


        return editFileForm;
    }

    public List<Category> getAllCategories() {
        return fileMapper.getAllCategories();
    }

    // 파일 편집시
    @Transactional
    public void updateFile(FileForm fileForm) {
        // 바인딩 확인
        int fileId = fileForm.getFileId();
        System.out.println("처리할 fileId = " + fileId);        // vo매핑

        FileVo file = modelMapper.map(fileForm, FileVo.class);
        System.out.println("매핑후 파일아이디@@@@@@@@@@@@" + file.getFileId());

        // 공유 안하면 N넣어주기
        if (!"Y".equals(fileForm.getShareStatus())) {
            fileForm.setShareStatus("N");
        }

        // uploaderId 뽑아놓기
        int uploaderId = fileForm.getUploaderId();

        // 기존 파일 받아오기
        FileVo originalFile = fileMapper.getFileByFileId(file.getFileId());

        // 파일 객체 변경
        originalFile.setOwnerType(fileForm.getOwnerType());
        originalFile.setFileCategoryId(fileForm.getFileCategoryId());
        originalFile.setShareStatus(fileForm.getShareStatus());
        System.out.println("업데이트 직전 파일번호@@@@@@@@@@@@@@@@@@    " + originalFile.getFileId());
        int updatedRows = fileMapper.updateFile(originalFile);
        System.out.println(">>> updateFile affected rows: " + updatedRows);
        // @@@@@@@@@@@@@@@@@

        if  (fileForm.getShareStatus().equals("Y")) {
            // 공유하면
            // 새로받아온 공유대상 아이디
            List<Integer> newTargetUserIds = fileForm.getTargetUserIds();
            if (newTargetUserIds == null) {
                newTargetUserIds = new ArrayList<Integer>();
            }

            // 기존 공유대상 아이디
            List<Integer> originalTargetUserIds = fileMapper.getTargetUserIdsByFileId(file.getFileId());
            if (originalTargetUserIds == null) {
                originalTargetUserIds = new ArrayList<Integer>();
            }

            // set으로 변환(비교가 쉬워짐)
            Set<Integer> originalSet = new HashSet<>(originalTargetUserIds);
            Set<Integer> newSet = new HashSet<>(newTargetUserIds);

            // 삭제할 대상
            Set<Integer> toRemove = new HashSet<>(originalTargetUserIds);
            toRemove.removeAll(newSet);

            // 추가할 대상
            Set<Integer> toAdd = new HashSet<>(newTargetUserIds);
            toAdd.removeAll(originalSet);

            // 삭제과정
            for (Integer targetId : toRemove) {
                fileMapper.deleteShareByFileIdAndTargetUserId(file.getFileId(), (int) targetId);
            }

            // 추가과정
            for (Integer targetId : toAdd) {
                FileShare share = new FileShare();
                share.setFileId(file.getFileId());
                share.setTargetUserId(targetId);
                share.setFileOwnerId(uploaderId);
                fileMapper.insertShare(share);
            }
        } else {
            // 공유안할때
            List<Integer> originalTargetUserIds = fileMapper.getTargetUserIdsByFileId(file.getFileId());
            if (originalTargetUserIds == null) {
                originalTargetUserIds = new ArrayList<Integer>();
            }
            // 공유삭제
            for (Integer targetId : originalTargetUserIds) {
                fileMapper.deleteShareByFileIdAndTargetUserId(file.getFileId(), (int) targetId);
            }
        }



    }

    // 공유받은 파일 반환
    public List<ShareInFile> getSharedInFiles(int userId) {
        List<ShareInFile> files = fileMapper.getSharedInFilesByTargetId(userId);

        return files;
    }

    // 공유 삭제
    public void deleteShare(List<Integer> fileIds, User targetUser) {
        for (Integer fileId : fileIds) {
            fileMapper.deleteShareByFileIdAndTargetUserId((int) fileId, targetUser.getUserId());
        }
    }

    // 휴지통 목록
    public List<Trash> getTrash(User user) {
        int userId = user.getUserId();
        return fileMapper.getTrashByUserId(userId);
    }

    @Transactional
    // 휴지통 복원
    public void restoreTrash(List<Integer> trashIds) {
        for (Integer trashId : trashIds) {
            // 휴지통 항목 가져오기
            Trash trash = fileMapper.getTrashByTrashId(trashId);

            // 휴지통 항목 삭제
            fileMapper.deleteTrash(trashId);

            // 파일번호 받아와서 파일 isDeleted 'N'으로 변경
            FileVo file = fileMapper.getFileByFileId(trash.getFile().getFileId());
            file.setIsDeleted("N");
            fileMapper.updateFile(file);
            

        }
    }

    // 휴지통 영구삭제
    @Transactional
    public void deleteTrash(List<Integer> trashIds) {
        for (Integer trashId : trashIds) {
            Trash trash = fileMapper.getTrashByTrashId(trashId);

            FileVo file = trash.getFile();

            // 저장 파일 삭제

            // 1) 필수 정보 null 체크
            String ownerType = file.getOwnerType();
            String storedName = file.getStoredName();

            if (ownerType == null || storedName == null) {
                throw new AppException(String.format(
                        "파일 경로 구성 정보 누락: ownerType=%s, storedName=%s",
                        ownerType, storedName
                ));
            }

            storage.delete(bucketName, storedName);

            // 휴지통 항목 삭제
            fileMapper.deleteTrash(trashId);

            // 파일번호 받아와서 파일 진짜 delete
            fileMapper.deleteFile(trash.getFile().getFileId());
        }
    }

    @Transactional
    public File getDownloadFile(int fileId) {
        FileVo fileVo = fileMapper.getFileByFileId(fileId);
        String storedName = fileVo.getStoredName();
        String originalName = fileVo.getOriginalName();

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
