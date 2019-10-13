@isTest
 
private class MyCustomLookupController_Test{
 
  @testSetup
 
  static void setupTestData(){
  
   MyCustomLookupController mcc = new MyCustomLookupController();
    test.startTest();
 
    Contact contact_Obj = new Contact(LastName = 'LastName291');
 
    Insert contact_Obj; 
 
    test.stopTest();
 
  }
 
}