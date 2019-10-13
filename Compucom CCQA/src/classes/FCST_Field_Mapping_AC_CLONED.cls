public class FCST_Field_Mapping_AC_CLONED{
 
//public String BusinessUnitStr {set;get;}  
    public String  SalesRegionStr {set;get;}
    public String SubRegionStr {set;get;}  
    public String CPMRegionStr {set;get;}
    public String RevenueTypeStr {set;get;}  
    public String ProjectStartDate {set;get;}
    public String ProjectEndDate {set;get;}
    public String oppAmountStr {set;get;}
    public String GeoNum{set;get;}
    public String GeoName{set;get;}
    public String QData{set;get;}
    public String cstCenter{set;get;}
    public String prgManager{set;get;}
    public String prgEngineer{set;get;}//added by sanu
    public String accGeoCodes{set;get;}
    public String termsInMonth{set;get;}
    public String transitionDate{set;get;}
    
    public String businessUnit{set;get;}
    
    public String tcv{set;get;}
    public String svcYR1Amount{set;get;}
    public String OpptBSLA{set;get;}
    
    
    
    //Constructor
    public FCST_Field_Mapping_AC_CLONED(){
        Map<String,Mapping_Setting__c> custMapCons = Mapping_Setting__c.getAll();
        if(custMapCons.size()>0){
            for(Mapping_Setting__c mapping : custMapCons.values()){
                
                if(mapping.Opportunity_TCV__c  <> null){
                tcv = mapping.Opportunity_TCV__c ;
                }
                
                if(mapping.Opportunity_SVC_YR1__c  <> null){
                svcYR1Amount = mapping.Opportunity_SVC_YR1__c ;
                }
                
                if(mapping.FCST_BSLA__c <> null){
                OpptBSLA = mapping.FCST_BSLA__c;
                }
                
                if(mapping.Fcst_BusinessUnit__c  <> null){
                businessUnit = mapping.Fcst_BusinessUnit__c ;
                }
                if(mapping.Fcst_SalesRegion__c  <> null){
                SalesRegionStr = mapping.Fcst_SalesRegion__c ;
                }
                if(mapping.Fcst_SubRegion__c  <> null){
                SubRegionStr = mapping.Fcst_SubRegion__c ;
                }
                if(mapping.Fcst_CPM__c  <> null){
                CPMRegionStr = mapping.Fcst_CPM__c ;
                }
                if(mapping.FCST_ProgramManager__c <> null){
                prgManager = mapping.FCST_ProgramManager__c ;    
                }
                if(mapping.FCST_Program_Executive__c<> null){
                prgEngineer= mapping.FCST_Program_Executive__c;    
                }
                if(mapping.FCST_GeoCodes__c<> null){
                accGeoCodes= mapping.FCST_GeoCodes__c;    
                }
                if(mapping.Fcst_Revenue_Type__c  <> null){
                 RevenueTypeStr= mapping.Fcst_Revenue_Type__c ;
                }
                 if(mapping.Fcst_Revenue_Type__c  <> null){
                 RevenueTypeStr= mapping.Fcst_Revenue_Type__c ;
                }
                if(mapping.Fcst_StartDate__c  <> null){
                ProjectStartDate = mapping.Fcst_StartDate__c ;
                }
                if(mapping.Fcst_EndDate__c  <> null){
                ProjectEndDate = mapping.Fcst_EndDate__c ;
                }
                
                if(mapping.Geo__c<> null){
                GeoNum = mapping.Geo__c;
                }
               if(mapping.Geo_Name__c<> null){
                GeoName = mapping.Geo_Name__c;
                }
                if(mapping.Fcst_Q__c<> null){
                QData = mapping.Fcst_Q__c;
                }
                if(mapping.Cost_Center__c<> null){
                cstCenter = mapping.Cost_Center__c;
                }
                if(mapping.Term_In_Months__c  <> null){
                termsInMonth = mapping.Term_In_Months__c ;
                }
                if(mapping.Transition_Date__c  <> null){
                transitionDate = mapping.Transition_Date__c ;
                }
                
                
            }
        }
    }
    
   
     Public list<SelectOption> getOppPicklist(){
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('--None--','--None--'));
       Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.Product2.fields.getMap();
         for(String fieldName : schemaFieldMap.keySet()){
           Schema.DisplayType fielddataType = schemaFieldMap.get(fieldName).getDescribe().getType();
             if(fielddataType == Schema.DisplayType.PICKLIST){
                 
                  options.add(new SelectOption(fieldName,fieldName));
                 
             }
        }
        return options;
    }
    
   Public list<SelectOption> getbusinessUnitPicklist(){
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('--None--','--None--'));
       Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.Product2.fields.getMap();
         for(String fieldName : schemaFieldMap.keySet()){
           Schema.DisplayType fielddataType = schemaFieldMap.get(fieldName).getDescribe().getType();
             if(fielddataType == Schema.DisplayType.PICKLIST){
                 
                  options.add(new SelectOption(fieldName,fieldName));
                 
             }
        }
        return options;
    }
    
    Public list<SelectOption> getOppDatePicklist(){
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('--None--','--None--'));
       Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.Opportunity.fields.getMap();
         for(String fieldName : schemaFieldMap.keySet()){
           Schema.DisplayType fielddataType = schemaFieldMap.get(fieldName).getDescribe().getType();
             if(fielddataType == Schema.DisplayType.Date){
                 
                  options.add(new SelectOption(fieldName,fieldName));
                 
             }
        }
        return options;
    }
     Public list<SelectOption> getOppDecimalPicklist(){
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('--None--','--None--'));
       Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.Opportunity.fields.getMap();
         for(String fieldName : schemaFieldMap.keySet()){
           Schema.DisplayType fielddataType = schemaFieldMap.get(fieldName).getDescribe().getType();
            if(fielddataType == Schema.DisplayType.CURRENCY){
                options.add(new SelectOption(fieldName,fieldName));
             }
        }
        return options;
    }
    
    
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    Public list<SelectOption> getOppTCVPicklist(){
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('--None--','--None--'));
       Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.Opportunity.fields.getMap();
         for(String fieldName : schemaFieldMap.keySet()){
           Schema.DisplayType fielddataType = schemaFieldMap.get(fieldName).getDescribe().getType();
            if(fielddataType == Schema.DisplayType.CURRENCY){
                options.add(new SelectOption(fieldName,fieldName));
             }
        }
        return options;
    }
    
    Public list<SelectOption> getSVCDecimalPicklist(){
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('--None--','--None--'));
       Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.Opportunity.fields.getMap();
         for(String fieldName : schemaFieldMap.keySet()){
           Schema.DisplayType fielddataType = schemaFieldMap.get(fieldName).getDescribe().getType();
            if(fielddataType == Schema.DisplayType.CURRENCY){
                options.add(new SelectOption(fieldName,fieldName));
             }
        }
        return options;
    }
    
    Public list<SelectOption> getOpptBSLAPicklist(){
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('--None--','--None--'));
       Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.Opportunity.fields.getMap();
         for(String fieldName : schemaFieldMap.keySet()){
           Schema.DisplayType fielddataType = schemaFieldMap.get(fieldName).getDescribe().getType();
            if(fielddataType == Schema.DisplayType.PICKLIST){
                options.add(new SelectOption(fieldName,fieldName));
             }
        }
        return options;
    }
    
    //>>>>>>>>>>>> 
    
    Public list<SelectOption> getOppNum(){
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('--None--','--None--'));
       Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.Opportunity.fields.getMap();
         for(String fieldName : schemaFieldMap.keySet()){
           Schema.DisplayType fielddataType = schemaFieldMap.get(fieldName).getDescribe().getType();
            if(fielddataType == Schema.DisplayType.STRING){
                options.add(new SelectOption(fieldName,fieldName));
             }
        }
        return options;
    } 
    
    Public list<SelectOption> getOpptName(){
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('--None--','--None--'));
       Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.Opportunity.fields.getMap();
         for(String fieldName : schemaFieldMap.keySet()){
           Schema.DisplayType fielddataType = schemaFieldMap.get(fieldName).getDescribe().getType();
            if(fielddataType == Schema.DisplayType.STRING){
                options.add(new SelectOption(fieldName,fieldName));
             }
        }
        return options;
    } 
    
     Public list<SelectOption> getAccPicklist(){
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('--None--','--None--'));
       Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.Account.fields.getMap();
         for(String fieldName : schemaFieldMap.keySet()){
           Schema.DisplayType fielddataType = schemaFieldMap.get(fieldName).getDescribe().getType();
             if(fielddataType == Schema.DisplayType.PICKLIST){
                  options.add(new SelectOption(fieldName,fieldName));
                 
             }
        }
        return options;
    }
    //16/05/09
    Public list<SelectOption> getAccLookupFlds(){
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('--None--','--None--'));
       Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.Account.fields.getMap();
         for(String fieldName : schemaFieldMap.keySet()){
           Schema.DisplayType fielddataType = schemaFieldMap.get(fieldName).getDescribe().getType();
             if(fielddataType == Schema.DisplayType.Reference){
                 
                  options.add(new SelectOption(fieldName,fieldName));
                 
             }
        }
        return options;
    } 
    
    /*******************************************************************************/
      //added by sanu
        Public list<SelectOption> getProgramEngineers(){
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('--None--','--None--'));
       Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.Account.fields.getMap();
         for(String fieldName : schemaFieldMap.keySet()){
           Schema.DisplayType fielddataType = schemaFieldMap.get(fieldName).getDescribe().getType();
             if(fielddataType == Schema.DisplayType.Reference){
                 
                  options.add(new SelectOption(fieldName,fieldName));
                 
             }
        }
        return options;
    } 

    Public list<SelectOption> getAccountGeoCodes(){
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('--None--','--None--'));
       Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.Account.fields.getMap();
         for(String fieldName : schemaFieldMap.keySet()){
           Schema.DisplayType fielddataType = schemaFieldMap.get(fieldName).getDescribe().getType();
             if(fielddataType == Schema.DisplayType.TextArea){
                 
                  options.add(new SelectOption(fieldName,fieldName));
                 
             }
        }
        return options;
    } 
    
    
    
    
    /******************************************************************************/
        //16/05/19
  
  Public list<SelectOption> getOpptStrFlds(){
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('--None--','--None--'));
       Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.Opportunity.fields.getMap();
         for(String fieldName : schemaFieldMap.keySet()){
           Schema.DisplayType fielddataType = schemaFieldMap.get(fieldName).getDescribe().getType();
             if(fielddataType == Schema.DisplayType.Reference){
                 
                  options.add(new SelectOption(fieldName,fieldName));
                 
             }
        }
        return options;
    }
  
    Public list<SelectOption> getTermsMonth(){
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('--None--','--None--'));
       Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.Opportunity.fields.getMap();
         for(String fieldName : schemaFieldMap.keySet()){
           Schema.DisplayType fielddataType = schemaFieldMap.get(fieldName).getDescribe().getType();
             if(fielddataType == Schema.DisplayType.DOUBLE){
                 
                  options.add(new SelectOption(fieldName,fieldName));
                 
             }
        }
        return options;
    }
    
  Public list<SelectOption> getTransDatePicklist(){
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('--None--','--None--'));
       Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.Opportunity.fields.getMap();
         for(String fieldName : schemaFieldMap.keySet()){
           Schema.DisplayType fielddataType = schemaFieldMap.get(fieldName).getDescribe().getType();
             if(fielddataType == Schema.DisplayType.Date){
                 
                  options.add(new SelectOption(fieldName,fieldName));
                 
             }
        }
        return options;
    }  
    
    
  
  Public list<SelectOption> getProductStrFlds(){
  List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('--None--','--None--'));
       Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.Product2.fields.getMap();
         for(String fieldName : schemaFieldMap.keySet()){
           Schema.DisplayType fielddataType = schemaFieldMap.get(fieldName).getDescribe().getType();
             if(fielddataType == Schema.DisplayType.STRING){
                 
                  options.add(new SelectOption(fieldName,fieldName));
                 
             }
        }
        return options;
  }

   Public list<SelectOption> getOpptPrds(){
  List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('--None--','--None--'));
       Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.OpportunityLineItem.fields.getMap();
         for(String fieldName : schemaFieldMap.keySet()){
           Schema.DisplayType fielddataType = schemaFieldMap.get(fieldName).getDescribe().getType();
             if(fielddataType == Schema.DisplayType.STRING){
                 
                  options.add(new SelectOption(fieldName,fieldName));
                 
             }
        }
        return options;
  }
    
    
    Public void save(){
     Map<String,Mapping_Setting__c> custMap = Mapping_Setting__c.getAll();
        System.debug('Custom Map:'+custMap);
     List<Mapping_Setting__c> metaList = new List<Mapping_Setting__c>();
        if(custMap.size()>0){
            for(Mapping_Setting__c meta : custMap.values()){
                
                if(tcv!='--None--'){
               		meta.Opportunity_TCV__c = tcv;
                }else{
                  ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Map With Proper Value ! ');
                    ApexPages.addMessage(msg);  
                }
                if(svcYR1Amount!='--None--'){
               		meta.Opportunity_SVC_YR1__c = svcYR1Amount;
                }else{
                  ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Map With Proper Value ! ');
                    ApexPages.addMessage(msg);  
                }
                
                if(OpptBSLA!='--None--'){
               		meta.FCST_BSLA__c = OpptBSLA;
                }else{
                  ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Map With Proper Value ! ');
                    ApexPages.addMessage(msg);  
                }
                
                if(businessUnit!='--None--'){
               		meta.Fcst_BusinessUnit__c = businessUnit;
                }else{
                  ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Map With Proper Value ! ');
                    ApexPages.addMessage(msg);  
                }
                
                if(SalesRegionStr!='--None--'){
                meta.Fcst_SalesRegion__c = SalesRegionStr;
                }else{
                  ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Map With Proper Value ! ');
                    ApexPages.addMessage(msg);  
                }
                
                if(SubRegionStr!='--None--'){
                meta.Fcst_SubRegion__c = SubRegionStr;
                }else{
                  ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Map With Proper Value ! ');
                    ApexPages.addMessage(msg);  
                }
                
                if(prgManager!='--None--'){
                meta.FCST_ProgramManager__c = prgManager;
                }else{
                  ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Map With Proper Value ! ');
                    ApexPages.addMessage(msg);  
                }
                
                if(prgEngineer!='--None--'){
                meta.FCST_Program_Executive__c= prgEngineer;
                }else{
                  ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Map With Proper Value ! ');
                    ApexPages.addMessage(msg);  
                }
                
                if(accGeoCodes!='--None--'){
                meta.FCST_GeoCodes__c= accGeoCodes;
                }else{
                  ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Map With Proper Value ! ');
                    ApexPages.addMessage(msg);  
                }
                
                if(CPMRegionStr!='--None--'){
                meta.Fcst_CPM__c = CPMRegionStr;
                }else{
                  ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Map With Proper Value ! ');
                    ApexPages.addMessage(msg);  
                }
               
                if(RevenueTypeStr!='--None--'){
                meta.Fcst_Revenue_Type__c    = RevenueTypeStr;
                }else{
                  ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Map With Proper Value ! ');
                    ApexPages.addMessage(msg);  
                }
                
                if(ProjectStartDate!='--None--'){
                meta.Fcst_StartDate__c   = ProjectStartDate;
                }else{
                  ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Map With Proper Value ! ');
                    ApexPages.addMessage(msg);  
                }
                
                if(ProjectEndDate!='--None--'){
                meta.Fcst_EndDate__c     = ProjectEndDate;
                }else{
                  ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Map With Proper Value ! ');
                    ApexPages.addMessage(msg);  
                }
                
                
                if(GeoNum!='--None--'){
                meta.Geo__c= GeoNum;
                }else{
                  ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Map With Proper Value ! ');
                    ApexPages.addMessage(msg);  
                }
                
                if(GeoName!='--None--'){
                meta.Geo_Name__c= GeoName;
                }else{
                  ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Map With Proper Value ! ');
                    ApexPages.addMessage(msg);  
                }
             
                if(QData!='--None--'){
                meta.Fcst_Q__c= QData;
                }else{
                  ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Map With Proper Value ! ');
                    ApexPages.addMessage(msg);  
                }
                
                if(cstCenter!='--None--'){
                meta.Cost_Center__c= cstCenter;
                }else{
                  ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Map With Proper Value ! ');
                    ApexPages.addMessage(msg);  
                }
                
                if(termsInMonth!='--None--'){
                meta.Term_In_Months__c  = termsInMonth;
                }else{
                  ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Map With Proper Value ! ');
                    ApexPages.addMessage(msg);  
                }
               
               if(transitionDate!='--None--'){
                meta.Transition_Date__c  = transitionDate;
                }else{
                  ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Map With Proper Value ! ');
                    ApexPages.addMessage(msg);  
                }
                
             metaList.add(meta);  
            }
            
            
            if(SalesRegionStr!='--None--' && SubRegionStr!='--None--' && prgManager!='--None--' && prgEngineer!='--None--' && accGeoCodes!='--None--' && CPMRegionStr!='--None--' && RevenueTypeStr!='--None--' && ProjectStartDate!='--None--' && ProjectEndDate!='--None--' && GeoNum!='--None--' && GeoName!='--None--' && QData!='--None--' && cstCenter!='--None--'){
            update metaList;
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Record Saved Successfully.'));
            }
    }
        else{
             Mapping_Setting__c metaRecord = new Mapping_Setting__c();
                metaRecord.Name = 'FCST Mapping Data';
            
            if(tcv != '--None--'){
                metaRecord.Opportunity_TCV__c   = tcv;
                }
                
            if(svcYR1Amount != '--None--'){
                metaRecord.Opportunity_SVC_YR1__c   = svcYR1Amount;
                }
             
            if(OpptBSLA!='--None--'){
               	metaRecord.FCST_BSLA__c = OpptBSLA;
                }
            
            if(SalesRegionStr != '--None--'){
                metaRecord.Fcst_SalesRegion__c   = SalesRegionStr;
                }
            if(SubRegionStr != '--None--'){
                metaRecord.Fcst_SubRegion__c = SubRegionStr;
                }
            if(prgManager != '--None--'){
                metaRecord.FCST_ProgramManager__c = prgManager;
                }
            if(prgEngineer!= '--None--'){
                metaRecord.FCST_Program_Executive__c= prgEngineer;
                }
            if(accGeoCodes!= '--None--'){
                metaRecord.FCST_GeoCodes__c= accGeoCodes;
                }
            if(CPMRegionStr != '--None--'){
                metaRecord.Fcst_CPM__c = CPMRegionStr;
                }
            if(RevenueTypeStr != '--None--'){
                metaRecord.Fcst_Revenue_Type__c = RevenueTypeStr;
                }
            if(ProjectStartDate != '--None--'){
                metaRecord.Fcst_StartDate__c = ProjectStartDate;
                }
            if(ProjectEndDate != '--None--'){
                metaRecord.Fcst_EndDate__c = ProjectEndDate;
                }
               if(businessUnit != '--None--'){
                metaRecord.Fcst_BusinessUnit__c = businessUnit;
                }
                 if(GeoNum!= '--None--'){
                metaRecord.Geo__c= GeoNum;
                }
                 if(GeoName!= '--None--'){
                metaRecord.Geo_Name__c= GeoName;
                }
                 if(QData!= '--None--'){
                metaRecord.Fcst_Q__c= QData;
                }
                 if(cstCenter!= '--None--'){
                metaRecord.Cost_Center__c= cstCenter;
                }
             
           		if(termsInMonth!= '--None--'){
                metaRecord.Term_In_Months__c= termsInMonth;
                }
                
                if(transitionDate!= '--None--'){
                metaRecord.Transition_Date__c= transitionDate;
                }
                
             if(SalesRegionStr!='--None--' && SubRegionStr!='--None--' && prgManager!='--None--' && accGeoCodes!='--None--'  && prgEngineer!='--None--' && CPMRegionStr!='--None--' && RevenueTypeStr!='--None--' && ProjectStartDate!='--None--' && ProjectEndDate!='--None--' && GeoNum!='--None--' && GeoName!= '--None--' && QData!= '--None--' && cstCenter!= '--None--'){
            
            insert metaRecord;
            
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Record Saved Successfully.'));
            }
        }
    }

    public pagereference gotohomepage(){
        PageReference pg = new Pagereference('/home/home.jsp');
        pg.setredirect(true);
        return pg;
    }
    }