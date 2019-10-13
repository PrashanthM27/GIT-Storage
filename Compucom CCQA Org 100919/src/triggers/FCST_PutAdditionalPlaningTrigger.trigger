/*
    1. on Insert : Create New Planningversion record for each Fiscal year in PlanningVersion Object.
    2. on Update : Update Name,MonthName,description of PlanningVersion Record.
    3. on Delete : Delete all Planning Version which is related to deleted Additional Planning Version
*/

trigger FCST_PutAdditionalPlaningTrigger on  Additional_Planning_Versions__c (after insert,after update, before delete) {
    
    if(trigger.isInsert || trigger.isUpdate){
        
        List<Additional_Planning_Versions__c> lstAdditionalPlanning = [select Id,Name,Version_Description__c from Additional_Planning_Versions__c where Id IN: trigger.New];
        List<Planning_Version__c> lstPlanningversion = new List<Planning_Version__c>();
       
        List<Fiscal_Year_Planning__c> lstfiscalsetting = [select Id,EndDate__c,Name,StartDate__c from Fiscal_Year_Planning__c where name <> null order by startdate__c ];
        if(trigger.isInsert){
            
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
        else if(trigger.isUpdate){
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
    }
    
    
    else if(trigger.isdelete && trigger.isBefore){
        List<Planning_Version__c> lstdeletePlanning = [select Id,Additional_Planning_Version__c from Planning_Version__c where Additional_Planning_Version__c IN: Trigger.OldMap.Keyset()];
        
        delete lstdeletePlanning;
    }
}