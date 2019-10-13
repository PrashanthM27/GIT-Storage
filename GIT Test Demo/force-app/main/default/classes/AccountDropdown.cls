public class AccountDropdown {
    public string callfunc{get;set;}
    Public String Accid {set;get;}
    List<Selectoption> options = new List<Selectoption>();
    Public List<Selectoption> getrecords() {
        options.add(new Selectoption('Nothing', 'Select a Account'));
        for(Account a : [select id,name from account]) {
            options.add(new Selectoption(a.id, a.name));
        }
        return options;
    }
    public void main(){
        if(accid == 'nothing'){
            callfunc = '<script> alertBox(); </script>';
        }
    }
}