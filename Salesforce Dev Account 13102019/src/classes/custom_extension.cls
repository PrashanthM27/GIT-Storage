public class custom_extension {
    public Account ac;
    public Contact newContact {get; set;}

    public custom_extension(ApexPages.StandardController controller) {
        this.ac= (Account)controller.getRecord();
        newContact = new Contact();
    }

    public PageReference saveContact() {
        newContact.Account.Name= ApexPages.currentPage().getParameters().get('id');
        insert newContact;
        newContact=new Contact();
        return null;
    }    
 }