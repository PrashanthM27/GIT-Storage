@isTest
public class mergeAccountTest {
    
    public static testmethod void AccountMergeTest(){
        Map<string, schema.RecordTypeInfo> rtMap = Schema.SObjectType.Account.getRecordTypeInfosByName();
       // Id VV=rtMap.get('VV').getRecordTypeId();
       // Id MVS=rtMap.get('MVS - Remind A Pet').getRecordTypeId();
       // Id VVR=rtMap.get('VVR').getRecordTypeId();
       // Id VVANDVVR=rtMap.get('VV and VVR').getRecordTypeId();
        
        
       // Account objAccount = new Account();
      //  objaccount.Name = 'Test';
       // objaccount.RecordTypeId =VV;
      //  insert objAccount;
        
        PageReference pageRef = Page.PopUp;
        Test.setCurrentPage(pageRef);
        
        
       // ApexPages.StandardController sc = new ApexPages.standardController(objAccount);
       // mergeAccount controller = new mergeAccount(sc);
        Account objacc = new Account();
        Boolean selected = true; 
       // controller.bolvar3 = true;
       // controller.SelectAccount ='26551025862uiyty';
        
        mergeAccount.wrapAccount wrrap = new mergeAccount.wrapAccount(objacc,selected);
        
        
      //  controller.nextButton();
       // controller.getAccountNames();
       //  PageReference objPageRef1 = controller.ok();
       //   for(mergeAccount.wrapAccount wrp : controller.selectedAccounts )
          //  {
          ///      wrp.selected = true;
          //  }            
 
       // PageReference objPageRef = controller.Selectedmaster();
       
    }
    
}