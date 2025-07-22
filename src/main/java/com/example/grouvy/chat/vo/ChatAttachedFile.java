package com.example.grouvy.chat.vo;

import java.util.Date;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

@Getter
@Setter
@NoArgsConstructor
@Alias("ChatAttachedFile")
public class ChatAttachedFile {
  private int fileId;
  private long chatMessageId;
  private String originName;
  private String stroedName;
  private String filePath;
  private long fileSize;
  private Date createdDate;

  private ChatMessage chatMessage;
}
