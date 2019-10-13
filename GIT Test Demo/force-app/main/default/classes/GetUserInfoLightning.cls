public class GetUserInfoLightning {
@AuraEnabled
    public static user getUser(){
        User u=[Select Id,Name,TimeZonesidkey,Email,Phone from User where Id=:UserInfo.getUserId()];
    return u;
     }
}