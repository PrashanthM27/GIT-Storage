public class SelectOptions{
public List<SelectOption> options{set;get;}
public SelectOptions(){
options=new List<SelectOption>();
}
public void getData(){
options.add(new SelectOption('None','None'));
options.add(new SelectOption('Text','Text'));
options.add(new SelectOption('Radio','Radio'));
options.add(new SelectOption('Number','Number'));
}
}