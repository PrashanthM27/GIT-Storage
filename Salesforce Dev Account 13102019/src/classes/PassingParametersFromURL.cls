public class PassingParametersFromURL{
public String name{Set;get;}
public String city{set;get;}
public PassingParametersFromURL(){
name=ApexPages.CurrentPage().getParameters().get('name');
city=ApexPages.CurrentPage().getParameters().get('city');
}
}