package com.example.grouvy.file.mapper;

import com.example.grouvy.file.dto.response.EditFileForm;
import com.example.grouvy.file.dto.response.ModalUser;
import com.example.grouvy.file.dto.response.ShareInFile;
import com.example.grouvy.file.dto.response.TargetUser;
import com.example.grouvy.file.vo.Category;
import com.example.grouvy.file.vo.FileVo;
import com.example.grouvy.file.vo.FileShare;
import com.example.grouvy.file.vo.Trash;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface FileMapper {

    void insertPersonalFile(FileVo file);
    void insertDepartmentFile(FileVo file);
    void insertShare(FileShare share);
    List<FileVo> getPersonalFilesByUserId(int userId);
    List<FileVo> getDepartmentFilesByDepartmentId(int departmentId);
    List<ModalUser> getModalUsers();
    List<Category> getAllCategories();
    EditFileForm getEditFileFormWithTargetUserIds(int fileId);
    TargetUser getTargetUserByUserId(int userId);
    List<Integer> getTargetUserIdsByFileId(int fileId);

    void deleteShareByFileIdAndTargetUserId(@Param("fileId") int fileId, @Param("targetId") int targetId);

    FileVo getFileByFileId(int fileId);

    int updateFile(FileVo file);

    List<ShareInFile> getSharedInFilesByTargetId(int userId);

    List<Trash> getTrashByUserId(int userId);

    void insertTrash(Trash trash);

    Trash getTrashByTrashId(Integer trashId);

    void deleteTrash(int trashId);

    void deleteFile(int fileId);
}
