global class BatchClass2 implements Database.Batchable<Sobject> {
    public Database.QueryLocator Start(Database.BatchableContext bc){
        return Database.getQueryLocator([Select Id,LastName from Lead]);
    }
    public void Execute(Database.BatchableContext bc,List<Lead> scope){
        for(Lead d:scope){
            d.LeadSource='Prathyusha';            
        }
        update scope;
    }
    public void Finish(Database.BatchableContext bc){
        
    }
}