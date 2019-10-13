public with sharing class FCST_InsertProductModel{
   /*
    Developer Name : Dhara Mahesh
    Modified  Date : 05-09-2019
    WorkItem(JIRA Story) : Story FCST-CC2P-014-Open deals model creation
    Changes : comented 390 and added new line at 391
   */ 
    public static boolean RecursionHandler = True;
 
	public static boolean HandlerMethod(){
	 
		if(RecursionHandler){
		 
		RecursionHandler = False;
		 
		return true;
		 
		}
	 
		else{
		 
			return RecursionHandler;
		 
		}
	 
	}
	
	
	public static boolean RecursionHandler2 = True;
 
	public static boolean HandlerMethod2(){
	 
		if(RecursionHandler2){
		 
		RecursionHandler2 = False;
		 
		return true;
		 
		}
	 
		else{
		 
			return RecursionHandler2;
		 
		}
	 
	}
    
    public Static Integer getDateId(Date dd){
        
        if(dd <> null){
            string cPeriod = (dd.Month()<10)? '0'+dd.Month():dd.Month()+'';
            string cDay = (dd.Day()<10)? '0'+dd.Day():dd.Day()+'';
            return Integer.ValueOf(dd.Year()+''+cPeriod+''+cDay);
        }
        return null;
    }
    public Static boolean IsExistDate(String mm, Date dd){
        Integer StartDate = Integer.valueOf(mm.split('-')[0]);
        Integer EndDate = Integer.valueOf(mm.split('-')[1]);
        Integer FDate = getDateId(dd);
        
        if(FDate >= StartDate && FDate <=EndDate)
            return true;
        else return false;
    }
    
    public Static Integer getFiscalYearId(Date dd,map<String,Integer> mapFiscalIdy){
        
        System.debug('...dd...'+dd);
        System.debug('...mapFiscalIdy...'+mapFiscalIdy);
        for(String key : mapFiscalIdy.keyset()){
            
            if(IsExistDate(key,dd)){
                
                return mapFiscalIdy.get(key);
            }
        }
        return 0;
    }    
    public Static string get15DigitId(String mId){
        if(mId <> null && mId.trim() <> ''){
            return mId.substring(0,15);
        }
        return '';
    }
    public static List<String> getPicklistValues(String ObjectApi_name,String Field_name){ 
        
        List<String> lstPickvals=new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);//From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
            lstPickvals.add(a.getValue());//add the value  to our final list
        }
        
        return lstPickvals;
    }
    
    @future
    public static void UpdateCurrentVersionModel(set<Id> OppIds){
        List<Planning_Version__c> lstMPlanningversion =new List<Planning_Version__c>();
        if(Schema.sObjectType.Planning_Version__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Name.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Closed_Date__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Start_Date__c.isAccessible()  && Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Budget_Planning_Version__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Gap_Planning_Version__c.isAccessible() ){
            
        lstMPlanningversion = [select Id,Name,Version_Status__c,Data_Entry_Closed_Date__c,Data_Entry_Start_Date__c from Planning_Version__c where Data_Entry_Start_Date__c <> null
                                                         and Is_this_a_Budget_Planning_Version__c = false 
                                                         and Is_this_a_Gap_Planning_Version__c = false
                                                         and (Version_Status__c = 'Open (Admin)')
                                                        ];
        }
        if(lstMPlanningversion.size()>0 && Schema.sObjectType.FCST_Product_Model__c.fields.Id.isAccessible() && Schema.sObjectType.FCST_Product_Model__c.fields.Opportunity__c.isAccessible() && Schema.sObjectType.FCST_Product_Model__c.fields.Planning_Version__c.isAccessible()){
            List<FCST_Product_Model__c> lstModel = [select Id,Opportunity__c from FCST_Product_Model__c where Opportunity__c IN: OppIds and Planning_Version__c=: lstMPlanningversion[0].id];
            
            map<Id,sObject> mapOpportunity = new map<Id,sObject>();
            MappingFieldUtility mfu = new MappingFieldUtility();
            
            for(sObject p: database.query('select id from Opportunity where id IN: OppIds')){
                mapOpportunity.put(string.valueOf(p.get('id')),p);
            }
            
            
        }
    }
    
    public static decimal getProductAmount(sObject item,sObject opp, MappingFieldUtility mfg){
        decimal totalprice = 0;        
        if( item.get('TotalPrice') <> null && Integer.valueOf(item.get('TotalPrice')) > 0 )
            totalprice = Integer.valueOf(item.get('TotalPrice'));
        
        return totalprice;
    }
    
    public static boolean IsRun=false;
    public static void AddModels(list<OpportunityLineItem> opplineitem){
        
        Mapping_Setting__c mapCustomObj=Mapping_Setting__c.getValues('FCST Mapping Data');
        
        String subRegionFieldAPi= mapCustomObj.Fcst_SubRegion__c;
        String BusinessUnitFieldAPi = mapCustomObj.Fcst_BusinessUnit__c;
        String cpmRegionFieldAPi = mapCustomObj.Fcst_CPM__c;
        String salesRegionFieldAPi=mapCustomObj.Fcst_SalesRegion__c;
        String revenueFieldAPi=mapCustomObj.Fcst_Revenue_Type__c;
        
        if(!IsRun){
            
            set<Id> setOppIds = new set<Id>();
            
            System.debug('...opplineitem>>>>>'+opplineitem);
            for(OpportunityLineItem line : opplineitem){
                setOppIds.add(line.opportunityId);
            }
            
            
            map<Integer,Fiscal_Year_Model__c> mapFiscalYear = new map<Integer,Fiscal_Year_Model__c>();
            map<String,Integer> mapFiscalId = new map<String,Integer>();
            map<string,boolean> mapConfigurationStages = new map<string,boolean>();
            for(string s : getPicklistValues('opportunity','stageName')){
                mapConfigurationStages.put(s,false);
            }
            if(Schema.sObjectType.Configuration_Setting__c.fields.Id.isAccessible() && Schema.sObjectType.Configuration_Setting__c.fields.Stage__c.isAccessible()){
                for(Configuration_Setting__c  c : [select Id,Stage__c from Configuration_Setting__c limit 1]){
                    if(c.stage__c <> null && c.stage__c <> ''){
                        for(string s : c.stage__c.split(',')){
                            mapConfigurationStages.put(s,true);
                        }
                    }           
                }
            }
            map<Integer,List<Integer>> mapFYear;
            if(Schema.sObjectType.Fiscal_Year_Model__c.fields.Id.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Name.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Year__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Start_Date__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.End_Date__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Number__c.isAccessible() ){
                for(Fiscal_Year_Model__c fy : [select Id,Name,Fiscal_Year__c,Start_Date__c,End_Date__c,Period_Number__c from Fiscal_Year_Model__c where name <> null]){
                    if(fy.Name <> null && fy.Period_Number__c <> null && fy.Fiscal_Year__c <> null ){
                        string cPeriod = (fy.Period_Number__c < 10)? '0'+fy.Period_Number__c:fy.Period_Number__c+'';
                        mapFiscalYear.put(Integer.valueOf(fy.Fiscal_Year__c+''+cPeriod),fy);
                        mapFiscalId.put(getDateId(fy.Start_Date__c)+'-'+getDateId(fy.End_Date__c),Integer.valueOf(fy.Fiscal_Year__c+''+cPeriod));
                    }
                }
            
            }
            List<FCST_Product_Model__c> lstModel = new List<FCST_Product_Model__c>();
            map<String,Id> mapFMeasureId = new map<String,Id>();
            if(Schema.sObjectType.Planning_Financial_Measure__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Financial_Measure__c.fields.Name.isAccessible()){
                for(Planning_Financial_Measure__c fm : [select id,Name from Planning_Financial_Measure__c where name = 'Revenue']){
                    mapFMeasureId.put(fm.Name,fm.Id);
                }
            }
            
            List<Planning_Version__c> lstMPlanningversion =new List<Planning_Version__c>();
            
            if(Schema.sObjectType.Planning_Version__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Name.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Previous_Version__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Closed_Date__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Start_Date__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Budget_Planning_Version__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Gap_Planning_Version__c.isAccessible()  ){
             lstMPlanningversion = [select Id,Name,Previous_Version__c,Version_Status__c,Data_Entry_Closed_Date__c,Data_Entry_Start_Date__c from Planning_Version__c where Data_Entry_Start_Date__c <> null
                                                             and Is_this_a_Budget_Planning_Version__c = false 
                                                             and Is_this_a_Gap_Planning_Version__c = false
                                                             and (Version_Status__c = 'Open (Admin)')
                                                            ];
            
            
            
            }
            if(setOppIds.size()>0){
                MappingFieldUtility mfu = new MappingFieldUtility();
                string getProjectStartDate = mfu.getProjectStartDate() !=''?mfu.getProjectStartDate()+',':'';
                string getProjectEndDate = mfu.getProjectEndDate() !=''?mfu.getProjectEndDate()+',':'';
                string mapq = 'select Id,'+getProjectStartDate+getProjectEndDate+'Account.'+subRegionFieldAPi+',Account.'+cpmRegionFieldAPi+',Account.'+salesRegionFieldAPi+',CloseDate,Probability,Amount,AccountId,Account.OwnerId,StageName,ExpectedRevenue,Deal_Duration__c from Opportunity where Id IN: setOppIds';
                map<id,Opportunity> mapOpportunity = new map<Id,Opportunity>();
                for(Opportunity p: database.query(mapq)){
                    mapOpportunity.put(p.Id,p);
                }
                System.debug('....mapOpportunity.'+mapOpportunity);
                map<string,FCST_Product_Model__c> mapModel = new map<string,FCST_Product_Model__c>();
                if(Schema.sObjectType.FCST_Product_Model__c.fields.Id.isAccessible() && Schema.sObjectType.FCST_Product_Model__c.fields.Account__c.isAccessible() && Schema.sObjectType.FCST_Product_Model__c.fields.Account_Owner__c.isAccessible() && Schema.sObjectType.FCST_Product_Model__c.fields.Name.isAccessible() && Schema.sObjectType.FCST_Product_Model__c.fields.Model_Name__c.isAccessible() && Schema.sObjectType.FCST_Product_Model__c.fields.Amount__c.isAccessible() && Schema.sObjectType.FCST_Product_Model__c.fields.Product__c.isAccessible() && Schema.sObjectType.FCST_Product_Model__c.fields.Planning_Version__c.isAccessible() && Schema.sObjectType.FCST_Product_Model__c.fields.Comments__c.isAccessible() && Schema.sObjectType.FCST_Product_Model__c.fields.Fiscal_Period__c.isAccessible() && Schema.sObjectType.FCST_Product_Model__c.fields.Planning_Measure__c.isAccessible() && Schema.sObjectType.FCST_Product_Model__c.fields.Opportunity__c.isAccessible()  && Schema.sObjectType.FCST_Product_Model__c.fields.User_Adjusted_Revenue__c.isAccessible() ){
                    for(FCST_Product_Model__c m : [select User_Adjusted_Revenue__c,Id,Account__c,Account_Owner__c,Name,Model_Name__c,Amount__c,Product__c,Planning_Version__c,Comments__c,Fiscal_Period__c,Planning_Measure__c,Opportunity__c from FCST_Product_Model__c where Opportunity__c IN: setOppIds]){
                        mapModel.put(m.Model_Name__c,m);
                        System.debug('mapModel>>>newRplan Name....'+m.Model_Name__c+'..newRplan....Id =='+m.Id+'......newRplan.Opportunity__c..'+m.Opportunity__c);
                                       
                    }
                }
                boolean isMultiCurrencyOrganization = userinfo.isMultiCurrencyOrganization();
                string DefaultCurrency = userinfo.getDefaultCurrency();
                map<Id,string> mapcurrency = new map<Id,string>();
                if(isMultiCurrencyOrganization){ FCST_CurrencyConversion.Initialization(); mapcurrency = FCST_CurrencyConversion.opportunityCurrencyCode(setOppIds);   }
                Integer cmProd = 0;Integer cmServ = 0;
                map<string,decimal> mapCMPercentage = new map<string,decimal>();
                map<string,Integer> mapRegimeCount = new map<string,Integer>();
                
                if(Schema.sObjectType.FCST_Revenue_Recognization_Product__c.fields.Id.isAccessible() && Schema.sObjectType.FCST_Revenue_Recognization_Product__c.fields.Name.isAccessible() && Schema.sObjectType.FCST_Revenue_Recognization_Product__c.fields.Key__c.isAccessible() && Schema.sObjectType.FCST_Revenue_Recognization_Product__c.fields.Revenue_Type__c.isAccessible() && Schema.sObjectType.FCST_Revenue_Recognization_Product__c.fields.Product__c.isAccessible() && Schema.sObjectType.FCST_Revenue_Recognization_Product__c.fields.product_code__c.isAccessible() && Schema.sObjectType.FCST_Revenue_Recognization_Product__c.fields.Period__c.isAccessible() && Schema.sObjectType.FCST_Revenue_Recognization_Product__c.fields.Amount__c.isAccessible()){
                    for(FCST_Revenue_Recognization_Product__c r : [select Id,Name,Key__c,Revenue_Type__c,Product__c,product_code__c,Period__c,Amount__c from FCST_Revenue_Recognization_Product__c where id <> null order by Period__c desc ]){
                        string key = r.Revenue_Type__c+'#'+get15DigitId(r.Product__c);
                        if(mapRegimeCount.containsKey(key)){
                            mapRegimeCount.put(key,mapRegimeCount.get(key)+1);
                        }
                        else mapRegimeCount.put(key,1);
                        mapCMPercentage.put(r.key__c,r.Amount__c);        
                        
                        
                                 
                    }
                }
                set<string> setValidModels = new set<string>();
                map<Id,set<Id>> mapExistingOppProducts = new map<Id,set<Id>>();
                set<Id> setLineProducts = new set<Id>();
                
                for(OpportunityLineItem line : opplineitem){
                    Opportunity opp = mapOpportunity.get(line.opportunityId);
                   // if(mapConfigurationStages.containsKey(opp.StageName) && mapConfigurationStages.get(opp.StageName) && line.ServiceDate <> null && lstMPlanningversion.size() >0 )
                    if(mapConfigurationStages.containsKey(opp.StageName) && lstMPlanningversion.size() >0 )
                    
                    {
                        setLineProducts.add(line.Product2Id);
                        System.debug('line.Product2Id>>>:'+line.Product2Id);
                    
                    }
                }
                String productQuery='select Id,'+revenueFieldAPi+' from Product2 where Id IN: setLineProducts ';
                
                List<Product2> productList=database.query(productQuery);
                
                map<Id,Product2> mapProducts = new map<Id,Product2>();
                
                if(productList!=null && productList.size()>0){
                    for(Product2 proObj:productList){
                        mapProducts.put(proObj.Id,proObj);
                    }
                }
                
                set<string> setRevenueType= new set<string>();
                if(Schema.sObjectType.Fcst_Rev_Rec_Revenue_Type__c.fields.Id.isAccessible() && Schema.sObjectType.Fcst_Rev_Rec_Revenue_Type__c.fields.Name.isAccessible() && Schema.sObjectType.Fcst_Rev_Rec_Revenue_Type__c.fields.Fcst_12_Month_Duration__c.isAccessible()){
                    for(Fcst_Rev_Rec_Revenue_Type__c p: [select Id,Name from Fcst_Rev_Rec_Revenue_Type__c where Fcst_12_Month_Duration__c = true]){
                        setRevenueType.add(p.Name);
                    }
                }
                for(OpportunityLineItem line : opplineitem){
                    Opportunity opp = mapOpportunity.get(line.opportunityId);
                    System.debug('...Opp.opp>>>>>>>'+Opp.Id);
                    String RevenueType='';
                    if(mapProducts.containsKey(line.Product2Id)){
                    Product2 productVal=mapProducts.get(line.Product2Id);
                    
                       RevenueType = (String) productVal.get(revenueFieldAPi);
                    }
                
                
                    if(RevenueType!=null && RevenueType!=''){ 
                   // String accBusinessUNit=(String) line.get(BusinessUnitFieldAPi);
                    String accCPMRegion=(String) opp.Account.get(cpmRegionFieldAPi);
                    String accSalesRegion=(String) opp.Account.get(salesRegionFieldAPi);
                    String accSubRegion=(String) opp.Account.get(subRegionFieldAPi);
                    
                    
                    
                    
                    string revRecKey = RevenueType+'#'+get15DigitId(line.product2Id);
                    if(opp.stageName != 'Closed Lost' && mapConfigurationStages.containsKey(opp.StageName) && mapConfigurationStages.get(opp.StageName) && lstMPlanningversion.size() >0 )
                    {
                        
                        Date ProjectStartDate =(mfu.getProjectStartDate(opp) <> null)?Date.valueOf(mfu.getProjectStartDate(opp)):null;
                        Date ProjectEndDate = (mfu.getProjectEndDate(opp) <> null)?Date.valueOf(mfu.getProjectEndDate(opp)):null;
                        Integer StartIndex = 0;
                        Integer EndIndex = 0;
                        Integer DealDuration = 0;
                        string productCode;
                        
                        System.debug('...Opp.CloseDate>>>>>>>'+Opp.CloseDate);
                         if(setRevenueType.contains(RevenueType)){
                            
                            if(line.Product2Id <> null  && mapRegimeCount.containsKey(revRecKey)){
                                DealDuration = mapRegimeCount.get(revRecKey);
                                productCode = revRecKey;
                            }                           
                            StartIndex = getFiscalYearId((Opp.CloseDate),mapFiscalId);
                            System.debug('>if>StartIndex>>>'+StartIndex);
                            EndIndex = getFiscalYearId((Opp.CloseDate).addMonths((DealDuration-1)),mapFiscalId);
                            
                        }else{
                            
                            StartIndex = getFiscalYearId(ProjectStartDate,mapFiscalId);
                            EndIndex = getFiscalYearId(ProjectEndDate,mapFiscalId);
                            System.debug('>else>StartIndex>>>'+StartIndex);
                        }
                        
                        System.debug('>>StartIndex>>>'+StartIndex);
                        Integer Interval = 0;
                        Interval = (EndIndex - StartIndex + 1);
                        Integer noOfModel=0;
                          if(StartIndex <> 0 && EndIndex <> 0){
                            
                            Integer index = 0;
                            for(Integer sI = StartIndex;sI <= EndIndex;sI++){
                                if(mapFiscalYear.Containskey(sI)){
                                    noOfModel++;
                                }
                                
                            }
                        }
                         
                        if(StartIndex <> 0 && EndIndex <> 0){
                            Integer index = 0;
                            for(Integer sI = StartIndex;sI <= EndIndex;sI++){
                                if(mapFiscalYear.Containskey(sI)){
                                
                                    index++;
                                    Fiscal_Year_Model__c fy = mapFiscalYear.get(sI);  
                                    for(Planning_Version__c PVersionObj: lstMPlanningversion){ 
                                        
                                        string PlanningVersionId = PVersionObj.id;
                                        
                                        //Revenue
                                        FCST_Product_Model__c newRplan = new FCST_Product_Model__c();
                                        if(isMultiCurrencyOrganization) newRplan.put('CurrencyISOCode', mapcurrency.get(opp.Id));                                        
                                        string modelName = get15DigitId(opp.Id)+'#'+get15DigitId(fy.Id)+'#'+get15DigitId(PlanningVersionId)+'#'+get15DigitId(line.Product2Id)+'#'+get15DigitId(line.Id);
                                        
                                        System.debug('map >>modelName....'+modelName);
                                        if(mapModel.containsKey(modelName)){  newRplan = mapModel.get(modelName);}
                                        else{
                                            newRplan.Opportunity__c = opp.Id;
                                        }
                                         System.debug('test>>>newRplan Name....'+newRplan.Name+'..newRplan....Id =='+newRplan.Id+'......newRplan.Opportunity__c..'+newRplan.Opportunity__c);
                                       
                                        
                                        decimal Percentage = 0;
                                        decimal WeightagePercentage = 0;
                                        string kk='';
                                        
                                        decimal d_productAmount = getProductAmount((sObject)line,(sObject)opp, mfu);
                                        
                                        string key = productCode;
                                        
                                        if(mapCMPercentage.containsKey(key+'#'+'M+'+index)){
                                            Percentage = mapCMPercentage.get(key+'#'+'M+'+index);
                                            WeightagePercentage = mapCMPercentage.get(key+'#'+'M+'+index);
                                        }
                                        
                                        kk = key+'#'+'M+'+index;
                                        
                                         System.debug('kk>>>:'+kk);
                                        decimal AmountR = 0;
                                        decimal WeightageR = 0;
                                        decimal RiskR = 0;
                                        if(setRevenueType.contains(RevenueType)){
                                            if(Percentage > 0  && line.TotalPrice > 0){
                                                AmountR = Math.Round((line.TotalPrice * (Percentage/ 100)));
                                            }
                                            
                                            
                                        }else if(line.TotalPrice > 0 && noOfModel > 0 ){
                                           // AmountR = Math.Round(line.TotalPrice / noOfModel);
                                             AmountR = Math.Round(((line.TotalPrice / 12)*noOfModel)/noOfModel);
                                        }                                       
                                        if(AmountR >0 && Opp.Probability > 0){
                                            WeightageR = Math.Round((AmountR * (Opp.Probability/100)));
                                        }
                                        if(WeightageR >0 && line.Risk_Factor__c > 0){
                                            RiskR = Math.Round((WeightageR * (line.Risk_Factor__c/100) * -1));
                                        }
                                        
                                        
                                       newRPlan.FCST_Revenue_Types__c= RevenueType;
                                        newRPlan.Product__c = line.Product2Id;
                                        if(accCPMRegion!=null)
                                            newRPlan.Account_CPM_Region__c = accCPMRegion;
                                        if(accSalesRegion!=null)
                                            newRPlan.Account_Sales_Region__c = accSalesRegion;
                                        if(accSubRegion!=null)
                                            newRPlan.Account_Sub_region__c = accSubRegion;
                                        
                                        
                                        sobject sOpp = (sObject)opp;                                        
                                        newRplan.Amount__c = (opp.stageName != 'Closed Lost')?AmountR:0;
                                        newRplan.Weighted_Revenue__c = (opp.stageName != 'Closed Lost')?WeightageR:0;
                                        newRplan.User_Adjusted_Revenue__c = (opp.stageName != 'Closed Lost')?WeightageR:0;
                                       // newRplan.Risk_Factor_Revenue__c = (opp.stageName != 'Closed Lost')?RiskR:0;
                                        setValidModels.add(modelName);
                                        newRplan.Planning_Version__c = PlanningVersionId;                                    
                                        newRplan.Comments__c = kk;
                                        newRplan.Fiscal_Period__c = fy.Id;
                                        newRplan.Planning_Measure__c = mapFMeasureId.get('Revenue');                                        
                                        newRplan.Account__c=opp.AccountId;
                                        newRplan.Account_Owner__c=opp.Account.OwnerId;
                                        newRplan.EndNumber__c = EndIndex;//mahesh added on 2712
                                        newRplan.FCST_Product_Line_ID__c = line.id;
                                        System.debug('>>>newRplan Name....'+newRplan.Name+'..newRplan....Id =='+newRplan.Id+'......newRplan.Opportunity__c..'+newRplan.Opportunity__c);
                                        lstModel.add(newRplan);
                                           
                                    }
                                }                   
                            } 
                        } 
                    }
                  }
                }   
                
                
                
                if(lstModel.size()>0)            
                {
                    System.debug('>>>lstModel....'+lstModel);
                    System.debug('>>>lstModel size()....'+lstModel.size());
                    for(FCST_Product_Model__c obj:lstModel){
                        System.debug('>>>Obj Name....'+obj.Name+'......Id =='+obj.Id+'..obj.Opportunity__c..'+obj.Opportunity__c);
                    }
                    if(FCST_Product_Model__c.SObjectType.getDescribe().isUpdateable() || FCST_Product_Model__c.SObjectType.getDescribe().isCreateable())
                    upsert lstModel;
                    
                    set<Id> setProductIds = new set<Id>();
                    set<Id> setOpportunityIds = new set<Id>();
                    set<Id> setOpportunityLineIds = new set<Id>();
                    
                    if(Schema.sObjectType.FCST_Product_Model__c.fields.Id.isAccessible() && Schema.sObjectType.FCST_Product_Model__c.fields.Product__c.isAccessible() && Schema.sObjectType.FCST_Product_Model__c.fields.Opportunity__c.isAccessible() && Schema.sObjectType.FCST_Product_Model__c.fields.FCST_Product_Line_ID__c.isAccessible() ){
                        for(FCST_Product_Model__c m: [select Id,Product__c,Opportunity__c,FCST_Product_Line_ID__c  from FCST_Product_Model__c where Id IN: lstModel]){
                            setProductIds.add(m.Product__c);
                            setOpportunityIds.add(m.Opportunity__c);
                            setOpportunityLineIds.add(m.FCST_Product_Line_ID__c);
                        }
                    }
                    Id currentVersionId,previousVersionId;
                    if(lstMPlanningversion.size()>0){   currentVersionId = lstMPlanningversion[0].Id;   previousVersionId = lstMPlanningversion[0].previous_Version__c;}
                    
                    if(setOpportunityIds.size()>0 && setProductIds.size()>0 && currentVersionId <> null && FCST_Product_Model__c.sObjectType.getDescribe().isDeletable()){
                        delete [select Id from FCST_Product_Model__c where Id Not IN: lstModel and Planning_Version__c <>: previousVersionId and Planning_Version__c =: currentVersionId and Opportunity__c IN:setOpportunityIds and Product__c IN: setProductIds and FCST_Product_Line_ID__c IN:setOpportunityLineIds limit 10000];
                    }
                    IsRun = true;
                }
            }      
        }       
    } 
}