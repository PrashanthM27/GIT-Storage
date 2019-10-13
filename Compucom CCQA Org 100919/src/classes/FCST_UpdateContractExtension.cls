public class FCST_UpdateContractExtension {
     
         public Contractwrapper ContractObj{get;set;}
        string OppId;    
        public Opportunity opp{get;set;}
        public SObject geo{get;set;}
        public string status{get;set;} 
        public string duplicatestatus{get;set;} 
        public String qnum{get;set;}
        public string cfiscalyear{get;set;} 
        public String revenuetype{get;set;}
        public String geonumber{get;set;}
        public String geoname{get;set;}
        public Decimal linetotal{get;set;}    
        public FCST_Contract__c con{get;set;} 
        public List<FCST_Opportunity_Initial_Forecast__c> oppInitialList{get;set;}    
        public Planning_Version__c planningVersion{get;set;}  
        public List<Fcst_Cost_Center__c> costcentrelist{get;set;} 
        public Map<String,Fcst_Cost_Center__c> mapCostDesc{get;set;} 
        public Map<String,String> OppInitialListMap{get;set;} 
        public Map<String,String> InitialListMap{get;set;} 
        public map<Id,decimal> mapParentIntial{get;set;}
        public map<Id,decimal> mapParentIntialLine{get;set;}
        public boolean saveCheck{get;set;}
         public String RevenueTypeStr;
        public FCST_UpdateContractExtension(ApexPages.StandardController con){
        	saveCheck=false;
            OppId = apexpages.currentpage().getparameters().get('id');
            getFiscalYears();
            searchContract();
            getCostCentre();
            lineItemInitialTotal();
             Map<String,Mapping_Setting__c> custMapCons = Mapping_Setting__c.getAll();
        System.debug('==='+custMapCons);
        if(custMapCons.size()>0){
            for(Mapping_Setting__c mapping : custMapCons.values()){
              
                if(mapping.Fcst_Revenue_Type__c <> null){
                 RevenueTypeStr= mapping.Fcst_Revenue_Type__c;
                }
            }
             
        }
        }
        
        @AuraEnabled
        public static string getOpportunityStage(string recordId){
            return [select Id,StageName from Opportunity where Id=:recordId].StageName;
        }
        
        public string generateDynamicId(){
            return (Math.Random()*10000)+'';
        }
        
        List<Fiscal_Year_Model__c> lstPeriods;
        public List<FCST_Initial_Forecast__c> createInitialForecast(Id ContractId, Id lineId,Id accId){
            List<FCST_Initial_Forecast__c> InitialItems = new List<FCST_Initial_Forecast__c>();
            for(Fiscal_Year_Model__c p: lstPeriods){
                FCST_Initial_Forecast__c i = new FCST_Initial_Forecast__c(
                    FCST_Planning_Fiscal_Year__c = p.id,
                    FCST_Fiscal_Year_List__c = p.Fiscal_Planning_Year__c,
                    Fcst_Amount__c = 0,
                    Contract_LineItem__c = lineId,
                    FCST_Contract__c = contractId,
                    Account__c=accId
                );
                InitialItems.add(i);
            }
            return InitialItems;
        }
        
        public List<FCST_Initial_Forecast__c> createInitialForecast(Id ContractId){
            List<FCST_Initial_Forecast__c> InitialItems = new List<FCST_Initial_Forecast__c>();
            for(FCST_Opportunity_Initial_Forecast__c p: [select Fcst_Opportunity__r.AccountId,Id,User_Adjusted_Revenue__c,Fcst_Fiscal_Period__c,Fcst_Fiscal_Period__r.Fiscal_Planning_Year__c from FCST_Opportunity_Initial_Forecast__c where Fcst_Opportunity__c=: OppId]){
                FCST_Initial_Forecast__c i = new FCST_Initial_Forecast__c(
                    FCST_Planning_Fiscal_Year__c = p.Fcst_Fiscal_Period__c,
                    FCST_Fiscal_Year_List__c = p.Fcst_Fiscal_Period__r.Fiscal_Planning_Year__c,
                    Fcst_Amount__c = p.User_Adjusted_Revenue__c,
                    FCST_Contract__c = contractId 
                );
                
                InitialItems.add(i);
            }
            return InitialItems;
        }
            
         public List<SelectOption> getProduct(){
           List<SelectOption> options = new List<SelectOption>();
             options.add(new SelectOption('','-- None --')); 
             if(RevenueTypeStr != null){ 
           Set<String> revTypeSet =getPicklistValues('Product2',RevenueTypeStr);
              for (String s : revTypeSet)
              { 
                options.add(new SelectOption(s,s)); 
                  
              }
       }
     
        return options;
        }
      
        public void searchContract(){
            lstPeriods = new List<Fiscal_Year_Model__c>();
            linetotal = 0;
            //duplicatestatus = null;
            if(cfiscalyear <> null){
                String openAdmin = 'Open (Admin)';
                String VersionStatusString  = 'SELECT Id, Name, Version_Status__c FROM Planning_Version__c Where Version_Status__c =:openAdmin LIMIT 1';
                planningVersion = database.query(VersionStatusString);
                System.debug('planningVersion.id'+planningVersion.id); 
                lstPeriods = [select Id,Short_Label__c,Period_Number__c,Fiscal_Planning_Year__c from Fiscal_Year_Model__c where Fiscal_Planning_Year__r.Name=:cfiscalyear  order by Period_Number__c];
                id planningid = planningVersion.id;
               
               System.debug('lstPeriods >>>>>'+lstPeriods.size() );
               
                string intialtermfields = 'FCST_Contract__c,Contract_LineItem__c, Fcst_Amount__c,FCST_Fiscal_Year_List__c,FCST_Planning_Fiscal_Year__r.Name,FCST_Planning_Fiscal_Year__c,Planning_Version__c';
                string q = 'select Id,Contract__c,FCST_Q__c,Fcst_Geo_Numbers__c,Fcst_Account__c,Contract_Description__c'+',(select Id,'+intialtermfields+' from FCST_Initial_Forecasts__r where Contract_LineItem__c != null and FCST_Fiscal_Year_List__r.Name =: cfiscalyear and Planning_Version__c =: planningid order by Fiscal_Period__c asc),(select Id,FCST_Fiscal_Year_List__c,BSLA_Number__c,BSLA__c,FCST_Contract__c,Cost_Center_Description__c,Fcst_Revenue_Type__c,Cost_Center__c,Line_Description__c,BU_Level1__c,BU_Level2__c,Contract_LineItem__c.Name  from Contract_LineItems__r) from FCST_Contract__c where Opportunity__c =: OppId ';

                
                List<FCST_Contract__c> lstContracts = database.query(q +' limit 1');
                System.debug('lstContracts'+lstContracts);
              /*  for(FCST_Contract__c a : lstContracts){
                    for(FCST_Initial_Forecast__c i : a.FCST_Initial_Forecasts__r){
                    System.debug('i'+i);    
                    }
                    
                } */
                string coststring = 'SELECT Id,Name,Cost_Center_Description__c,BSLA__c,BU_Level1__c,BU_Level_2__c FROM Fcst_Cost_Center__c'; 
                
                
                costcentrelist = database.query(coststring);              
                 mapCostDesc = new Map<String,Fcst_Cost_Center__c>();        
                    for(Fcst_Cost_Center__c a : costcentrelist){
                        mapCostDesc.put(a.Name, a);                    
                    }
                Map<id,FCST_Opportunity_Initial_Forecast__c> MapIdVsOppInitialForecast =  new Map<id,FCST_Opportunity_Initial_Forecast__c>();
                oppInitialList = [select Id,Fcst_Weighted_Revenue__c,FCST_Product_Revenue__c,FCST_Service_Revenue__c,FCST_Transition_Revenue__c,User_Adjusted_Revenue__c,Fcst_Q__c,Fcst_Fiscal_Period__c,Fcst_Fiscal_Period__r.Fiscal_Planning_Year__c,Fcst_Fiscal_Period__r.Period_Number__c  from FCST_Opportunity_Initial_Forecast__c where Fcst_Opportunity__c=: OppId and Fcst_Fiscal_Period__r.Fiscal_Year__c =: cfiscalyear and FCST_Planning_Version__c =: planningid Order By Fcst_Fiscal_Period__c ASC];
                System.debug('oppInitialList'+oppInitialList);
                for(FCST_Opportunity_Initial_Forecast__c a : oppInitialList){
                    System.debug('inside');
                    if(a.User_Adjusted_Revenue__c==null){
                        a.User_Adjusted_Revenue__c=0;
                    }
                    if(a.FCST_Product_Revenue__c==null){
                        a.FCST_Product_Revenue__c=0;
                    }
                    if(a.FCST_Service_Revenue__c==null){
                        a.FCST_Service_Revenue__c=0;
                    }
                    if(a.FCST_Transition_Revenue__c==null){
                        a.FCST_Transition_Revenue__c=0;
                    }
                    MapIdVsOppInitialForecast.put(a.id,a);
                    
                }
                System.debug('MapIdVsOppInitialForecast'+MapIdVsOppInitialForecast);
                MappingFieldUtility mfu = new MappingFieldUtility();
                String qnumber = mfu.getQNum(); 
                String geonumberapi = mfu.getGeoNum();
                
                String oppQueryString = 'select Id,StageName,Fcst_Text_QNum__c, Owner.Name, AccountId,CloseDate,'+mfu.getQNum()+','+mfu.getGeoNum()+' from Opportunity where Id =: OppId ';
                
                opp = database.query(oppQueryString);
                String abc = (String)opp.get(geonumberapi);
                if(abc != null){
                    String geoquery = 'SELECT Id,Name FROM '+geonumberapi+' Where id =: abc';
                    geo = database.query(geoquery);
                    System.debug('geo'+geo.get('Name'));
                }
                
                opp.Fcst_Text_QNum__c = (String)opp.get(qnumber);
                System.debug('opp.Fcst_Text_QNum__c'+opp.Fcst_Text_QNum__c);
                if(abc!= null){
                    String geostring = (String)geo.get('Name');
                    geonumber = geostring.SubStringBefore(' ');
                    geoname = geostring.substringAfter(' ');
                    System.debug('geonumber'+geonumber);
                    System.debug('geoname'+geoname);
                }
                List<FCST_Opportunity_Initial_Forecast__c> initList = new List<FCST_Opportunity_Initial_Forecast__c>();
                for(Fiscal_Year_Model__c m : lstPeriods){
                    FCST_Opportunity_Initial_Forecast__c obj = new FCST_Opportunity_Initial_Forecast__c();
                    obj.Fcst_Fiscal_Period__c = m.id;
                    obj.FCST_Product_Revenue__c = 0;
                    obj.FCST_Service_Revenue__c = 0;
                    obj.FCST_Transition_Revenue__c = 0;
                    //obj.Fcst_Weighted_Revenue__c = 0;
                    obj.User_Adjusted_Revenue__c = 0;
                    if(OppId != null){obj.Fcst_Opportunity__c = OppId;}
                    if(planningVersion.id != null){obj.FCST_Planning_Version__c = planningVersion.id;}
                    if(opp.Fcst_Text_QNum__c != null){obj.Fcst_Q__c = opp.Fcst_Text_QNum__c;}
                    initList.add(obj);
                }
               System.debug('initList size()>>>'+initList.size());
                
                for(FCST_Opportunity_Initial_Forecast__c a : MapIdVsOppInitialForecast.values()){
                    if(MapIdVsOppInitialForecast.containsKey(a.id)){
                   // a.Fcst_Weighted_Revenue__c=Math.round(a.Fcst_Weighted_Revenue__c);
                    if(a.User_Adjusted_Revenue__c!=null){a.User_Adjusted_Revenue__c=Math.round(a.User_Adjusted_Revenue__c);}
                    
                    System.debug('a.Fcst_Fiscal_Period__r.Period_Number__c>>'+a.Fcst_Fiscal_Period__r.Period_Number__c);
                    
                      if(a.Fcst_Fiscal_Period__c!=null && a.Fcst_Fiscal_Period__r.Period_Number__c == 1){
                        initList[0] = a;
                            }
                     
                    if(a.Fcst_Fiscal_Period__c!=null && a.Fcst_Fiscal_Period__r.Period_Number__c == 2){
                        initList[1] = a;
                       }
                    if(a.Fcst_Fiscal_Period__c!=null && a.Fcst_Fiscal_Period__r.Period_Number__c == 3){
                        initList[2] = a;
                       
                    }
                    if(a.Fcst_Fiscal_Period__c!=null && a.Fcst_Fiscal_Period__r.Period_Number__c == 4){
                        initList[3] = a;
                       
                    }
                    if(a.Fcst_Fiscal_Period__c!=null && a.Fcst_Fiscal_Period__r.Period_Number__c == 5){
                        initList[4] = a;
                    }
                    if(a.Fcst_Fiscal_Period__c!=null && a.Fcst_Fiscal_Period__r.Period_Number__c == 6){
                        initList[5] = a;
                    }
                    if(a.Fcst_Fiscal_Period__c!=null && a.Fcst_Fiscal_Period__r.Period_Number__c == 7){
                        initList[6] = a;
                    }
                    if(a.Fcst_Fiscal_Period__c!=null && a.Fcst_Fiscal_Period__r.Period_Number__c == 8){
                        initList[7] = a;
                    }
                    if(a.Fcst_Fiscal_Period__c!=null && a.Fcst_Fiscal_Period__r.Period_Number__c == 9){
                        initList[8] = a;
                    }
                    if(a.Fcst_Fiscal_Period__c!=null && a.Fcst_Fiscal_Period__r.Period_Number__c == 10){
                        initList[9] = a;
                    }
                    if(a.Fcst_Fiscal_Period__c!=null && a.Fcst_Fiscal_Period__r.Period_Number__c == 11){
                        initList[10] = a;
                    }                                
                    if(a.Fcst_Fiscal_Period__c!=null && a.Fcst_Fiscal_Period__r.Period_Number__c == 12){
                        initList[11] = a;
                    }
                    
                
                }
                }
                oppInitialList.clear();
                oppInitialList.addAll(initList);
              System.debug('oppInitialList'+oppInitialList);
                
                
                
                List<FCST_Initial_Forecast__c> InitialItems;
                List<ContractLinewrapper> lstLine;
                if(lstContracts.size()>0){
                    con = lstContracts[0];           
                    //opp.Fcst_Text_QNum__c = (String)opp.get(qnumber);
                    lstLine = new List<ContractLinewrapper>();
                    if(con.FCST_Initial_Forecasts__r <> null && con.FCST_Initial_Forecasts__r.size() > 0){
                        InitialItems = con.FCST_Initial_Forecasts__r;
                        
                    }
                    else{
                        InitialItems = createInitialForecast(con.Id);
                    }
                    map<Id,List<FCST_Initial_Forecast__c>> mapLine_InitialTerm = new map<Id,List<FCST_Initial_Forecast__c>>();
                    if(con.Contract_LineItems__r <> null && con.Contract_LineItems__r.size()>0){
                        for(FCST_Initial_Forecast__c f: [select Id,FCST_Contract__c,Contract_LineItem__c,Fcst_Amount__c,FCST_Fiscal_Year_List__c,Planning_Version__c,
                        FCST_Planning_Fiscal_Year__r.Name from FCST_Initial_Forecast__c where  Planning_Version__c=:planningVersion.Id and Contract_LineItem__c IN: con.Contract_LineItems__r and 
                        FCST_Contract__c =: con.Id and FCST_Fiscal_Year_List__r.Name =: cfiscalyear order by Fiscal_Period__c desc]){
                            linetotal+= f.Fcst_Amount__c;
                            List<FCST_Initial_Forecast__c> lstIntialTerm = new List<FCST_Initial_Forecast__c>{f};
                            if(mapLine_InitialTerm.containsKey(f.Contract_LineItem__c)){
                                lstIntialTerm.addAll(mapLine_InitialTerm.get(f.Contract_LineItem__c));
                            }
                            mapLine_InitialTerm.put(f.Contract_LineItem__c,lstIntialTerm);
                        }
                        for(Contract_LineItem__c l:con.Contract_LineItems__r){
                            System.debug('con.Fcst_Account__c>>>'+con.Fcst_Account__c);
                            List<FCST_Initial_Forecast__c> InitialItemsLine = (mapLine_InitialTerm.containsKey(l.id))?mapLine_InitialTerm.get(l.id):createInitialForecast(con.Id,l.id,con.Fcst_Account__c);
                            lstLine.add(new ContractLinewrapper(l.id,l,InitialItemsLine,false));
                        }
                    }
                    
                }else{
               
                    
                    con = new FCST_Contract__c();               
                    con.FCST_Q__c =   opp.Fcst_Text_QNum__c;
                    con.Opportunity__c = oppId; 
                    con.FCST_Contract_Created_Year__c = String.valueOf(opp.CloseDate.year());
                    InitialItems = createInitialForecast(null);
                    lstLine = new List<ContractLinewrapper>();              
                }
                
                
                
                
                if(InitialItems == null || InitialItems.size() == 0)InitialItems = createInitialForecast(con.Id,null,null);
                ContractObj = new Contractwrapper(con,InitialItems,lstLine);
                List<WMonths> lstWMonths = new List<WMonths>();
                for(Fiscal_Year_Model__c m: lstPeriods){
                    lstWMonths.add(new WMonths(m.Period_Number__c,m.Short_Label__c));
                }
                ContractObj.months = lstWMonths;
            }
            System.debug('linetotal'+linetotal); 
            
        }
        
        public decimal getOpportunityInitialTotal(){
            
            decimal total = 0;
            if(ContractObj <> null){
                for(FCST_Opportunity_Initial_Forecast__c f: oppInitialList){
                    if(f.User_Adjusted_Revenue__c!=null)
                    total+=f.User_Adjusted_Revenue__c;
                    
                }
                
                
            }
            return total;
        }
    
    	public decimal getProductRevenueTotal(){
            
            decimal total = 0;
            if(ContractObj <> null){
                for(FCST_Opportunity_Initial_Forecast__c f: oppInitialList){
                    if(f.FCST_Product_Revenue__c!=null)
                    total+=f.FCST_Product_Revenue__c;
                    
                }
                
                
            }
            return total;
        }
    
    	public decimal getTransitionRevenueTotal(){
            
            decimal total = 0;
            if(ContractObj <> null){
                for(FCST_Opportunity_Initial_Forecast__c f: oppInitialList){
                    if(f.FCST_Transition_Revenue__c!=null)
                    total+=f.FCST_Transition_Revenue__c;
                    
                }
                
                
            }
            return total;
        }
    
    	public decimal getServiceRevenueTotal(){
            
            decimal total = 0;
            if(ContractObj <> null){
                for(FCST_Opportunity_Initial_Forecast__c f: oppInitialList){
                    if(f.FCST_Service_Revenue__c!=null)
                    total+=f.FCST_Service_Revenue__c;
                    
                }
                
                
            }
            return total;
        }
    
        public void lineItemDuplicateValue(){
            for(ContractLinewrapper s: ContractObj.lineItems){
                s.line.Fcst_Revenue_Type__c = s.line.Fcst_Revenue_Type__c;
               if(s.line.Cost_Center__c != null){    
               s.line.BU_Level1__c = mapCostDesc.get(s.line.Cost_Center__c).BU_Level1__c;              
               }
            }
                duplicatestatus = null;
            set<string> setline = new set<String>();
                map<string,id> mapLineItemDuplicate = new map<string,Id>();
                string duplicatekey;            
            FCST_Contract__c contract = ContractObj.contract;  
                for(Contract_LineItem__c f: [select Id,Fcst_Revenue_Type__c,FCST_Fiscal_Year_List__c,Cost_Center__c,Cost_Center_Description__c,FCST_Contract__c,Line_Description__c,BSLA__c,BU_Level1__c,BU_Level2__c from Contract_LineItem__c 
                where FCST_Contract__c=: contract.Id]){
                                   
                   mapLineItemDuplicate.put(f.Line_Description__c+'#'+f.Fcst_Revenue_Type__c+'#'+f.Cost_Center__c+'#'+f.BU_Level1__c+'#'+f.BSLA__c, f.id);
                    //setline.add(f.Line_Description__c+'#'+f.Fcst_Revenue_Type__c+'#'+f.Cost_Center__c+'#'+f.BU_Level1__c+'#'+f.BSLA__c);
                }
            System.debug('mapLineItemDuplicate'+mapLineItemDuplicate.keySet());
                String concat;
               //Save Contract's LineItems 
                for(ContractLinewrapper s: ContractObj.lineItems){                
                    if(s.line.FCST_Contract__c == null){s.line.FCST_Contract__c = contract.Id;}    
                    if(s.line.BSLA_Number__c != null){
                        string bs = s.line.BSLA_Number__c;
                        concat = bs.substring(0,1);
                        System.debug('concat'+concat);
                    }
                    
                    if(mapCostDesc.containsKey(s.line.Cost_Center__c)){s.line.Cost_Center_Description__c = mapCostDesc.get(s.line.Cost_Center__c).Cost_Center_Description__c;}                
                    if(mapCostDesc.containsKey(s.line.Cost_Center__c)){s.line.BU_Level1__c = mapCostDesc.get(s.line.Cost_Center__c).BU_Level1__c;}
                    if(mapCostDesc.containsKey(s.line.Cost_Center__c)){s.line.BU_Level2__c = mapCostDesc.get(s.line.Cost_Center__c).BU_Level_2__c;}
                    if(concat != null && concat == '1'){s.line.BSLA__c = 'US';}else if(concat != null && concat == '2'){s.line.BSLA__c = 'CANADA';}
                    duplicatekey = s.line.Line_Description__c+'#'+s.line.Fcst_Revenue_Type__c+'#'+s.line.Cost_Center__c+'#'+s.line.BU_Level1__c+'#'+s.line.BSLA__c;
                    System.debug('duplicatekey'+duplicatekey);
                    System.debug('s.line.id'+s.line.id);
                    if(mapLineItemDuplicate.containsKey(duplicatekey) && s.line.id == null){
                       System.debug('null in 1');
                        duplicatestatus = 'duplicate';                        
                    } 
                    else if(mapLineItemDuplicate.containsKey(duplicatekey) && s.line.id != null){
                       System.debug('null in 2');
                        //duplicatestatus = 'duplicate';
                                            
                    }else{
                        System.debug('null in 3');
                        //duplicatestatus = 'duplicate';
                    }
                }
            
        }
        public void lineItemInitialTotal(){
            
            status = null;
            if(ContractObj <> null){
                mapParentIntial = new map<Id,decimal>();
                if(oppInitialList <> null ){
                    for(FCST_Opportunity_Initial_Forecast__c f: oppInitialList){                    
                        mapParentIntial.put(f.Fcst_Fiscal_Period__c,f.User_Adjusted_Revenue__c); 
                        System.debug('>>mapParentIntial>>>'+mapParentIntial);                  
                    }                
                }
                
                ContractObj.MoreThanAmounts = '';
                if(ContractObj.lineItems <> null){
                    mapParentIntialLine = new map<Id,decimal>();
                    Decimal num = 0;
                    for(ContractLinewrapper w: ContractObj.lineItems){
                        decimal total = 0;
                        w.MoreThanAmounts = '';
                        
                        if(w.InitialItems <> null){
                            for(FCST_Initial_Forecast__c i: w.InitialItems){
                                 System.debug('>>FCST_Initial_Forecast__c>>>'+i.Fcst_Amount__c); 
                                total += i.Fcst_Amount__c;                            
                                decimal t = i.Fcst_Amount__c;
                                if(mapParentIntialLine.containsKey(i.FCST_Planning_Fiscal_Year__c)){
                                    t+=mapParentIntialLine.get(i.FCST_Planning_Fiscal_Year__c);                                
                                }
                                mapParentIntialLine.put(i.FCST_Planning_Fiscal_Year__c,t);
                                 System.debug('>>mapParentIntialLine>>>'+mapParentIntialLine); 
                                //apexpages.addmessage(new apexpages.message(apexpages.severity.error,i.FCST_Planning_Fiscal_Year__c+':'+mapParentIntial.get(i.FCST_Planning_Fiscal_Year__c)+':'+i.Fcst_Amount__c));
                            }
                            
                        }
                        w.total  = total;
                       
                    }
                   
                    string ErrorPeriod = '';
                    for(Id periodId: mapParentIntial.keyset()){
                        //apexpages.addmessage(new apexpages.message(apexpages.severity.error,periodId+':'+ mapParentIntialLine.get(periodId) +':::'+ mapParentIntial.get(periodId)));
                   
                        if(mapParentIntial.containsKey(periodId) && mapParentIntialLine.containsKey(periodId) && mapParentIntialLine.get(periodId) > mapParentIntial.get(periodId)){
                            ErrorPeriod += periodId+',';
                           // status= 'linefailure';
                            System.debug('status'+status);
                        }
                    }
                    System.debug('ErrorPeriod'+ErrorPeriod);
                    ContractObj.MoreThanAmounts = ErrorPeriod;                  
                    
                }
            }
        }
        
        public list<SelectOption> getFiscalYears(){
            List<Fiscal_Year_Planning__c> FiscalYear = [select Id,Name from Fiscal_Year_Planning__c Order By Name]; 
            list<SelectOption> options = new List<selectOption>();
            if(cfiscalyear == null)cfiscalyear = string.valueOf(system.today().year());
            for(Fiscal_Year_Planning__c  i : FiscalYear)
            options.add(new selectOption(i.Name+'',i.Name+''));
            return options;
        }
        
        public list<SelectOption> getCostCentre(){
            list<SelectOption> options = new List<selectOption>();
            costcentrelist.sort();
             options.add(new SelectOption('','-- None --')); 
            for(Fcst_Cost_Center__c a: costcentrelist){
                options.add(new selectOption(a.Name,a.Name));
            }        
            return options;
        }
        
        public list<SelectOption> getBSLA(){
            list<SelectOption> options = new List<selectOption>();
            options.add(new SelectOption('','-- None --')); 
            Schema.DescribeFieldResult fieldResult = Fcst_Cost_Center__c.BSLA__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            List<String> str = new List<String>();
            for( Schema.PicklistEntry f : ple){        
                      str.add(f.getValue());         
            }
            str.sort();
            if(str!=null && str.size()>0){
            	for( String stObj:str){        
                      options.add(new SelectOption(stObj, stObj));         
              }
            }
                   
            return options;
        }
        
        public void addContractLineItem(){
            List<ContractLinewrapper> lineItems = new List<ContractLinewrapper>();
            
            List<FCST_Initial_Forecast__c> InitialItems;
            if(ContractObj.contract <> null && ContractObj.contract.id <> null)
            InitialItems = createInitialForecast(ContractObj.contract.id,null,null);
            else InitialItems = createInitialForecast(null,null,null);
            
            lineItems.add(new ContractLinewrapper(generateDynamicId(),new Contract_LineItem__c(),InitialItems,true));
            if((ContractObj.lineItems <> null && ContractObj.lineItems.size()>0)){
                lineItems.addAll(ContractObj.lineItems);
            }
            ContractObj.lineItems = lineItems;
            System.debug('ContractObj.lineItems'+ContractObj.lineItems);
        }
        public void removeContractLineItem(){
            string lineId = apexpages.currentpage().getparameters().get('lineId');
            List<ContractLinewrapper> lineItems = new List<ContractLinewrapper>();
            for(ContractLinewrapper s: ContractObj.lineItems){
                if(s.lineId != lineId){
                    lineItems.add(s);
                }
            }
            System.debug('lineItems'+lineItems);
            ContractObj.lineItems = lineItems;
            lineItemInitialTotal();
        }
        public void RevertProduct(){
            string lineId = apexpages.currentpage().getparameters().get('lineId'); 
            for(ContractLinewrapper p: ContractObj.lineItems){
                if(p.LineId == lineId){
                    p.isEditable = false;
                }
            }
             ContractObj.lineItems =  new List<ContractLinewrapper>();
            searchContract();
        }
        public void EditProduct(){
            string lineId = apexpages.currentpage().getparameters().get('lineId'); 
            for(ContractLinewrapper p: ContractObj.lineItems){
                if(p.LineId == lineId){
                    p.isEditable = true;
                }
            }               
        }
        public pagereference goBack(){
            pagereference pg = new pagereference('/'+OppId);
            pg.setRedirect(true);
            return pg;
        }
        
        
        public void saveContract(){
        	saveCheck=true;
                lineItemInitialTotal();
            //try{
                status = null;
                duplicatestatus = null;
               // List<FCST_Initial_Forecast__c> InitialItems = new List<FCST_Initial_Forecast__c>();
                List<FCST_Opportunity_Initial_Forecast__c> OppList = new List<FCST_Opportunity_Initial_Forecast__c >();
                List<Contract_LineItem__c> lstContracts = new List<Contract_LineItem__c>();
                List<FCST_Initial_Forecast__c> LineInitialItems = new List<FCST_Initial_Forecast__c>();
                
            
                Fiscal_Year_Planning__c FiscalYear = [select Id from Fiscal_Year_Planning__c where Name=: cfiscalyear limit 1];
                //Planning_Version__c planningVersion = [SELECT Id, Name, Version_Status__c FROM Planning_Version__c Where Version_Status__c = 'Open (Admin)' LIMIT 1];
                //System.debug('planningVersion'+planningVersion);    
            //Save Contract Object
              
                FCST_Contract__c contract = ContractObj.contract;    
                contract.FCST_Contract_Created_Year__c = String.valueOf(opp.CloseDate.year());
                if(opp.AccountId <> null)contract.Fcst_Account__c = opp.AccountId;
               // if(opp.Owner.Name <> null)contract.Contract_Owner__c = opp.OwnerId;            
                if(opp.Fcst_Text_QNum__c!=null)contract.FCST_Q__c =   opp.Fcst_Text_QNum__c;
                if(geonumber != null)contract.Fcst_Geo_Numbers__c = String.valueOf(geonumber); 
                System.debug('geoname'+geoname);          
                if(geoname != null)contract.Fcst_Geo_Name__c = geoname;            
                if(contract!=null){
                    upsert contract;
                } 
                if(opp!=null){
                   // update opp;                 
                }
                Integer intround = 0;
                Set<id> fyearSet = new set<id>();
                for(FCST_Opportunity_Initial_Forecast__c i : oppInitialList){  
                    fyearSet.add(i.Fcst_Fiscal_Period__c);
                    System.debug('fyearSet'+fyearSet);
                }
                
                for(FCST_Opportunity_Initial_Forecast__c i : oppInitialList){  
                             
                    if(i.User_Adjusted_Revenue__c !=null){i.User_Adjusted_Revenue__c = math.round(i.User_Adjusted_Revenue__c);}
                    if(i.Fcst_Q__c == null){i.Fcst_Q__c = opp.Fcst_Text_QNum__c;}
                    if(fyearSet.contains(i.Fcst_Fiscal_Period__c)){
                    OppList.add(i);}
                }
            
                if(OppList.size()>0){
                    upsert OppList;
                }
            
            /*    //Save Contract's InitialItems
                for(FCST_Initial_Forecast__c i: ContractObj.InitialItems){
                    if(i.FCST_Contract__c == null){i.FCST_Contract__c = contract.Id;}
                    InitialItems.add(i);   
                }
                if(InitialItems.size()>0){
                    upsert InitialItems;
                    delete [select Id from FCST_Initial_Forecast__c where Id NOT IN: InitialItems and FCST_Contract__c =: contract.Id and Contract_LineItem__c = null and FCST_Fiscal_Year_List__c =: FiscalYear.Id];
                }
                */
                set<string> setline = new set<String>();
                map<string,id> mapLineItemDuplicate = new map<string,Id>();
                string duplicatekey;            
                for(Contract_LineItem__c f: [select Id,Fcst_Revenue_Type__c,FCST_Fiscal_Year_List__c,Cost_Center__c,Cost_Center_Description__c,FCST_Contract__c,Line_Description__c,BSLA__c,BU_Level1__c,BU_Level2__c from Contract_LineItem__c 
                where FCST_Contract__c=: contract.Id]){
                                   
                   mapLineItemDuplicate.put(f.Line_Description__c+'#'+f.Fcst_Revenue_Type__c+'#'+f.Cost_Center__c+'#'+f.BU_Level1__c+'#'+f.BSLA__c, f.id);
                    //setline.add(f.Line_Description__c+'#'+f.Fcst_Revenue_Type__c+'#'+f.Cost_Center__c+'#'+f.BU_Level1__c+'#'+f.BSLA__c);
                }
            System.debug('mapLineItemDuplicate'+mapLineItemDuplicate.keySet());
                String concat;
               //Save Contract's LineItems 
                for(ContractLinewrapper s: ContractObj.lineItems){                
                    if(s.line.FCST_Contract__c == null){s.line.FCST_Contract__c = contract.Id;}    
                    if(s.line.BSLA_Number__c != null){
                        string bs = s.line.BSLA_Number__c;
                        concat = bs.substring(0,1);
                        System.debug('concat'+concat);
                    }
                    
                    if(mapCostDesc.containsKey(s.line.Cost_Center__c)){s.line.Cost_Center_Description__c = mapCostDesc.get(s.line.Cost_Center__c).Cost_Center_Description__c;}                
                    if(mapCostDesc.containsKey(s.line.Cost_Center__c)){s.line.BU_Level1__c = mapCostDesc.get(s.line.Cost_Center__c).BU_Level1__c;}
                    if(mapCostDesc.containsKey(s.line.Cost_Center__c)){s.line.BU_Level2__c = mapCostDesc.get(s.line.Cost_Center__c).BU_Level_2__c;}
                    if(concat != null && concat == '1'){s.line.BSLA__c = 'US';}else if(concat != null && concat == '2'){s.line.BSLA__c = 'CANADA';}
                    
                         lstContracts.add(s.line); 
                    
                }
                if(lstContracts.size()>0){
                    upsert lstContracts;
                    System.debug('lstContracts'+lstContracts);
                 }
                    List<Contract_LineItem__c> acc = new List<Contract_LineItem__c>();
            acc  = [select Id from Contract_LineItem__c where Id NOT IN: lstContracts  and FCST_Contract__c =: contract.Id];
            System.debug('acc'+acc);
            delete [select Id from Contract_LineItem__c where Id NOT IN: lstContracts  and FCST_Contract__c =: contract.Id];
                
                
                //get Contract's InitialItems
                /*map<string,Id> mapInitialForecast = new map<string,Id>();
                for(FCST_Initial_Forecast__c f: [select Id,FCST_Planning_Fiscal_Year__c,FCST_Fiscal_Year_List__c from FCST_Initial_Forecast__c 
                where Contract_LineItem__c = null and FCST_Contract__c=: contract.Id]){
                    mapInitialForecast.put(f.FCST_Planning_Fiscal_Year__c+'#'+f.FCST_Fiscal_Year_List__c,f.id);
                }*/
                
                //get Contract's LineItem
                map<string,Id> mapLineItem = new map<string,Id>();
                for(Contract_LineItem__c f: [select Id,Fcst_Revenue_Type__c,FCST_Fiscal_Year_List__c,Cost_Center__c,Cost_Center_Description__c,FCST_Contract__c,Line_Description__c,BSLA__c,BU_Level1__c,BU_Level2__c from Contract_LineItem__c 
                where FCST_Contract__c=: contract.Id]){
                    mapLineItem.put(f.Cost_Center__c+'#'+f.Line_Description__c+'#'+f.id+'#'+f.FCST_Fiscal_Year_List__c,f.id);
                }
                
                //Save Contact's LineItem's InitialItems
                for(ContractLinewrapper s: ContractObj.lineItems){
                    string linekey = s.line.Cost_Center__c+'#'+s.line.Line_Description__c+'#'+s.line.id+'#'+s.line.FCST_Fiscal_Year_List__c;

                    for(FCST_Initial_Forecast__c f:s.InitialItems){
                        if(f.FCST_Contract__c == null)f.FCST_Contract__c = contract.Id;
                        if(f.Planning_Version__c == null)f.Planning_Version__c = planningVersion.Id;
                        if(Opp.AccountId <> null)f.Account__c = Opp.AccountId;                    
                        if(f.Fcst_Amount__c!=null){f.Fcst_Amount__c = math.round(f.Fcst_Amount__c);}
                        if(f.Contract_LineItem__c == null && mapLineItem.containsKey(linekey))f.Contract_LineItem__c = mapLineItem.get(linekey);
                        if(f.Contract_LineItem__c <> null && f.FCST_Contract__c <> null){
                        LineInitialItems.add(f);                                
                    }
                    }
                }
                if(LineInitialItems.size()>0){
                    System.debug('LineInitialItems'+LineInitialItems);
                    upsert LineInitialItems;
                }
                    delete [select Id from FCST_Initial_Forecast__c where Id NOT IN: LineInitialItems and FCST_Contract__c =: contract.Id and Contract_LineItem__c =: null and FCST_Fiscal_Year_List__c =: FiscalYear.Id];
                
                
                status = 'success';                 
                searchContract();       
            /*}catch(Exception e){
                status = 'failure';
            }*/
        }
        
        
        public class Contractwrapper{
            public FCST_Contract__c contract{get;set;}
            public List<WMonths> months{get;set;}
            public List<FCST_Initial_Forecast__c> InitialItems{get;set;}
            public string MoreThanAmounts{get;private set;}       
            public List<ContractLinewrapper> lineItems{get;set;}
            public Contractwrapper(FCST_Contract__c contract, List<FCST_Initial_Forecast__c> InitialItems,List<ContractLinewrapper> lineItems){
                this.contract = contract;
                this.InitialItems = InitialItems;
                this.lineItems = lineItems;
            }
        }
        public class WMonths{
            public Decimal seq{get;set;}
            public string name{get;set;}
            public WMonths(Decimal seq,string name){this.name = name;this.seq = seq;}
        }
        public class ContractLinewrapper{
            public string lineId{get;set;}
            public boolean isEditable{get;set;}
            public decimal total{get;set;}       
            public string MoreThanAmounts{get;private set;}        
            public Contract_LineItem__c line{get;set;}
            public List<FCST_Initial_Forecast__c> InitialItems{get;set;}
            public ContractLinewrapper(string lineId, Contract_LineItem__c line,List<FCST_Initial_Forecast__c> InitialItems, boolean editable){
                this.lineId = lineId;
                this.line = line;
                this.InitialItems = InitialItems;
                this.isEditable = editable;
                this.total = 0;            
                this.MoreThanAmounts = '';           
                for(FCST_Initial_Forecast__c t: InitialItems){
                    total += t.Fcst_Amount__c;
                    
                }
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