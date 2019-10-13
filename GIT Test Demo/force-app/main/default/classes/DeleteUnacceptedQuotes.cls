public class DeleteUnacceptedQuotes{
public static void deleteQuotes(List<Id> oppIds){
List<Quote> quotes=[Select Id from Quote where Opportunity.id in:oppIds];
delete quotes;
}
}