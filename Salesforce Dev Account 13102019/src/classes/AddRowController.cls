public class AddRowController {
    public List<Contact> lstAcct = new List<Contact>();
    public List<innerClass> lstInner {get;set;}
    public String selectedRowIndex {get;set;}
    public Integer index {get;set;}
    public Integer count = 1;
    
    
    /*Constructor*/
    public AddRowController(ApexPages.StandardController ctlr)
    {   
        lstInner = new List<innerClass>();
        addMore();
        selectedRowIndex = '0';
        
        
    }/*End Constructor*/
    
    
    public void Add()
    {
        count = count+1;
        addMore();   
    }
    public PageReference  Save()
    {
        PageReference pr = new PageReference('/apex/AddRow');
        for(Integer j = 0;j<lstInner.size();j++)
        {
            lstAcct.add(lstInner[j].acct);  
        }
        insert lstAcct;
        pr.setRedirect(true);
        return pr;
    }
    
    /*Begin addMore*/
    public void addMore()
    {
        //call to the iner class constructor
        innerClass objInnerClass = new innerClass(count);       
        //add the record to the inner class list
        lstInner.add(objInnerClass);    
        system.debug('lstInner---->'+lstInner);            
    }/* end addMore*/   
    
    /* begin delete */
    public void Remove()
    {
        system.debug('selected row index---->'+ selectedRowIndex);
        lstInner.remove(Integer.valueOf(selectedRowIndex)-1);        
        count = count - 1;      
    }/*End del*/
    
    public class innerClass
    {       
        /*recCount acts as a index for a row. This will be helpful to identify the row to be deleted */
        public String recCount {get;set;}       
        public Contact acct {get;set;}
        /*Inner Class Constructor*/
        public innerClass(Integer intCount)
        {
            recCount = String.valueOf(intCount);        
            /*create a new account*/
            acct = new Contact();
        }/*End Inner class Constructor*/    
    }/*End inner Class*/
}