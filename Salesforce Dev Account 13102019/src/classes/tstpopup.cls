public class tstpopup {     

    public boolean displayPopup {get; set;} 
    public tstpopup(ApexPages.StandardController stdController) {
        System.debug('insde controller');
    }    
    
    public void closePopup() {        
        displayPopup = false;    
    }     
    public void showPopup() {        
        displayPopup = true;    
    }
    
  }