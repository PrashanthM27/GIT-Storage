public class GTask1 {
    public string account {set;get;}
    public string product {set;get;}
    public string type1 {set;get;}

    public List<SelectOption>getAccounts() {
        List<SelectOption> options=new List<SelectOption>();
        options.add(new SelectOption('None','--Select--'));
        options.add(new SelectOption('Acc1','Account1'));
        options.add(new  SelectOption('Acc2','Account2'));
        return options;
    }
    public List<SelectOption>getProducts(){
        List<SelectOption> options = new List<SelectOption>();
        if(account=='Acc1'){
            options.add(new SelectOption('None','--Select--'));
            options.add(new SelectOption('prod1','Product1'));
            options.add(new SelectOption('prod2','Product2'));
        }else if(account=='Acc2'){
            options.add(new SelectOption('None','--Select--'));
            options.add(new SelectOption('prod3','Product3'));
            options.add(new SelectOption('prod4','Product4'));
        }else{
            options.add(new SelectOption('None','---select---'));
        }
        return options;
    }
    public List<SelectOption> getTypes(){
        List<SelectOption> options = new List<SelectOption>();
        if(product=='prod1'){
            options.add(new SelectOption('None','--Select--'));
            options.add(new SelectOption('Sales','Sales'));
            options.add(new SelectOption('Dongle','Dongle'));     
        }else if(product=='prod2'){
            options.add(new SelectOption('None','--Select--'));
            options.add(new SelectOption('Error','Error'));
            options.add(new SelectOption('Question','Question'));    
        }else if(product=='prod3'){
            options.add(new SelectOption('None','--Select--'));
            options.add(new SelectOption('Bug','Bug'));
            options.add(new SelectOption('Enhancement','Enhancement'));
        }else if(product=='prod4'){
            options.add(new SelectOption('None','--Select--'));
            options.add(new SelectOption('Request','Request'));
            options.add(new SelectOption('Clarification','Clarification'));
        }else{
            options.add(new SelectOption('None','---select---'));
        }
        return options;
    }
}