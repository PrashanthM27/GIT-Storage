public class SelectOptcls{
    public String State{set;get;}
    public String City{set;get;}
    public List<SelectOption> getStates(){
        List<SelectOption> options=new List<SelectOption>();
        SelectOption op=new SelectOption('**None**','**None**');
        SelectOption op1=new SelectOption('TG','TG');
        SelectOption op2=new SelectOption('TN','TN');
        SelectOption op3=new SelectOption('KA','KA');
        options.add(op);
        options.add(op1);
        options.add(op2);
        options.add(op3);
        return options;
    }
    public List<SelectOption> getCities(){
        List<SelectOption> options2=new List<SelectOption>();
        if(state=='TG'){
            options2.add(new SelectOption('Hyd','Hyd'));
            options2.add(new SelectOption('KMM','KMM'));
        }
        else if(state=='TN'){
            options2.add(new SelectOption('Chennai','Chennai'));
            options2.add(new SelectOption('Madhurai','Madhurai'));
        }else{
                options2.add(new SelectOption('None','None'));
            }
                return options2;
        }
        }