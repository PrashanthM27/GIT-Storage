public class WrapperTable {
    public WrapperDetails details{set;get;}
    public Integer num{set;get;}
    public String branch{set;get;}
    public WrapperTable(String name,Double salary,Integer num,String branch){
        details=new WrapperDetails();
        details.name=name;
        details.salary=salary;
        this.num=num;
        this.branch=branch;
    }   
    public class WrapperDetails{
        public String name{set;get;}
        public Double salary{set;get;}
        
    }
}