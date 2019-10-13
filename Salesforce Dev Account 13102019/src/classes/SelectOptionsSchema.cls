public class SelectOptionsSchema {
    public List<SelectOption> options{set;get;}
    public SelectOptionsSchema(){
        options=new List<SelectOption>();
        Map<String,Schema.Sobjecttype> data=Schema.getGlobalDescribe();
        Set<String> keys=data.keyset();
        for(String str:keys){
            SelectOption opt=new SelectOption(str,str);
            options.add(opt);
        }
    }
}