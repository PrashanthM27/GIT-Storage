public class Ltng_CurrentUserPhoto {
@AuraEnabled
    public static User currentUserPhoto(){
        return [Select Id,Name,SmallPhotoURL,FullPhotoURL FROM User WHERE Id=:UserInfo.getUserId()];
        
    }
}