public class AccountDeleteWrapperCLs{
public List<AccountRecordCls> accWrapperRecordList {get;set;}


 public AccountDeleteWrapperCLs(){
 List<Account> accList= new List<Account>();
 accWrapperRecordList = new List<AccountRecordCls>();
 accList = [select id,Name,Phone,AccountNumber from Account];
  if(!accList.isEmpty()) {
    for(Account acc: accList){
     AccountRecordCls arcls = new AccountRecordCls();
     arcls.isSelected =  false;
     arcls.accObj = acc;
     accWrapperRecordList.add(arcls);
    
    } //end of for loop.
  
  } //end of if condition.
 }
  
  /*
   Delete Account functionality based on the selected records.
  */
  public PageReference DeleteAccount(){
   List<Account> accToDelete = new List<Account>();
   //To hold the unselected account records.
   List<AccountRecordCls> listUnSelectedRecords  = new List<AccountRecordCls>();  
    if(accWrapperRecordList !=null && accWrapperRecordList.size()>0) {
      for(AccountRecordCls wrapObj :  accWrapperRecordList){
        if(wrapObj.isSelected == true){
          accToDelete.add(wrapObj.accObj);
        }else{
          listUnSelectedRecords.add(wrapObj);
        }
      
      
      }//end of for.
      /*
       checking the delete list size and assign the unselected values to 
       original wrapper list.
      */
      if(accToDelete !=null && accToDelete.size()>0){
       delete accToDelete;
       accWrapperRecordList.clear();
       accWrapperRecordList.addAll(listUnSelectedRecords);
      }
    
    }else{
     ApexPages.Message  myMsg = new ApexPages.Message(ApexPages.Severity.info, 'Records were not there to delete.');
     ApexPages.addMessage(myMsg);
    }
    
    return null;
  }
}

  

 /* Wrapper class with checkbox and account object. 
  this is also  called as inner class 
  */