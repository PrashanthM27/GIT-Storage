public with sharing class FCST_RevRecognizationRules{
    public String strPrd{set;get;}
    public String oppType{set;get;}
    public String strMonths{set;get;}
    public String RevenueTypeStr;
   // public String strProductFamily{get;set;}
    public List<SelectOption> lstPrdtNames{set;get;}
    public Boolean getIsClassic() {
        return (UserInfo.getUiThemeDisplayed() == 'Theme3');
    }
    
    public FCST_RevRecognizationRules(){
        strPrd = '';
       productOptions = new List<SelectOption>();
       productOptions.add(new SelectOption('--None--','--None--'));
        setAvailableRegime =new set<string>{'Product'};
            prd = new Product2(); 
            blnCheck = false;
            blnIsMonthvalEmpty = false;
       // lstWrapperTermsMonth = new List<WrapperTermsMonth>();
       Map<String,Mapping_Setting__c> custMapCons = Mapping_Setting__c.getAll();
        System.debug('==='+custMapCons);
        if(custMapCons.size()>0){
            for(Mapping_Setting__c mapping : custMapCons.values()){
              
                if(mapping.Fcst_Revenue_Type__c <> null){
                 RevenueTypeStr= mapping.Fcst_Revenue_Type__c;
                }
            }
                
        } 
        
       String pageMessage = ApexPages.currentPage().getParameters().get('pageMessage');
       if (pageMessage != null) { 
           System.debug('==>>pageMessage'+pageMessage);
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Confirm, pageMessage));
        }
      //  initmethod();
       
}
    
    public PageReference save() {
        system.debug('<<product family2>>'+ selProductId);
        if(selProductId <> null && selProductId <> 'none'){
            
            List<FCST_Revenue_Recognization_Product__c> lstRR = new List<FCST_Revenue_Recognization_Product__c>();
            if(lstRegime!=null && lstRegime.size()>0){
                System.debug('regime==>>'+lstRegime);
                for(WrapperRegime r : lstRegime){
                    
                    decimal total = 0;
                    boolean isEnable = false;
                    for(WrapperPeriod p: r.lstPeriod){
                        if(p.rev <> null){
                            if(p.rev.Amount__c == null){
                                p.rev.Amount__c = 0;
                            }
                            isEnable=true;
                            lstRR.add(p.rev);
                            total += p.rev.Amount__c;
                        }
                    } 
                    if(isEnable && total <> 100){apexpages.addmessage(new apexpages.message(apexpages.severity.Error,'Total of periods should be equals to 100%'));return null;}
                }
            }
            if(Schema.sObjectType.FCST_Revenue_Recognization_Product__c.fields.Amount__c.isUpdateable() && Schema.sObjectType.FCST_Revenue_Recognization_Product__c.fields.Amount__c.isCreateable()){upsert lstRR;}if(FCST_Revenue_Recognization_Product__c.sObjectType.getDescribe().isDeletable()){ delete [select Id,Name from FCST_Revenue_Recognization_Product__c where product_code__c =: selProductId and ID NOT IN: lstRR ]; }
        }
        
        return null;
    }
    
    public void getTotals(){
        boolean isMore100 = false;
        if(selProductId <> null && selProductId <> 'none'){
            System.debug('===>>SepPrdId '+selProductId);
            System.debug('1st Regime:'+lstRegime);
            for(WrapperRegime r : lstRegime){
                System.debug('1st Regime:'+r);
                decimal total=0;
                boolean isEnable = false;
                for(WrapperPeriod p: r.lstPeriod){
                    if(p.rev <> null && p.rev.amount__c <> null){
                        isEnable=true;
                        total+=p.rev.amount__c;
                    }
                }   
                r.total = total;
                if(isEnable && r.total <> 100)isMore100=true;
            }
        }
        if(isMore100)
            apexpages.addmessage(new apexpages.message(apexpages.severity.warning,'Total of periods should be equals to 100%'));
    }
    
    
    set<string> setAvailableRegime;
    public product2 prd{get;set;}
    public string selProductId{get;set;}    
    public List<WrapperRegime> lstRegime{get;set;}
    public List<string> header{get;set;}
    map<string,FCST_Revenue_Recognization_Product__c> mapRevenueRecog;
    
    Public list<SelectOption> getCategeoryFields(){
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('--None--','--None--'));
        System.debug('RevenueTypeStr====>'+RevenueTypeStr);
       if(RevenueTypeStr != null){ 
           Set<String> revTypeSet =getPicklistValues('Product2',RevenueTypeStr);
              for (String s : revTypeSet)
              { 
                  if(s=='Prod - Commodity' || s=='Prod - Enterprise' || s=='Software' ){
                 options.add(new SelectOption(s,s)); 
                  }
              }
       }
     
        return options;
    }
    
   
    
    public List<SelectOption> productOptions{get;set;}
    Public void getActiveProducts(){
       
       
       if(!String.isEmpty(oppType) && oppType != '--None--'){
         //  if(strPrd == '--None--'){
         strPrd = '--None--';  
            getTermsMonths();
           
               productOptions = new List<SelectOption>();
                productOptions.add(new SelectOption('--None--','--None--'));
               system.debug('====='+oppType);
                   for(Product2 r : Database.query('select Id, Name from Product2 where IsActive = true AND '+ RevenueTypeStr+'=:oppType')){
                productOptions.add(new selectoption(r.id, r.Name));
            }  
         
          // }
          
         }
       else{
           initmethod();
        }
    }
    
    public List<WrapperTermsMonth> lstWrapperTermsMonth{get;set;}
    public Boolean blnCheck{get;set;}
    public decimal  intTotalVal{get;set;}
    public Boolean  blnIsMonthvalEmpty{get;set;}
    public void initmethod(){
        oppType = '--None--';
        strPrd = '--None--';
        blnCheck = false;
        lstWrapperTermsMonth = new List<WrapperTermsMonth>();
       // lstWrapperTermsMonth.clear();
     /**   for(Integer i=1;i<=12;i++){
                       lstWrapperTermsMonth.add(new WrapperTermsMonth('M+'+i,'0',''));
                       intTotalVal= 0;
                   } ***/
       // blnCheck = false;
        intTotalVal= 0;
         productOptions.clear();
         productOptions.add(new SelectOption('--None--','--None--'));
        
        system.debug('^^^^^^^^^^^^'+blnCheck);
       // getTotalVal();

    }
    public void getTermsMonths(){
        blnCheck = false;
        intTotalVal = 0;
        String strFinalQuery = 'SELECT id,Period__c,Amount__c FROM FCST_Revenue_Recognization_Product__c WHERE id != null';
        /**  if(!String.isEmpty(oppType) && oppType != '--None--'){
           // strFinalQuery+= ' AND Revenue_Type__c=:oppType';
            System.debug('oppType====>'+oppType);
           // blnCheck = true;
        } **/
        System.debug('strPrd====>'+strPrd);
        if(!String.isEmpty(strPrd) && strPrd != '--None--'){
          strFinalQuery+= ' AND Product__c=:strPrd';  
          System.debug('strPrd====>'+strPrd);
            blnCheck = true;
        }
        /*if(!String.isEmpty(strProductFamily) && strProductFamily != '--None--'){
          strFinalQuery+= ' AND Offering_Category__c=:strProductFamily';  
          System.debug('strProductFamily====>'+strProductFamily);
        }*/
        strFinalQuery+= ' order by createdDate DESC LIMIT 12';
        System.debug('strFinalQuery===>'+oppType);
        if(blnCheck == true){
           lstWrapperTermsMonth = new List<WrapperTermsMonth>();
            Fcst_Rev_Rec_Revenue_Type__c theCustomRec = Fcst_Rev_Rec_Revenue_Type__c.getInstance(oppType);
            System.debug('customSetting>>>'+theCustomRec);
            if(theCustomRec != null && theCustomRec.Fcst_12_Month_Duration__c == true){
                 map<String,FCST_Revenue_Recognization_Product__c> mapData = new Map<String,FCST_Revenue_Recognization_Product__c>();
                 for(FCST_Revenue_Recognization_Product__c lstRevRecog:Database.query(strFinalQuery)){ 
                 System.debug('lstRevRecog==>>'+lstRevRecog);
                   mapData.put(lstRevRecog.Period__c,lstRevRecog);
                }
                if(mapData != null && mapData.size()>0){
                 for(Integer i=1;i<=12;i++){
                     if(mapData.containsKey('M+'+i)){
                         System.debug('===>M+'+i); 
                         //System.debug('===>Id+'+(mapData.get('M+'+i)).id);
                         lstWrapperTermsMonth.add(new WrapperTermsMonth('M+'+i,String.valueOf(mapData.get('M+'+i).Amount__c),String.valueOf(mapData.get('M+'+i).id)));
                         if(mapData.get('M+'+i).Amount__c<>null){
                             intTotalVal+= mapData.get('M+'+i).Amount__c; }
                         else{
                             intTotalVal+=0;
                         }
                     }
                  }   
                }else {
                   for(Integer i=1;i<=12;i++){
                       lstWrapperTermsMonth.add(new WrapperTermsMonth('M+'+i,'0',''));
                       intTotalVal= 0;
                   } 
                }

            }

        }
        else {
            blnCheck = false;
           lstWrapperTermsMonth = new List<WrapperTermsMonth>(); 
                       /** for(Integer i=1;i<=12;i++){
                       lstWrapperTermsMonth.add(new WrapperTermsMonth('M+'+i,'0',''));
                       intTotalVal= 0;
                        }**/
            
        }
        // getTotalVal();
    }
    
    
      public void getTotalVal(){
       //   getTermsMonths();
         intTotalVal = 0;
           System.debug('getRec===>'+lstWrapperTermsMonth);
       if(lstWrapperTermsMonth != null && lstWrapperTermsMonth.size()>0){
          for(WrapperTermsMonth getRec:lstWrapperTermsMonth){
             System.debug('getRec===>'+getRec);
             System.debug('getRec=numeric check ==>'+getRec.strMonthVal.isNumeric());
             
              Boolean isValidDecimal = true;
				if(getRec.strMonthVal != null){
				    try{
				        Decimal.valueOf(getRec.strMonthVal);
				    }
				    catch(TypeException e){
				       isValidDecimal = false; 
				    }
				}
             
             if(!String.isBlank(getRec.strMonthVal) ){
                 if((getRec.strMonthVal).contains('%')){
                     String str = getRec.strMonthVal.split('%').get(0);
                    /* if(!str.isNumeric()){
                        apexpages.addmessage(new apexpages.message(apexpages.severity.warning,'Month value Should  be Numeric')); 
                         break;
                     }*/
                     intTotalVal+= decimal.valueOf(str);
                 }else {
                    if(!getRec.strMonthVal.isNumeric() && isValidDecimal==false){
                        apexpages.addmessage(new apexpages.message(apexpages.severity.warning,'Month value Should  be Numeric')); 
                         break;
                     }
                     if(isValidDecimal==true){
                     	intTotalVal+= Decimal.valueOf(getRec.strMonthVal);
                     }
                     else{
                     	intTotalVal+= Integer.valueOf(getRec.strMonthVal);
                     }
                      
                    
                    getRec.strMonthVal = getRec.strMonthVal+'%';
                 }
             }else {
                 if(String.isBlank(getRec.strMonthVal)){
                   getRec.strMonthVal = '0';
                     intTotalVal+= Decimal.valueOf(getRec.strMonthVal);  
                 } else{
               apexpages.addmessage(new apexpages.message(apexpages.severity.warning,'Month value Should  be Numeric')); 
               blnIsMonthvalEmpty = true;
                     break;}
             }
              System.debug('intTotalVal'+intTotalVal);
         } 
          
       } 
       System.debug('intTotalVal===>'+intTotalVal);
        if(intTotalVal <>  100 && intTotalVal <> 0)
            apexpages.addmessage(new apexpages.message(apexpages.severity.warning,'Total of periods should be equals to 100%')); 
       }
    
     
      public PageReference  customSave(){
          System.debug('intTotalVal==if=>'+intTotalVal);
          System.debug('lstWrapperTermsMonth==if=>'+lstWrapperTermsMonth);
           //System.debug('strPrd:'+strPrd+'StrFamily:'+strProductFamily+'oppType:'+oppType);
         //PageReference pr = new PageReference('/apex/FCST_RevRecognizationRules');
         if((!String.isBlank(strPrd) && strPrd == '--None--') && (!String.isBlank(oppType) && oppType == '--None--')){
            
             apexpages.addmessage(new apexpages.message(apexpages.severity.Error,'All filter conditions should not be empty')); 
                return null;
         }else if(!String.isBlank(strPrd) && strPrd == '--None--'){
               apexpages.addmessage(new apexpages.message(apexpages.severity.Error,'Please select valid Offering Name')); 
                return null;
            }/***else if(!String.isBlank(strProductFamily) && strProductFamily == '--None--'){
                apexpages.addmessage(new apexpages.message(apexpages.severity.Error,'Please select valid Offering Category')); 
                return null;
            }**/else if(blnIsMonthvalEmpty == true){
                //apexpages.addmessage(new apexpages.message(apexpages.severity.warning,'Month val Should not be Empty'));
                return null;
            }else if(lstWrapperTermsMonth != null && lstWrapperTermsMonth.size()>0 && !String.isEmpty(oppType) && oppType != '--None--'){
                     if(intTotalVal == 100){
                         System.debug('intTotalVal==if=>'+intTotalVal);
                         System.debug('strPrd===>'+strPrd);
                        List<FCST_Revenue_Recognization_Product__c> lstRevRecProducts = new List<FCST_Revenue_Recognization_Product__c>();
                        for(WrapperTermsMonth getRec:lstWrapperTermsMonth){
                          FCST_Revenue_Recognization_Product__c objRevRecProducts= new FCST_Revenue_Recognization_Product__c();
                          objRevRecProducts.Revenue_Type__c = oppType;
                         // objRevRecProducts.Offering_Category__c = oppType;
                          objRevRecProducts.Period__c = getRec.strMonth;
                          String strDecimalVal = getRec.strMonthVal.split('%').get(0);
                            if(strDecimalVal==null || strDecimalVal == ''){
                                strDecimalVal = '0';
                            }
                          Boolean isValidDecimal = true;
						if(strDecimalVal != null){
						    try{
						        Decimal.valueOf(strDecimalVal);
						    }
						    catch(TypeException e){
						       isValidDecimal = false; 
						    }
						}
				
                          if(!strDecimalVal.isNumeric() && isValidDecimal==false){
                            apexpages.addmessage(new apexpages.message(apexpages.severity.warning,'Month value Should  be Numeric')); 
                            break;
                          }
                           system.debug('----------->'+getRec.strRecordId);
                          objRevRecProducts.Amount__c = Decimal.ValueOf(strDecimalVal);
                          if(!String.isBlank(strPrd) && strPrd != '--None--'){
                              objRevRecProducts.Product__c = strPrd;
                          }
                          if(!String.isBlank(getRec.strRecordId) && getRec.strRecordId != ''){
                              objRevRecProducts.id = getRec.strRecordId;
                          }
                          lstRevRecProducts.add(objRevRecProducts);
                          
                      }
                      if(lstRevRecProducts != null && lstRevRecProducts.size()>0){
                          upsert lstRevRecProducts;
                          system.debug('----------->'+lstRevRecProducts);
                          lstWrapperTermsMonth = new List<WrapperTermsMonth>();
                          for(FCST_Revenue_Recognization_Product__c getRec:[SELECT id,Period__c,Amount__c FROM FCST_Revenue_Recognization_Product__c WHERE id IN:lstRevRecProducts]){
                              lstWrapperTermsMonth.add(new WrapperTermsMonth(getRec.Period__c,String.valueOf(getRec.Amount__c)+'%',String.valueOf(getRec.id)));
                          }
                      }
                         /* pr.getParameters().put('pageMessage', 'CreatedSuccessfully');
                          pr.setRedirect(true);
                            System.debug('In if==>');*/
                          //apexpages.addmessage(new apexpages.message(apexpages.severity.Confirm,'Created Successfully')); 
                          
                          return null;
                     }else {
                         System.debug('intTotalVal=in else==>'+intTotalVal);
                          apexpages.addmessage(new apexpages.message(apexpages.severity.warning,'Total of periods should be equals to 100%')); 
                          return null;
                      }
            }else {
                apexpages.addmessage(new apexpages.message(apexpages.severity.Error,'Please select valid RevenueType')); 
                return null; 
            } 
            
      }
      
    
    public class WrapperTermsMonth{
        public String strMonth{get;set;}
        public String strMonthVal{get;set;}
        public String strRecordId{get;set;}
        
        public WrapperTermsMonth(String strMonth,String strMonthVal,String strRecordId){
            this.strMonth = strMonth;
            this.strMonthVal = strMonthVal;
            this.strRecordId = strRecordId;
            
        }
    }
    
    public void getRevenuePlanning(){
        if(selProductId <> null){
            lstPrdtNames = new list<SelectOption>();
            mapRevenueRecog = new map<string,FCST_Revenue_Recognization_Product__c>();
            map<string,list<WrapperPeriod>> mapRegimePeriod = new map<string,list<WrapperPeriod>>();
            Decimal count = 0;
            for(Product2 r : [select Id, Name from Product2 where IsActive = true]){
                lstPrdtNames.add(new selectoption(r.id, r.Name));
            }
        }
        
    }
    
        public void getRegimeCalculation(){
        
        system.debug('<< product family4>>'+ selProductId);
        
        if(selProductId <> null && selProductId <> 'none' && lstRegime!=null && lstRegime.size()>0){
            integer count = 0;
            for(WrapperRegime r : lstRegime){
                list<WrapperPeriod> temp = new list<WrapperPeriod>();
                if(r.period <> null && r.period > 0){
                    for(Integer index = 1; index <= r.period; index++){
                        WrapperPeriod p;
                        if(mapRevenueRecog.containsKey(r.Name+'#M+'+index)){
                            p = new WrapperPeriod('M+'+index,mapRevenueRecog.get(r.Name+'#M+'+index));
                        }else{
                            p = new WrapperPeriod('M+'+index,new FCST_Revenue_Recognization_Product__c(Period__c='M+'+index, Amount__c=0,product_code__c=selProductId));
                        }
                        temp.add(p);
                    }                   
                }
                if(temp.size()>count)count = temp.size();
                r.lstPeriod = temp;
            }
            header = new list<string>();
            for(integer i=1;i<=count;i++){
                header.add('M+'+i);
            }
            
            for(WrapperRegime r : lstRegime){
                for(Integer index = (r.lstPeriod.size())+1; index <= count; index++){
                    r.lstPeriod.add(new WrapperPeriod('M+'+index,null));
                }
            }
            getTotals();
        }
    }
  /*  public List<SelectOption> getProductFamilys() {
        List<SelectOption> options = new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult = Product2.Revenue_Type__c.getDescribe();
        List<Schema.PicklistEntry> lstPicklistValues = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry plsIterator : lstPicklistValues) {
            options.add(new SelectOption(plsIterator.getLabel(), plsIterator.getValue()));
        }  
        return options;
        
    }*/
 
    public class WrapperRegime{
        public string Name{get;set;}
        public Integer Period{get;set;}
        public decimal Total{get;set;}
        public list<WrapperPeriod> lstPeriod{get;set;}
        public WrapperRegime(string Name, Integer Period,list<WrapperPeriod> lstPeriod){
            this.Name = Name;
            this.Period = Period;
            this.lstPeriod = lstPeriod;
            this.Total = 0;
        }
    }
    public class WrapperPeriod implements Comparable {
        public string Name{get; set;}
        public integer Sequence{get; set;}
        public FCST_Revenue_Recognization_Product__c rev{get;set;}
        public WrapperPeriod(String Name, FCST_Revenue_Recognization_Product__c rev){
            this.Name = Name;
            this.rev = rev;
            this.Sequence = 0;
            
            if(rev <> null && rev.Period__c <> null ){
                this.Sequence= Integer.valueOf(rev.Period__c.substring(rev.Period__c.indexOf('M+')+1));
            }
        }
        public Integer compareTo(Object compareTo) {
            WrapperPeriod compareToPlan = (WrapperPeriod)compareTo;
            if (Sequence == compareToPlan.Sequence) return 0;
            if (Sequence > compareToPlan.Sequence) return 1;
            return -1;        
        }
    }
    public static set<String> getPicklistValues(String ObjectApi_name,String Field_name){ 

        set<String> lstPickvals=new set<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);//From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
          if(a.getValue() != null && a.getValue() != '' && a.getValue() != 'none' && a.getValue() <> 'Recurring')
            lstPickvals.add(a.getValue());
        }    
        return lstPickvals;
    }
}