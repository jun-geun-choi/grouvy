package com.example.grouvy.approval.dto;

import lombok.Getter;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

@Getter
@Setter
@Alias("ApproverPreview")
public class ApproverPreview {
    private String name;
    private String positionName;
}
