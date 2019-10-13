public class GetAccConOpp{
public Account aa{set;get;}
public Contact con{set;get;}
public Opportunity op{set;get;}
public GetAccConOpp(){
aa=new Account();
con=new Contact();
op=new Opportunity();
}
public PageReference Refer(){
PageReference pg=new PageReference('/apex/newPage');
pg.setRedirect(true);
return pg;
}
public void Save(){
if(aa.Name!=null&&aa.Name!=''){
insert aa;
}
if(aa.Id!=null&&con.LastName!=null&&con.LastName!=''){
con.AccountId=aa.Id;
insert con;
}
if(aa.Id!=null&&op.Name!=null&&op.Name!=''){
op.AccountId=aa.Id;
insert op;
}
}
}