public class ProcessBuilderApexCall{
@InvocableMethod
public static void QuoteDetails(List<Id> oppIds){
List<Quote> quotes=[Select Id from Quote where Opportunity.Id in:oppIds];
delete quotes;
}
}