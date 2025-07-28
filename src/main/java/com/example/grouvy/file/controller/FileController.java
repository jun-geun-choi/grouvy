package com.example.grouvy.file.controller;

import com.example.grouvy.file.dto.response.EditFileForm;
import com.example.grouvy.file.dto.request.FileForm;
import com.example.grouvy.file.dto.response.ShareInFile;
import com.example.grouvy.file.dto.response.TargetUser;
import com.example.grouvy.file.service.FileService;
import com.example.grouvy.file.view.FileDownloadView;
import com.example.grouvy.file.vo.Category;
import com.example.grouvy.file.vo.FileVo;
import com.example.grouvy.security.SecurityUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.io.File;
import java.util.List;

@Controller
@RequestMapping("/file")
public class  FileController {

    @Autowired
    private FileService fileService;

    @Autowired
    private FileDownloadView fileDownloadView;

    @ModelAttribute
    public void Categories(Model model) {
        List<Category> categories = fileService.getAllCategories();
        model.addAttribute("categories", categories);
    }

    @PostMapping("/delete")
    public String fileDelete(@RequestParam List<Integer> fileIds, @RequestParam String ownerType) {
        fileService.deleteFiles(fileIds);

        if (ownerType.equals("department")) {
            // 부서문서함
            return "redirect:/file/department";
        } else  {
            // 개인문서함
            return "redirect:/file/personal";
        }
    }

    @GetMapping("/personal")
    public String personalFiles(@AuthenticationPrincipal SecurityUser securityUser , Model model) {

        List<FileVo> files = fileService.getPersonalFiles(securityUser.getUser().getUserId());

        model.addAttribute("files", files);

        return "file/personal_files";
    }

    @GetMapping("/department")
    public String departmentFiles(@AuthenticationPrincipal SecurityUser securityUser, Model model) {


        List<FileVo> files = fileService.getDepartmentFiles(Math.toIntExact(securityUser.getUser().getDepartment().getDepartmentId()));

        model.addAttribute("files", files);
        // 테스트
        return "file/department_files";
    }

    @GetMapping("/form")
    public String form() {
        return "file/file_form";
    }

    @PostMapping("/form")
    // 나중에 securityUser 받아와야함
    public String fileUpload(@AuthenticationPrincipal SecurityUser securityUser, FileForm fileForm) {

        fileService.uploadFile(securityUser.getUser(), fileForm);
        if (fileForm.getOwnerType().equals("personal")) {
            // 개인문서함일때
            return "redirect:/file/personal";
        } else {
           // 부서문서함일때
            return "redirect:/file/department";
        }

    }

    @GetMapping("/edit")
    public String fileEdit(@RequestParam int fileId, Model model) {

        EditFileForm file = fileService.getEditFile(fileId);

        model.addAttribute("file", file);


        return "file/file_edit";
    }
    @PostMapping("/edit")
    public String fileUpdate(FileForm fileForm) {

        fileService.updateFile(fileForm);

        if (fileForm.getOwnerType().equals("personal")) {
            // 개인문서함일때
            return "redirect:/file/personal";
        } else {
            // 부서문서함일때
            return "redirect:/file/department";
        }
    }

    @GetMapping("/share")
    public String share(@AuthenticationPrincipal SecurityUser securityUser, Model model) {

        List<ShareInFile> shareInFiles = fileService.getSharedInFiles(securityUser.getUser().getUserId());

        model.addAttribute("files", shareInFiles);

        return "file/share_in";
    }
    @PostMapping("/share_delete")
    public String shareDelete(@RequestParam List<Integer> fileIds, @AuthenticationPrincipal SecurityUser securityUser) {
        fileService.deleteShare(fileIds, securityUser.getUser());

        return "redirect:/file/share";
    }

    @GetMapping("/trash")
    public String trash(@AuthenticationPrincipal SecurityUser securityUser, Model model) {

        model.addAttribute("trashList", fileService.getTrash(securityUser.getUser()));

        return "file/file_trash";
    }

    @PostMapping("/trash/restore")
    public String trashRestore(@RequestParam List<Integer> trashIds, @AuthenticationPrincipal SecurityUser securityUser) {
        fileService.restoreTrash(trashIds);

        return "redirect:/file/trash";
    }

    @PostMapping("/trash/delete")
    public String trashDelete(@RequestParam List<Integer> trashIds, @AuthenticationPrincipal SecurityUser securityUser) {
        fileService.deleteTrash(trashIds);

        return "redirect:/file/trash";
    }

    @GetMapping("/download")
    public ModelAndView download(@RequestParam("fileId") int fileId) {
        File file = fileService.getDownloadFile(fileId);

        ModelAndView mav = new ModelAndView();
        mav.addObject("file", file);
        mav.setView(fileDownloadView);

        return mav;
    }
}
