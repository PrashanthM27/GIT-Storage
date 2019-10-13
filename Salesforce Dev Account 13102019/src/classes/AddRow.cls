public class AddRow {
    public integer num {set;get;}
    public List<Account> acListData {set;get;}    
    public AddRow(){
         acListData=new List<Account>();              
            acListData.add(new Account());
    }
    public void AddRowMethod(){
        acListData.add(new Account());
    }   
    public void removeRow(){
       num=Integer.valueOf(ApexPages.CurrentPage().getParameters().get('index'));
       acListData.remove(num);
    }
}