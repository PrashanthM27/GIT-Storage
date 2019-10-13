public class ForceUIExtension {
    public ForceUIExtension(ApexPages.StandardController controller){
        
    }
    public String getContextUserUiTheme(){
        return UserInfo.getUiTheme();
    }
    public String getContextUserUiThemeDisplayed(){
        return UserInfo.getUiThemeDisplayed();
    }
}