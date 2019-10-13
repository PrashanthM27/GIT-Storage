public class ProcessBuilderApexInvoke{
@InvocableMethod
public static void ApexMethodInvoke(List<Id> d){
List<Lead> dd=[Select Name from Lead where Id in:d];
for(Lead ld:dd){
ld.FirstName='Prathyu';
}
Upsert dd;
}
}