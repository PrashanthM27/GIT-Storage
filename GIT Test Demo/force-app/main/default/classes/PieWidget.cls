public class PieWidget{
public List<PieWidgetData> data{set;get;}

public List<PieWidgetData> getData(){
data=new List<PieWidgetData>();
data.add(new PieWidgetData('Jan',10));
data.add(new PieWidgetData('Feb',20));
data.add(new PieWidgetData('Mar',24));
data.add(new PieWidgetData('Mar',24));
return data;
}
public class PieWidgetData{
public String Name{set;get;}
public Integer numb{set;get;}
public PieWidgetData(String Name,Integer numb){
this.Name=Name;
this.numb=numb;
}
}
}