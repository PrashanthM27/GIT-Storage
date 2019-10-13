@isTest
public class Test_PopupController {
    static testMethod void Test_Popup(){

       /* List<Account> acList = new List<Account>();
            for(Integer i=0;i<20;i++){
                Account ac = new Account();
                ac.Name = 'Account';
                acList.add(ac);
            }
            if(acList!=null && !acList.isEmpty()){
                insert acList;
            }*/
            
            List<Opportunity> optList = new List<Opportunity>();
            for(Integer i=0;i<20;i++){
                Opportunity opt = new Opportunity();
                opt.Name = '1Oppy for Closed';
               // opt.AccountId = acList[0].Id;
                opt.StageName = 'Closed Won';
                opt.CloseDate = System.today();
                optList.add(opt);
            }
            if(optList!=null && !optList.isEmpty()){
                insert optList;
            }
                        
            Id pricebookId = Test.getStandardPricebookId();
            Product2 prod = new Product2(
                Name = 'Product X',
                ProductCode = 'Pro-X',
                isActive = true,Family= 'None'
            );
            insert prod;
            PricebookEntry pbEntry = new PricebookEntry(
                Pricebook2Id = pricebookId,
                Product2Id = prod.Id,
                UnitPrice = 100.00,
                IsActive = true
            );
            insert pbEntry;
            OpportunityLineItem oli = new OpportunityLineItem(
                OpportunityId = optList[0].Id,
                Quantity = 5,
                PricebookEntryId = pbEntry.Id
                
            );
            oli.TotalPrice = oli.quantity * pbEntry.UnitPrice;
           // oli.Risk_Factor__c = 0;
            insert oli;
            
    }
}