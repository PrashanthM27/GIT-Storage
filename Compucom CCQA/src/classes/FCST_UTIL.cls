public with sharing class FCST_UTIL { 
    
    public static final String USER_PROFILE_NAME = 'System Administrator';
    public static boolean serviceOrderExecuting = false;

     public static void InsertMappingFields(){
        Mapping_Setting__c m = new Mapping_Setting__c();
        m.Name = 'FCST Mapping Data';
        insert m;
    }   
    
    public static void InsertTriggerMappingFields(){
        FCST_Trigger__c m = new FCST_Trigger__c();
        m.Name='TriggerMapping';
        m.Account_Trigger__c = true;
        m.Product_Trigger__c = true;
        insert m;
    }   
   
    public static User createUser(){ 
         
        //Profile p = [SELECT Id FROM Profile WHERE Name=: USER_PROFILE_NAME ];
        Id idSalesProfile = [SELECT Id FROM Profile WHERE Name='System Administrator' limit 1].Id; 
        UserRole Pr = new UserRole(Name = 'Backlog Adjustment');
        insert Pr;
        
        UserRole r = new UserRole(Name = 'Backlog',ParentRoleId = Pr.Id);
        insert r;
        
        User u = new User(Alias = 'standt', Email='test18th_1@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = idSalesProfile, UserRoleId = r.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='test18th_1@testorg.com');
       insert u;

        return u;
    }
    public static Account createAccount(){
        Account Acc = new Account(Name = 'Test Account');
        return Acc;
    }
    public static Configuration_Setting__c createConfigurationSettingObj(string cyear){
        Configuration_Setting__c con = new Configuration_Setting__c();
        con.Name = cyear;
        con.Stage__c = 'Open,Prospecting,ClosedWon,ClosedLost,Solutioning,Get Approval';
        return con;
        
    }
    public static void createOpportunities() {
    
        map<string,Id> mapMeasure = new map<string,Id>(); 
        if (Schema.sObjectType.Planning_Financial_Measure__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()){
          
        for(Planning_Financial_Measure__c fm : [select Id,Name from Planning_Financial_Measure__c WHERE Id != NULL]){
            mapMeasure.put(fm.Name,fm.Id);
        }
        }
        //Date startDate = Date.newInstance(2016,01,01);
        Date startDate = date.newInstance(system.today().year(),1,1);
        Date endDate = (startDate.addMonths(1)).addDays(-1);
        map<Integer,String> mapMonthString  = new map<Integer,String>();
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
    
        Date fstartDate = date.newInstance(startDate.year(),1,1);
        Date fendDate = (startDate.addMonths(12)).addDays(-1);
        Fiscal_Year_Planning__c fyp;
        Fiscal_Year_Planning__c fyp2;
        if (Schema.sObjectType.Fiscal_Year_Planning__c.fields.Name.isCreateable()
        && Schema.sObjectType.Fiscal_Year_Planning__c.fields.StartDate__c.isCreateable()
        && Schema.sObjectType.Fiscal_Year_Planning__c.fields.EndDate__c.isCreateable()) {
        fyp = new Fiscal_Year_Planning__c(Name = string.valueOf(fstartDate.year()),StartDate__c = fstartDate,EndDate__c = fendDate);
        fyp2 = new Fiscal_Year_Planning__c(Name = string.valueOf(fstartDate.year()+1),StartDate__c = fstartDate.addYears(1),EndDate__c = fendDate.addYears(1));
        
        if(Fiscal_Year_Planning__c.SObjectType.getDescribe().isCreateable()) {
            insert fyp;
            insert fyp2;
        }
        }
        
        List<Fiscal_Year_Model__c> lstFiscalYear = new List<Fiscal_Year_Model__c>();
        
        List<Planning_Version__c>  lstVersion = new List<Planning_Version__c>();
    Integer q = 0;
        
        
        List<Fiscal_Year_Planning__c> lstInsertedYear = new List<Fiscal_Year_Planning__c>();
        if(Schema.sObjectType.Fiscal_Year_Planning__c.fields.Name.isCreateable() &&
         Schema.sObjectType.Fiscal_Year_Planning__c.fields.StartDate__c.isCreateable()) {
            lstInsertedYear  = [select Name,StartDate__c from  Fiscal_Year_Planning__c];
             
        }
        for(Fiscal_Year_Planning__c nf : lstInsertedYear ){
            startDate = nf.StartDate__c;
            endDate = startDate.addMonths(1).addDays(-1);
            for(Integer i = 1;i<13;i++){
            
            if(i > 4)q= 1;
            else if(i > 7)q= 2;
            else if(i > 10)q= 3;
            else q = 4;
            if (Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Budget_Planning_Version__c.isCreateable()
            && Schema.sObjectType.Planning_Version__c.fields.SequenceNo__c.isCreateable()
            && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Closed_Date__c.isCreateable()
            && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Start_Date__c.isCreateable()
            && Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isCreateable()
            && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Fiscal_Year__c.isCreateable()
            && Schema.sObjectType.Planning_Version__c.fields.Planning_Version_Current_Period__c.isCreateable()
            && Schema.sObjectType.Planning_Version__c.fields.Fiscal_Year_Planning__c.isCreateable()
            && Schema.sObjectType.Planning_Version__c.fields.MonthName__c.isCreateable()) {
                    lstVersion.add(
                        new Planning_Version__c(
                            //Fiscal_Year_Planning__c = fyp.Id,
                            Is_this_a_Budget_Planning_Version__c = false,
                            Is_this_a_Gap_Planning_Version__c = false,
                            SequenceNo__c = i,
                            Data_Entry_Closed_Date__c= endDate ,
                            Data_Entry_Start_Date__c  = startDate ,
                            Version_Status__c= 'Closed',
                            Planning_Version_Fiscal_Year__c = string.valueOf(startDate.year()),
                            Planning_Version_Current_Period__c= i+'',
                            Fiscal_Year_Planning__c = fyp.Id,
                            MonthName__c = mapMonthString.get(i)
                        ));
                lstVersion.add(
                        new Planning_Version__c(
                            //Fiscal_Year_Planning__c = fyp.Id,
                            Is_this_a_Budget_Planning_Version__c = true,
                            Is_this_a_Gap_Planning_Version__c = true,
                            SequenceNo__c = i,
                            Data_Entry_Closed_Date__c= endDate ,
                            Data_Entry_Start_Date__c  = startDate ,
                            Version_Status__c= 'Closed',
                            Planning_Version_Fiscal_Year__c = string.valueOf(startDate.year()),
                            Planning_Version_Current_Period__c= i+'',
                            Fiscal_Year_Planning__c = fyp.Id,
                            MonthName__c = mapMonthString.get(i)
                        ));
            }
            if (Schema.sObjectType.Fiscal_Year_Model__c.fields.Name.isCreateable()
            && Schema.sObjectType.Fiscal_Year_Model__c.fields.End_Date__c.isCreateable()
            && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Quarter__c.isCreateable()
            && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Year__c.isCreateable()
            && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Name__c.isCreateable()
            && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Number__c.isCreateable()
            && Schema.sObjectType.Fiscal_Year_Model__c.fields.Start_Date__c.isCreateable()) {    
            lstFiscalYear.add(
              new Fiscal_Year_Model__c(
                Name = 'FY'+string.valueOf(startDate.year())+'P'+i,
                End_Date__c = endDate,
                Fiscal_Quarter__c = 'Q'+q,
                Fiscal_Year__c = string.valueOf(startDate.year()),
                Period_Name__c = mapMonthString.get(i),
                Period_Number__c = i,
                Start_Date__c = startDate
            ));
            }
            startDate  = endDate.addDays(1);
                    endDate = (startDate.addmonths(1)).addDays(-1);
        
            } 
        }
    }
    public static Planning_Financial_Measure__c createMeasure(string mName){
        Planning_Financial_Measure__c FMObj = new Planning_Financial_Measure__c( 
        Name = mName,
        Automatically_Calculated__c= true , 
        Measure_Description__c = 'test',
        Measure_Type__c = 'Income',
        Record_Source__c = 'Installation',
        Unit_of_Measure__c = 'Currency',
        Restricted_by_Revenue_Term__c =false);
        return FMObj;
    }
    
    
            
    public static FCST_Revenue_Recognization_Product__c CreateRevenueRegognization(string period,String code,decimal amount){
       FCST_Revenue_Recognization_Product__c rr = new FCST_Revenue_Recognization_Product__c();
        rr.Period__c = period;
        rr.Amount__c = amount;
        rr.Product_Code__c= code;
        return rr;
    }       
    public static opportunity createOpportunity(string oppName, string AccId, string RT){
        
        Opportunity Opp = new Opportunity(
            name = oppName,
            Deal_TCV__c = 100,
            accountId = AccId,
            Deal_Duration__c = 12,
            Amount = 100,
            Record_Type__c = RT,
            StageName='Closed Won',
            Project_Start_Date__c = date.today(),
            CloseDate=date.today()
           
        );
        return opp;
    }
     public static opportunity createOpportunity1(string oppName, string AccId){
        
        Opportunity Opp = new Opportunity(
            name = oppName,
            Deal_TCV__c = 100,
            accountId = AccId,
            Deal_Duration__c = 12,
            Amount = 250000,
            StageName='Closed Won',
            Project_Start_Date__c = date.today(),
            CloseDate=date.today()
           
        );
        return opp;
    }
    public static OpportunityLineItem createOpportunityProduct(Opportunity opp, Product2 prod, PricebookEntry PricebookEntRYObj){

        OpportunityLineItem p = new OpportunityLineItem();
        p.OpportunityId = opp.Id;
        p.Product2Id = prod.id;
        p.PricebookEntryId = PricebookEntRYObj.id;
        p.ServiceDate = system.today();
        p.Quantity=1;
        p.TotalPrice=20000;
        return p;
    }
    
    public static PricebookEntry createPricebookEntry( Id pricebookId, Product2 prod){

        PricebookEntry p = new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = prod.Id,UnitPrice = 1000,IsActive = true);
        return p;
    }
    
   /* public static void CreateSubmittedDate(){
        Submission_Dates__c sd = new Submission_Dates__c(Name = 'TEST345',start_Date__c = system.today().addYears(-10),end_Date__c = system.today().addYears(10));
        insert sd;
    }*/
    
    public static Product2 createProduct(string Name,String code,Decimal accId){
        Product2 p = new Product2();
        p.Name = Name;
        p.ProductCode = code;
        p.Account_Id__c = accId;
        return p;
    }
     public static List<Fiscal_Year_Planning__c> createFiscalYear(List<string> lstYears){
        List<Fiscal_Year_Planning__c> lstFY = new List<Fiscal_Year_Planning__c>();
        for(string syear : lstYears){
            Date fstartDate = Date.newInstance(Integer.valueOf(syear),1,1);
            Date fendDate = Date.newInstance(Integer.valueOf(syear),12,31);
            lstFY.add(new Fiscal_Year_Planning__c(Name = syear,StartDate__c = fstartDate,EndDate__c = fendDate));
        }
        return lstFY;
    }
     public static List<Planning_Version__c> createPlanningVersion(List<Fiscal_Year_Planning__c> lstFY)
    {
        List<Planning_Version__c> lstFYP = new List<Planning_Version__c>();     
        Integer q = 0;
        map<Integer,String> mapMonthString  = new map<Integer,String>();
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        for(Fiscal_Year_Planning__c f : lstFY){
            Date startDate = f.StartDate__c;
            Date endDate = (startDate.addMonths(1)).adddays(-1);
            boolean isOpenAdmin=true;
            for(Integer i = 1;i<=12;i++){            
                if(i > 4)q= 1;
                else if(i > 7)q= 2;
                else if(i > 10)q= 3;
                else q = 4;
                
                Planning_Version__c np = new Planning_Version__c();
                np.Is_this_a_Budget_Planning_Version__c = false;
                np.Is_this_a_Gap_Planning_Version__c  = false;
                np.SequenceNo__c = i;
                np.Data_Entry_Closed_Date__c= endDate;
                np.Data_Entry_Start_Date__c  = startDate;
                np.Planning_Version_Fiscal_Year__c = f.Name;
                np.Planning_Version_Current_Period__c= i+'';
                np.Fiscal_Year_Planning__c = f.Id;
                np.MonthName__c = mapMonthString.get(i);
                np.OpenByInProgressVersion__c=false;
                np.Version_Status__c= 'Not Open';
                if(isOpenAdmin)np.Version_Status__c= 'Open (Admin)';
                lstFYP.add(np);
                
                isOpenAdmin = false;
                startDate  = startDate.addMonths(1);
                endDate = endDate.addMonths(1);
            }
            
            Planning_Version__c mp = new Planning_Version__c();
            mp.Is_this_a_Budget_Planning_Version__c = false;
            mp.Is_this_a_Gap_Planning_Version__c  = true;
            mp.SequenceNo__c = 201;
            mp.Data_Entry_Closed_Date__c= f.EndDate__c;
            mp.Data_Entry_Start_Date__c  = f.StartDate__c;
            mp.Planning_Version_Fiscal_Year__c = f.Name;
            mp.Planning_Version_Current_Period__c= '201';
            mp.Fiscal_Year_Planning__c = f.Id;
            mp.MonthName__c = 'GapMonth';
            mp.OpenByInProgressVersion__c=true;
            mp.Version_Status__c= 'Open (Admin)';
            lstFYP.add(mp);
                
        }
        return lstFYP;
    }
     public static List<Fiscal_Year_Model__c> createFiscalYearPeriods(List<Fiscal_Year_Planning__c> lstFY)
    {
        List<Fiscal_Year_Model__c> lstFYP = new List<Fiscal_Year_Model__c>();       
        Integer q = 0;
        map<Integer,String> mapMonthString  = new map<Integer,String>();
        mapMonthString .put(1,'January');
        mapMonthString .put(2,'February');
        mapMonthString .put(3,'March');
        mapMonthString .put(4,'April');
        mapMonthString .put(5,'May');
        mapMonthString .put(6,'June');
        mapMonthString .put(7,'July');
        mapMonthString .put(8,'August');
        mapMonthString .put(9,'September');
        mapMonthString .put(10,'October');
        mapMonthString .put(11,'November');
        mapMonthString .put(12,'December');
        for(Fiscal_Year_Planning__c f : lstFY){
            Date startDate = f.StartDate__c;
            Date endDate = (startDate.addMonths(1)).adddays(-1);
            for(Integer i = 1;i<=12;i++){            
                if(i > 4)q= 1;
                else if(i > 7)q= 2;
                else if(i > 10)q= 3;
                else q = 4;
                if(i<=9){
                lstFYP.add(
                    new Fiscal_Year_Model__c(
                    Name = 'FY'+f.Name+'P0'+i,
                    End_Date__c = endDate,
                    Fiscal_Quarter__c = 'Q'+q,
                    Fiscal_Year__c = f.Name,
                    Period_Name__c = mapMonthString.get(i),
                    Period_Number__c = i,
                    Start_Date__c = startDate
                ));
                }
                if(i>=10){
                     lstFYP.add(
                    new Fiscal_Year_Model__c(
                    Name = 'FY'+f.Name+'P'+i,
                    End_Date__c = endDate,
                    Fiscal_Quarter__c = 'Q'+q,
                    Fiscal_Year__c = f.Name,
                    Period_Name__c = mapMonthString.get(i),
                    Period_Number__c = i,
                    Start_Date__c = startDate
                ));
                }
                startDate  = startDate.addMonths(1);
                endDate = endDate.addMonths(1);
            }
        }
        return lstFYP;
    }
}