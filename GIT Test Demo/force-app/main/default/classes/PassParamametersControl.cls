public with sharing class PassParamametersControl {

    public boolean input { get; set; }

    public boolean output { get; set; }

    public Account c { get; set; }
    public PassParamametersControl(){
      c=new Account();
      input=true;
      output=false;
    }

    public void save() {
    output=true;
    input=false;
   c.Name= ApexPages.currentPage().getParameters().get('Name');
   c.Industry= ApexPages.currentPage().getParameters().get('Industry');
   insert c;
        
    }

}