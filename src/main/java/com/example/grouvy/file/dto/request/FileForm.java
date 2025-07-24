package com.example.grouvy.file.dto.request;

import lombok.Getter;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Getter
@Setter
public class FileForm {

    private int fileId;
    private String ownerType;
    private int uploaderId;
    private int uploaderDepartmentId;
    private MultipartFile file;
    private int fileCategoryId;
    private String shareStatus;

    // 개인문서함이고 공유설정이 되어 대상자가 지정되었다면
    private List<Integer> targetUserIds;
}
