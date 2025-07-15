package com.example.grouvy.message.mapper;

import com.example.grouvy.message.vo.Message;
import com.example.grouvy.message.vo.MessageReceiver;
import com.example.grouvy.message.vo.MessageSender;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MassageMapper {
    void insertMessage(Message message);
    void insertMessageSender(MessageSender Sender);
    void insertMessageReceiver(MessageReceiver receiver);
}
