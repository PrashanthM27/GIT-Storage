public class PopupOpptProductController {
    public List<Opportunity> oppList{set;get;}
    public PopupOpptProductController(){
        oppList = [SELECT Id, Name, Account.Name, 
  (SELECT Quantity, UnitPrice, TotalPrice, 
   PricebookEntry.Name, PricebookEntry.Product2.Family FROM 
   OpportunityLineItems) 
FROM Opportunity ];
        
    }
}