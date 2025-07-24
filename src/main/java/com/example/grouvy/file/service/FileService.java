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
import com.example.grouvy.user.exception.AppException;
import com.example.grouvy.user.vo.User;
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

    @Autowired
    private ModelMapper modelMapper;

    @Autowired
    private FileMapper fileMapper;

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

            File dest = new File(saveDirectory + "/" + file.getOwnerType(), filename);
            uploadedFile.transferTo(dest);
        } catch (Exception e) {
            throw new RuntimeException("첨부파일저장오류", e);
        }

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

    // 파일 삭제
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

    @Transactional
    // 휴지통 영구삭제
    public void deleteTrash(List<Integer> trashIds) {
        for (Integer trashId : trashIds) {
            Trash trash = fileMapper.getTrashByTrashId(trashId);

            FileVo file = trash.getFile();

            // 저장 파일 삭제
            String subDir = file.getOwnerType().equals("personal") ? "personal" : "department";

            // 1) 필수 정보 null 체크
            String baseDir = saveDirectory;
            String ownerType = file.getOwnerType();
            String storedName = file.getStoredName();

            if (baseDir == null || ownerType == null || storedName == null) {
                throw new AppException(String.format(
                        "파일 경로 구성 정보 누락: baseDir=%s, ownerType=%s, storedName=%s",
                        baseDir, ownerType, storedName
                ));
            }

            Path filePath = Paths.get(saveDirectory, subDir, file.getStoredName());

            try {
                Files.deleteIfExists(filePath);
            } catch (IOException e) {
                throw new AppException("파일 삭제 중 오류: " + filePath, e);
            }

            // 휴지통 항목 삭제
            fileMapper.deleteTrash(trashId);

            // 파일번호 받아와서 파일 진짜 delete
            fileMapper.deleteFile(trash.getFile().getFileId());
        }
    }

    @Transactional
    public File getDownloadFile(int fileId) {
        FileVo fileVo = fileMapper.getFileByFileId(fileId);
        String filename = fileVo.getStoredName();

        String fileDirectory;

        if (fileVo.getOwnerType().equals("personal")) {
            fileDirectory = saveDirectory + "/personal";
        } else {
            fileDirectory = saveDirectory + "/department";
        }

        File file = new File(fileDirectory, filename);
        if (!file.exists()) {
            throw new AppException("파일이 존재하지 않습니다");
        }

        return file;
    }
}
