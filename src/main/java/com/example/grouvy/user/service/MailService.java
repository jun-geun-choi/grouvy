package com.example.grouvy.user.service;

import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import java.util.Random;

@Service
@RequiredArgsConstructor
public class MailService {

    private final JavaMailSender mailSender;

    public String sendConfirmMail(String to) {
        String confirmCode = createConfirmMail(to); // 코드 받아오기
        return confirmCode;
    }

    // 인증 이메일 생성
    public String createConfirmMail(String to) {
        // 로그 출력
        String confirmCode = createRandomCode();
//        System.out.println("보내는 대상 : " + to);
//        System.out.println("인증 번호 : " + confirmCode);

        MimeMessage confirmMail = mailSender.createMimeMessage();

        try {
            MimeMessageHelper mimeMessageHelper = new MimeMessageHelper(confirmMail, false, "UTF-8");
            mimeMessageHelper.setTo(to);
            mimeMessageHelper.setSubject("[Grouvy] 이메일 인증번호 안내 메일입니다.");

            String content = """
                    <!DOCTYPE html>
                    <html lang="ko">
                      <body style="margin: 0; padding: 0;">
                        <table width="100%" cellpadding="0" cellspacing="0" style="padding: 40px 0;">
                          <tr>
                            <td align="center">
                              <table width="600" cellpadding="0" cellspacing="0" style="border: 1px solid #ddd; border-radius: 8px; padding: 40px;">
                                <tr>
                                  <td align="center" style="font-size: 20px; font-weight: bold; color: #4285f4;">
                                    GROUVY
                                  </td>
                                </tr>
                                <tr><td height="30"></td></tr>
                                <tr>
                                  <td align="center" style="font-size: 24px; font-weight: bold; color: #333;">
                                    이메일 인증 코드
                                  </td>
                                </tr>
                                <tr><td height="20"></td></tr>
                                <tr>
                                  <td align="center" style="font-size: 16px; color: #555;">
                                    아래 인증 코드를 회원가입 창에 입력해 주세요.
                                  </td>
                                </tr>
                                <tr><td height="30"></td></tr>
                                <tr>
                                  <td align="center">
                                    <div style="display: inline-block; font-size: 28px; letter-spacing: 4px; color: #202124; background-color: #f1f3f4; padding: 15px 30px; border-radius: 8px; font-weight: bold;">
                    """ +
                    confirmCode
                    + """
                                    </div>
                                  </td>
                                </tr>
                                <tr><td height="40"></td></tr>
                                <tr>
                                  <td align="center" style="font-size: 12px; color: #999;">
                                    이 메일은 인증 목적으로 발송되었습니다. 본인이 요청하지 않았다면 무시해 주세요.<br>
                                    &copy; 2025 GROUVY
                                  </td>
                                </tr>
                              </table>
                            </td>
                          </tr>
                        </table>
                      </body>
                    </html>
                    """;

            mimeMessageHelper.setText(content, true);
            mailSender.send(confirmMail);

//            System.out.println(">>> 메일 발송 성공 <<<");
        } catch (Exception e) { // TODO : 예외처리 확인
//            System.out.println(">>> 메일 발송 실패 <<<");
            throw new RuntimeException(e);
        }

        return confirmCode;
    }

    // 인증코드 생성
    public static String createRandomCode() {
        StringBuilder key = new StringBuilder();
        Random random = new Random();

        for (int i = 0; i < 6; i++) {
            int index = random.nextInt(3);

            switch (index) {
                case 0:
                    key.append((char)((int)(random.nextInt(26) + 97)));
                    break;
                case 1:
                    key.append((char)((int)(random.nextInt(26) + 65)));
                    break;
                case 2:
                    key.append(random.nextInt(10));
                    break;
            }
        }
        return key.toString();
    }

}
