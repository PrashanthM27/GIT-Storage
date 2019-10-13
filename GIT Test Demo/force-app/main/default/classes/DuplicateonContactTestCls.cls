@isTest
private class DuplicateonContactTestCls {
    static testmethod void testData(){
     Set<String> emails=new Set<String>();
     emails.add('prashanthmpsfdc@gmail.com');
     emails.add('prashanth@gmail.com');
     emails.add('prashanth2@gmail.com');
     emails.add('prashanth3@gmail.com');        
    System.assert([Select count() from Contact where email in:emails]==0);
    Contact c1=new Contact(LastName='Ram Kumar',Email='Prashanth2@gmail.com');
    Contact c2=new Contact(LastName='RamK',Email='Prashanth3@gmail.com');
    Contact[] cont=new Contact[]{c1,c2};
        insert cont;
     c1.Email='Chow@gmail.com';
     c2.Email='Chow2@gmail.com';
        update cont;        
     Contact c3=new Contact(FirstName='Prashanth',Email='Prashanth@gmail.com');
        try{
        insert c3;
    System.assert(false);
        }
        catch(DMLException e){
            System.assert(e.getNumDml()==1);
            System.assert(e.getDmlIndex(0)==0);
            System.assert(e.getDmlFields(0).size()==1);
        }
    
    
    
    
    
    
    
    }
}