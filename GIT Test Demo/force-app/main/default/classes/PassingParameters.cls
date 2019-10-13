public with sharing class PassingParameters {
    public String Name{set;get;}
    public List<Account> acc{set;get;}
    public Boolean Search{set;get;}
    public PassingParameters(){
        Search=false;
        String searchName=ApexPages.currentPage().getParameters().get('name');
        if(searchName!=null){
            Name=searchName;
        }
    }
    public PageReference searchButton(){
        search=true;
        String nameSearch='%'+name+'%';
        acc=[Select Id,Name,Industry,Phone from Account where Name like:nameSearch];
      return null;
    }
}