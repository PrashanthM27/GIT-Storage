public with sharing class FCST_FiscalSynchronization{
    
    public static void Init(){ 
        integer fstartmonth = [SELECT FiscalYearStartMonth  FROM Organization].FiscalYearStartMonth;
        if(fstartmonth < 1){
           system.debug(system.Label.No_Standard_Fiscal_Year);
           apexpages.addMessage(new apexpages.Message(apexpages.severity.error,system.Label.No_Standard_Fiscal_Year)); 
           return;                    
        }
        else{
            CheckDuplicateFiscalYear(fstartmonth,(system.today()).year());
        }
    } 
    /*public static void CreateCustomCalendarMonth(){
        map<string,FS_Calendar__c> mapCalendar = FS_Calendar__c.getAll();
        if(mapCalendar.size() <> 12){
            map<Integer,string> mapLongLevel = new map<Integer,string>();
            mapLongLevel.put(1,'January');
            mapLongLevel.put(2,'February');
            mapLongLevel.put(3,'March');
            mapLongLevel.put(4,'April');
            mapLongLevel.put(5,'Map');
            mapLongLevel.put(6,'June');
            mapLongLevel.put(7,'July');
            mapLongLevel.put(8,'August');
            mapLongLevel.put(9,'September');
            mapLongLevel.put(10,'October');
            mapLongLevel.put(11,'November');
            mapLongLevel.put(12,'December');
            List<FS_Calendar__c> lstCalendar = new List<FS_Calendar__c>();
            for(Integer i=1;i<=12;i++){
                if(!mapCalendar.containsKey(string.valueOf(i))){
                    FS_Calendar__c cal = new FS_Calendar__c();
                    cal.Name = string.valueOf(i);
                    cal.Long_Label__c= mapLongLevel.get(i);
                    cal.Short_Label__c= mapLongLevel.get(i);                    
                    lstCalendar.add(cal);
                }
            } 
            insert lstCalendar;           
        }
    }*/
    public static void CheckDuplicateFiscalYear(Integer smonth,Integer fyear){
        string sfyear = string.valueOF(fyear);
        List<Fiscal_Year_Planning__c> lstFiscalYear = [select Id from Fiscal_Year_Planning__c where name =: sfyear ];
        if(lstFiscalYear.size() > 0){
            system.debug(system.Label.Duplicate_Fiscal_Year);
            apexpages.addMessage(new apexpages.Message(apexpages.severity.error,system.Label.Duplicate_Fiscal_Year)); 
            return;   
        }
        else{
            CreateFiscalYear(smonth,fyear);
        }
    }
    public static void CreateFiscalYear(Integer smonth,Integer fyear){
        
        Organization  orgobj = [SELECT FiscalYearStartMonth,UsesStartDateAsFiscalYearName  FROM Organization];
        date startDate = date.newInstance(fyear,orgobj.FiscalYearStartMonth,1);
        date endDate;
        if(!orgobj.UsesStartDateAsFiscalYearName){
            startDate = date.newInstance(fyear-1,orgobj.FiscalYearStartMonth-1,1);
            endDate = startDate.addMonths(14);
        }else{
            endDate = startDate.addMonths(12);
        }
        endDate = endDate.adddays(-1);
        
        Fiscal_Year_Planning__c obj = new Fiscal_Year_Planning__c();
        obj.Name = string.valueOF(fyear);
        obj.StartDate__c = startDate;
        obj.EndDate__c = endDate;
        
        try{
            insert obj;
        }catch(Exception e){
            system.debug(e.getMessage());
            apexpages.addMessage(new apexpages.Message(apexpages.severity.error,string.valueOf(e.getMessage()))); 
            return; 
        }
    }
    
        public static void createFSPeriods(List<Fiscal_Year_Planning__c> lstFSYear) {
    
        map<String,FS_Calendar__c> mapCalendar = new map<string,FS_Calendar__c>();
        List<Fiscal_Year_Model__c> lstPerids = new List<Fiscal_Year_Model__c>();
        
        
        for(FS_Calendar__c f : [select Name,Short_Label__c,long_Label__c from FS_Calendar__c]){
            mapCalendar.put(f.Name,f);
        }

        for(Fiscal_Year_Planning__c f : lstFSYear){
            
            date startDate = f.startdate__c;
            date endDate = (startDate).addMonths(1).addDays(-1);
            for(Integer index=1;index<=12;index++){
                string sno = (index > 9)?string.valueOf(index):string.valueOf('0'+index);
                
                Fiscal_Year_Model__c p = new Fiscal_Year_Model__c();
                p.Fiscal_Planning_Year__c = f.Id;                
                p.Name = 'FY'+f.name+'P'+sno;                                  
                p.Fiscal_Year__c = f.name;   
                p.Fiscal_Quarter__c =(startDate.Month() < 4)?'Q1':(startDate.Month() < 7)?'Q2':(startDate.Month() < 10)?'Q3':'Q4';
                p.Period_Name__c= string.valueOf(startDate.Month());
                p.Record_Source__c = 'Installation';                
                p.Period_Number__c = index;
                p.Month_Number__c = startDate.Month();
                p.Start_Date__c = startDate;
                p.End_Date__c = endDate;
                
                if(mapCalendar.containsKey(string.valueOf(startDate.Month()))){
                   FS_Calendar__c  cal=  mapCalendar.get(string.valueOf(startDate.Month()));
                   p.Period_Name__c= cal.long_Label__c;
                   p.Long_Label__c = cal.Long_Label__c;
                   p.Short_Label__c = cal.Short_Label__c;
                   
                }
                
                
                lstPerids.add(p);
                
                startDate = endDate.addDays(1);
                endDate = (startDate).addMonths(1).addDays(-1);
            }
        }
        if(lstPerids.size()>0){
            try{
                insert lstPerids;
            }catch(Exception e){
                
            }
        }
        
    }
    
    public static void createFSVersion(List<Fiscal_Year_Model__c> lstFSPeriod) {
    
        map<String,FS_Calendar__c> mapCalendar = new map<string,FS_Calendar__c>();
        List<Planning_Version__c> lstVersion = new List<Planning_Version__c>();
        
        
        for(FS_Calendar__c f : [select Name,Short_Label__c,long_Label__c from FS_Calendar__c]){
            mapCalendar.put(f.Name,f);
        }

        for(Fiscal_Year_Model__c f : lstFSPeriod){

                Planning_Version__c p = new Planning_Version__c();
                p.Fiscal_Year_Planning__c = f.Fiscal_Planning_Year__c;
                p.Fiscal_Period__c = f.Id;
                p.Name = f.Fiscal_Year__c+'-'+f.Period_Name__c;
                p.MonthName__c = f.Period_Name__c;
                p.Planning_Version_Current_Period__c = string.valueOf(f.Month_Number__c);
                p.Planning_Version_Fiscal_Year__c = f.Fiscal_Year__c;
                p.Record_Source__c = 'Installation';
                p.SequenceNo__c = f.Period_Number__c;
                p.Period_Number__c = f.Period_Number__c;
                p.Month_Number__c = f.Month_Number__c;
                p.Data_Entry_Start_Date__c = f.Start_Date__c;
                p.Short_Label__c = f.Short_Label__c;
                p.Long_Label__c = f.long_Label__c;
                p.Data_Entry_Closed_Date__c = f.End_Date__c;
                p.Version_Status__c = 'Not Open';
                lstVersion.add(p);
            
        }
        if(lstVersion.size()>0){
            try{
                insert lstVersion;
            }catch(Exception e){
                
            }
        }
        
    }
    /*public static void UpsertAdditionalPlanningYear(List<Additional_Planning_Versions__c> lstAddPlanVer, map<Id,Additional_Planning_Versions__c> Oldmap){
        List<Additional_Planning_Versions__c> lstAdditionalPlanning = [select Id,Name,Version_Description__c from Additional_Planning_Versions__c where Id IN: lstAddPlanVer];
        List<Planning_Version__c> lstPlanningversion = new List<Planning_Version__c>();
       
        List<Fiscal_Year_Planning__c> lstfiscalsetting = [select Id,EndDate__c,Name,StartDate__c from Fiscal_Year_Planning__c where name <> null order by startdate__c ];
        if(Oldmap == null){
            
            // get Max Sequence Number for Additional Planning Version
            Map<String,Integer> mapYearMaxSeq = new Map<String,Integer>();
            AggregateResult[] lstSeqNo = [SELECT Planning_Version_Fiscal_Year__c year,MAX(SequenceNo__c)seq FROM Planning_Version__c where Is_this_a_Budget_Planning_Version__c = true Group By Planning_Version_Fiscal_Year__c];
            
            for (AggregateResult ar : lstSeqNo)  {
                mapYearMaxSeq.put(String.ValueOf(ar.get('year')),Integer.ValueOf(String.ValueOf(ar.get('seq'))));
            }
        
            for(Fiscal_Year_Planning__c fiscal :  lstfiscalsetting ){
                Integer seq = 99;
                if(mapYearMaxSeq.ContainsKey(fiscal.Name))
                    seq = mapYearMaxSeq.get(fiscal.Name);
                for(Additional_Planning_Versions__c ap: lstAdditionalPlanning ){
                    seq++;
                    lstPlanningversion.add(
                        new Planning_Version__c(
                            Fiscal_Year_Planning__c = fiscal.Id,
                            Name = fiscal.Name+'-'+ap.Name,
                            Additional_Planning_Version__c = ap.Id,
                            Is_this_a_Budget_Planning_Version__c = true,
                            SequenceNo__c = seq,
                            Data_Entry_Closed_Date__c= fiscal.EndDate__c,
                            Data_Entry_Start_Date__c  = fiscal.StartDate__c,
                            Version_Status__c= 'Not Open',
                            Planning_Version_Fiscal_Year__c = fiscal.Name,
                            Planning_Version_Current_Period__c= string.valueOf(seq),
                            MonthName__c =ap.Name,
                            Planning_Version_Description__c = ap.Version_Description__c 
                        )        
                    );
                }
            }
        }
        else if(Oldmap <> null){
            map<Id,Additional_Planning_Versions__c> mapPlanningVersion = new map<Id,Additional_Planning_Versions__c>();
            for(Additional_Planning_Versions__c ap: lstAdditionalPlanning ){
                mapPlanningVersion.put(ap.Id,ap);
            }
            
            for(Planning_Version__c pv : [select Id,Planning_Version_Fiscal_Year__c,MonthName__c,Additional_Planning_Version__c,Planning_Version_Description__c from Planning_Version__c where Additional_Planning_Version__c IN: mapPlanningVersion.keySet() and Is_this_a_Budget_Planning_Version__c = true]){
                pv.Name = pv.Planning_Version_Fiscal_Year__c+'-'+mapPlanningVersion.get(pv.Additional_Planning_Version__c).Name;
                pv.MonthName__c = mapPlanningVersion.get(pv.Additional_Planning_Version__c).Name;
                pv.Planning_Version_Description__c = mapPlanningVersion.get(pv.Additional_Planning_Version__c).Version_Description__c;
                
                lstPlanningversion.add(pv);
            }
            
        }
        
        if(lstPlanningversion.size()>0){
            upsert lstPlanningversion;
        }
    }*/
    public static void deleteAddPlanningVersion(map<Id,Additional_Planning_Versions__c> oldmap){
        List<Planning_Version__c> lstdeletePlanning = [select Id,Additional_Planning_Version__c from Planning_Version__c where Additional_Planning_Version__c IN: OldMap.keyset()];
        delete lstdeletePlanning;
    }
  public Static void putAdditionalPlanningVersion(){
    map<String,String> mapAPDesc = new map<String,String>();
    mapAPDesc.put('Budget01','');
    mapAPDesc.put('Budget02','');
    mapAPDesc.put('Budget03','');
    
    map<String,Additional_Planning_Versions__c> MapOrgAP = new Map<String,Additional_Planning_Versions__c>();
    for(Additional_Planning_Versions__c AP : [select Name,Version_Description__c from Additional_Planning_Versions__c where name <> null]){
        MapOrgAP.put(AP.Name,AP);
    }
    List<Additional_Planning_Versions__c> lstAddPlanning = new List<Additional_Planning_Versions__c>();
    for(String AP : mapAPDesc.keySet()){
        Additional_Planning_Versions__c APObj;
        if(MapOrgAP.containsKey(AP)){
            APObj = MapOrgAP.get(AP);
        }
        else{
            APObj = new Additional_Planning_Versions__c(
            Name = AP,
            Version_Description__c = mapAPDesc.get(AP),
            Record_Source__c = 'Installation');
        }
        lstAddPlanning.add(APObj);
    }
    if(lstAddPlanning.size()>0){
        try{
        upsert lstAddPlanning;
        }
        catch(Exception e){
            //
        }
    }
    //
}
 public Static void putFinancialMeasure(){

        map<String,String> mapFMDesc = new map<String,String>();
        mapFMDesc.put('Revenue','Revenue recognized');
        mapFMDesc.put('Revenue Adjustment','Adjustment to Revenue recognized');
        mapFMDesc.put('Revenue Backlog','Revenue Backlog calculated');
        mapFMDesc.put('Sales Booking','Sales Booking recognized');
        mapFMDesc.put('Gap Mitgation','Gap Mitgation Booking recognized');
        
        map<String,String> mapFMType = new map<String,String>();
        mapFMType.put('Revenue','Income');
        mapFMType.put('Revenue Adjustment','Income');
        mapFMType.put('Revenue Backlog','KPI');
        mapFMType.put('Sales Booking','KPI');
        mapFMType.put('Gap Mitgation','KPI');
        
        
        map<String,Planning_Financial_Measure__c> MapOrgFM = new Map<String,Planning_Financial_Measure__c>();
        for(Planning_Financial_Measure__c FM : [select Name,Measure_Description__c,Measure_Type__c  from Planning_Financial_Measure__c where name <> null]){
            MapOrgFM.put(FM.Name,FM);
        }
       
        List<Planning_Financial_Measure__c> lstFinancialMeasure = new List<Planning_Financial_Measure__c>();
        for(String FM : mapFMDesc.keySet()){
            Planning_Financial_Measure__c FMObj;
            if(MapOrgFM.containsKey(FM)){
                FMObj = MapOrgFM.get(FM);
            }
            else{
                Boolean AutoCalculated = false; 
                if(FM == 'Revenue Backlog') 
                    AutoCalculated = true;
                    FMObj = new Planning_Financial_Measure__c( 
                        Name = FM,Automatically_Calculated__c= AutoCalculated , 
                        Measure_Description__c = mapFMDesc.get(FM),
                        Measure_Type__c = mapFMType.get(FM),
                        Record_Source__c = 'Installation',
                        Unit_of_Measure__c = 'Currency',
                        Restricted_by_Revenue_Term__c = !AutoCalculated 
                    );
            }
            lstFinancialMeasure.add(FMObj);
        }

        if(lstFinancialMeasure.size()>0){
            try{
              upsert lstFinancialMeasure; 
            }
            catch(Exception e){
                
            }
        }
    }
    
    public static void CreatePlanningVersionForAdditional(set<string> setFYesr){
        List<Additional_Planning_Versions__c> lstAdditionalPlanning = [select Id,Name,Version_Description__c from Additional_Planning_Versions__c];
        List<Planning_Version__c> lstPlanningversion = new List<Planning_Version__c>();
       
        List<Fiscal_Year_Planning__c> lstfiscalsetting = [select Id,EndDate__c,Name,StartDate__c from Fiscal_Year_Planning__c where name IN: setFYesr];
    
        Map<String,Integer> mapYearMaxSeq = new Map<String,Integer>();
        AggregateResult[] lstSeqNo = [SELECT Planning_Version_Fiscal_Year__c year,MAX(SequenceNo__c)seq FROM Planning_Version__c where Is_this_a_Budget_Planning_Version__c = true Group By Planning_Version_Fiscal_Year__c];
        
        for (AggregateResult ar : lstSeqNo)  {
            mapYearMaxSeq.put(String.ValueOf(ar.get('year')),Integer.ValueOf(String.ValueOf(ar.get('seq'))));
        }
    
        for(Fiscal_Year_Planning__c fiscal :  lstfiscalsetting ){
            Integer seq = 99;
            if(mapYearMaxSeq.ContainsKey(fiscal.Name))
                seq = mapYearMaxSeq.get(fiscal.Name);
            for(Additional_Planning_Versions__c ap: lstAdditionalPlanning ){
                seq++;
                lstPlanningversion.add(
                    new Planning_Version__c(
                        Fiscal_Year_Planning__c = fiscal.Id,
                        Name = fiscal.Name+'-'+ap.Name,
                        Additional_Planning_Version__c = ap.Id,
                        Is_this_a_Budget_Planning_Version__c = true,
                        SequenceNo__c = seq,
                        Data_Entry_Closed_Date__c= fiscal.EndDate__c,
                        Data_Entry_Start_Date__c  = fiscal.StartDate__c,
                        Version_Status__c= 'Not Open',
                        Planning_Version_Fiscal_Year__c = fiscal.Name,
                        Planning_Version_Current_Period__c= string.valueOf(seq),
                        MonthName__c =ap.Name,
                        Planning_Version_Description__c = ap.Version_Description__c 
                    )        
                );
            }
        }
        
        insert lstPlanningversion;
        
    }
    public static void CreatePlanningVersionForGap(set<string> setFYesr){
        List<Gap_Planning_Version__c> lstAdditionalPlanning = [select Id,Name,Version_Description__c from Gap_Planning_Version__c];
        List<Planning_Version__c> lstPlanningversion = new List<Planning_Version__c>();
       
        List<Fiscal_Year_Planning__c> lstfiscalsetting = [select Id,EndDate__c,Name,StartDate__c from Fiscal_Year_Planning__c where name IN: setFYesr];
    
        Map<String,Integer> mapYearMaxSeq = new Map<String,Integer>();
        AggregateResult[] lstSeqNo = [SELECT Planning_Version_Fiscal_Year__c year,MAX(SequenceNo__c)seq FROM Planning_Version__c where Is_this_a_Gap_Planning_Version__c = true Group By Planning_Version_Fiscal_Year__c];
        
        for (AggregateResult ar : lstSeqNo)  {
            mapYearMaxSeq.put(String.ValueOf(ar.get('year')),Integer.ValueOf(String.ValueOf(ar.get('seq'))));
        }
    
        for(Fiscal_Year_Planning__c fiscal :  lstfiscalsetting ){
            Integer seq = 199;
            if(mapYearMaxSeq.ContainsKey(fiscal.Name))
                seq = mapYearMaxSeq.get(fiscal.Name);
            for(Gap_Planning_Version__c ap: lstAdditionalPlanning ){
                seq++;
                lstPlanningversion.add(
                    new Planning_Version__c(
                        Fiscal_Year_Planning__c = fiscal.Id,
                        Name = fiscal.Name+'-'+ap.Name,
                        Gap_Planning_Version__c = ap.Id,
                        Is_this_a_Budget_Planning_Version__c = false,
                        Is_this_a_Gap_Planning_Version__c = true,
                        SequenceNo__c = seq,
                        Data_Entry_Closed_Date__c= fiscal.EndDate__c,
                        Data_Entry_Start_Date__c  = fiscal.StartDate__c,
                        Version_Status__c= 'Not Open',
                        Planning_Version_Fiscal_Year__c = fiscal.Name,
                        Planning_Version_Current_Period__c= string.valueOf(seq),
                        MonthName__c =ap.Name,
                        Planning_Version_Description__c = ap.Version_Description__c 
                    )        
                );
            }
        }        
        insert lstPlanningversion;
    }
        


}