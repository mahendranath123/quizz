
import java.util.Properties;
import java.util.Random;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.internet.MimeMessage;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author mahen
 */
public class sendEmail {
    
    public  String getRandom()
    {
        Random rnd= new Random();
        int number =rnd.nextInt(999999);
        
        return String.format("%06d", number);
    }
    public boolean sendEmail(User user)
    {
        boolean test=false;
        String toEmail=user.getEmail();
        String fromEmail="mahendranath123mp@gmail.com";
        String passwd="vydyuthi";
        try{
            Properties pr=new Properties();
            pr.setProperty("mail.smtp.host", "smtp.mail.com");
            pr.setProperty("mail.smtp.port", "587");
            pr.setProperty("mail.smtp.auth", "true");
            pr.setProperty("mail.smtp.starttls.enable", "true");
            pr.put("mail.smtp.socketFactory.port", "587");
            pr.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
            
            
            
            //get session
            Session session = Session.getInstance (pr, new Authenticator () {
                private String password;
            @Override
            protected PasswordAuthentication getPasswordAuthentication () {
            return new PasswordAuthentication (fromEmail, password);
            } 
            });
            
            Message mess = new MimeMessage (session);
            
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        
        return test;
    }
}
