package com.example.grouvy.approval.vo;

import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

@Getter
@Setter
@Alias("ApprovalFoam")
public class ApprovalFoam {
    private int foamNo;
    private String foamName;
}
