public class PickListYears {
    public String YearValue{set;get;}
    public Boolean YearValue1{set;get;}
    public Boolean YearValue2{set;get;}
    public List<SelectOption> picklist(){
        List<SelectOption> options=new List<SelectOption>();
        options.add(new SelectOption('-None-','None'));
        options.add(new SelectOption('1','2010'));
        options.add(new SelectOption('2','2011'));
        return options;
    }
    public void pickFields(){
        if(YearValue=='1')
            YearValue1=true;
        else
            YearValue2=true;
}
}