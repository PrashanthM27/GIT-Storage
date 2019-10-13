public class CommandLinkcls{
public String Name{Set;get;}
public String Industry{set;get;}
public String Phone{set;get;}
public Integer RollNo{set;get;}
public void getreturn(){
Name=ApexPages.CurrentPage().getParameters().get('Name');
Industry=ApexPages.currentPage().getParameters().get('Industry');
Phone=ApexPages.currentPage().getParameters().get('Phone');
RollNo=Integer.valueOf(Apexpages.currentPage().getParameters().get('RollNo'));
}
}