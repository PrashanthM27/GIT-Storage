public class ApexExmp {
    public void getDataFromObject(){
        Account a=[Select Id,Name from Account where ID =:ApexPages.currentPage().getParameters().get('Id')];
    }
}