public class Ltng_DisplayCurrentUserPhoto {
    public static List<User> userPhoto(){
        return [Select Id,Name,FullPhotoURL,SmallPhotoURL from User where Id=:UserInfo.getUserId()];
        
    }
}