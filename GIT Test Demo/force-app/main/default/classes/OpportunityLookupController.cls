public with sharing class OpportunityLookupController
{
    public Opportunity oppt{get;set;}
    public Opportunity opp2{get;set;}

    public String OpportunityId {get;set;}
    public OpportunityLookupController(ApexPages.StandardController controller) 
    {
        OpportunityId = ApexPages.currentPage().getParameters().get('OpptyId');

        opp2= new Opportunity();
    }
}