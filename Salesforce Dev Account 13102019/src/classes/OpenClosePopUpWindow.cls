public class OpenClosePopUpWindow {
    public Boolean displayPopUp{set;get;}
    public void displayPopupWindow(){
           displayPopUp = true;
    }
    public void closePopUpWindow(){
          displayPopUp = false;
    }
}