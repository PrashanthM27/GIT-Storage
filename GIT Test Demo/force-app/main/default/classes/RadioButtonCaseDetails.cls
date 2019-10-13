public class RadioButtonCaseDetails {
    public ApexPages.StandardController cont{set;get;}
    public Contact ct{set;get;}
    public String ph{set;get;}
    public String ml{set;get;}
    public RadioButtonCaseDetails(ApexPages.StandardController controller){
       cont=controller;
            }
    public void Save(){
        ct=[Select Id,Phone,Email from Contact];
        ph=ct.Phone;
        ml=ct.Email;
        
    }
}