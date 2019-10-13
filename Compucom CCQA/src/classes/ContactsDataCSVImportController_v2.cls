public class ContactsDataCSVImportController_v2{
    
    public Blob csvFileBody{get;set;}
    public string fileName{get;set;} 
    public String headerString; 
    Public String bodyString;  
    
    public datetime ErrorlogInsertedTime;
    public Planning_Version__c currentVersion;
    public Integer TotalRecord{get;set;}
    public Integer SuccessRecord{get;set;}
    public Integer FailRecord{get;set;}
    public boolean showmore{get;set;}
    public string prjClin; 
    public ContactsDataCSVImportController_v2(){
        showmore = false;
        TotalRecord = SuccessRecord = FailRecord= 0;
        List<Planning_Version__c> lstMPlanningversion = [select Id,Name from Planning_Version__c where Data_Entry_Start_Date__c <> null
        and Is_this_a_Budget_Planning_Version__c = false 
        and Is_this_a_Gap_Planning_Version__c = false
        and (Version_Status__c = 'Open (Admin)')
        ];
        if(lstMPlanningversion.size()>0){
            currentVersion = lstMPlanningversion[0];
        }           
    } 
    
    public String blobToString(Blob input, String inCharset){
        
        String hex = EncodingUtil.convertToHex(input);
        System.assertEquals(0, hex.length() & 1);
        final Integer bytesCount = hex.length() >> 1;
        String[] bytes = new String[bytesCount];
        for(Integer i = 0; i < bytesCount; ++i)
            bytes[i] =  hex.mid(i << 1, 2);
        return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset);
    } 
    public string getAmountFromString(string rowstr){
        string str = rowstr;
        if(rowstr.contains('"')){
            try{
            integer index1= rowstr.indexOf('"')+1;
            string p1= rowstr.substring(index1);
            integer index2= p1.indexOf('"')+index1;         
            string amount = rowstr.substring(index1,index2);
            amount = amount.replace(',','');
            str = rowstr.substring(0,index1-1)+amount+rowstr.substring(index2+1);
            }catch(Exception e){
                system.debug(e.getLineNumber()+'@@'+e.getMessage());
            }
        }
        if(str <> null && str <> ''){
            str = str.replaceAll(' ,',',');
            str = str.replaceAll(', ',',');
        }
        return str;
    }
    
    public static void setErrorMessage(WrapperModel m, string msg){
        m.errorMessage = (m.errorMessage == null)?msg:m.errorMessage+', '+msg;
    }
    public static string getFieldValue(string fv){
      //  System.debug('.before ...fv...'+fv);
        fv = getFieldStrValue(fv);
       // System.debug('.aftyer ...fv...'+fv);
        if(fv <> null && fv.trim() <> ''){return fv.trim();}
        return null;
    }
    public static decimal getStringToNumber(string fv){
    	if(fv==null)
    		fv='0';
    		
    	if( fv.contains('(') || fv.contains(')')){
    		fv='-'+fv;
    	}
    	if(fv.contains('$') || fv.contains('(') || fv.contains(')')  || fv.contains(',') ){
    		fv = fv.replace('$','');
    		fv = fv.replace('(','');
    		fv = fv.replace(')','');
    		fv = fv.replace(',','');
    		fv = fv.trim();
    		
    	}
    	
    	
        if(fv <> null ){return decimal.valueOf(fv);}
        return 0;
    }
    public static string getAcceptableCSV(string csvLine){      
        Integer startIndex;
        Integer endIndex;
        if(csvLine <> null && csvLine <> ''){
            while(csvLine.indexOf('"') > -1){
                if(startIndex == null){
                    startIndex = csvLine.indexOf('"');
                    csvLine = csvLine.substring(0, startIndex) + ':quotes:' + csvLine.substring(startIndex+1, csvLine.length());
                }else{
                    if(endIndex == null){
                        endIndex = csvLine.indexOf('"');
                        csvLine = csvLine.substring(0, endIndex) + ':quotes:' + csvLine.substring(endIndex+1, csvLine.length());
                    }
                }
                if(startIndex != null && endIndex != null){
                    String sub = csvLine.substring(startIndex, endIndex);
                    sub = sub.replaceAll(',', ':comma:');
                    csvLine = csvLine.substring(0, startIndex) + sub + csvLine.substring(endIndex, csvLine.length());
                    startIndex = null;
                    endIndex = null;
                }
            }
        }
        return csvLine;
    }
    public static string getFieldStrValue(string column){  
        //System.debug('...column>>>>'+column);    
        if(column <> null && column <> '')
        {
            column = column.replaceAll(':quotes:', '').replaceAll(':comma:', ',');
        }//System.debug('.after ..column>>>>'+column); 
        return column;  
    }
    public void uploadCSV(){
        showmore = false;
        
        List<WrapperModel> lstWrapperModel;
        List<Actual_Model__c> lstActualModels;
        lstActualModels =  new List<Actual_Model__c>();
        lstWrapperModel = new List<WrapperModel>();
        
        
        //try{
            
            if(csvFileBody == null){
                ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'Please Select File to upload');
                ApexPages.addMessage(errorMessage );
                return;
            }
            string csvAsString = getAcceptableCSV(blobToString(csvFileBody,'ISO-8859-1'));
           // system.debug('csvAsString:'+string.valueOf(csvFileBody));
            
			 csvAsString = csvAsString.replace('\n', '');
            //csvAsString = csvAsString.replace('"', '');
            csvAsString = csvAsString.trim();
            String[] csvFileLines1 = csvAsString.split('####');  
            set<string> SetContract_Number = new set<string>();
            set<string> SetAccount = new set<string>();
            set<string> SetAccountManager = new set<string>();
            set<string> SetYear = new set<string>();
            set<string> SetPlanningVersion = new set<string>();
            
            string rowstr1 = getAmountFromString(csvFileLines1[0]);
            if(rowstr1!=null){
	            string[] csvRecordData = rowstr1.split(',');
	            headerString =getFieldValue(csvRecordData[0])+',';
	            headerString+=getFieldValue(csvRecordData[1])+',';
	            headerString+=getFieldValue(csvRecordData[2])+',';
	            headerString+=getFieldValue(csvRecordData[3])+',';
	            headerString+=getFieldValue(csvRecordData[4])+',';
	            headerString+=getFieldValue(csvRecordData[5])+',';
	            headerString+=getFieldValue(csvRecordData[6])+',';
	            headerString+=getFieldValue(csvRecordData[7])+',';
	            headerString+=getFieldValue(csvRecordData[8])+',';
	            headerString+=getFieldValue(csvRecordData[9])+',';
	            
	            headerString+=getFieldValue(csvRecordData[10])+',';
	            headerString+=getFieldValue(csvRecordData[11])+',';
	            headerString+=getFieldValue(csvRecordData[12])+',';
	            headerString+=getFieldValue(csvRecordData[13])+',';
	            headerString+=getFieldValue(csvRecordData[14])+',';
	            headerString+=getFieldValue(csvRecordData[15])+',';
	            headerString+=getFieldValue(csvRecordData[16])+',';
	            headerString+=getFieldValue(csvRecordData[17])+',';
	            headerString+=getFieldValue(csvRecordData[18])+',';
	            headerString+=getFieldValue(csvRecordData[19])+',';
	            headerString+=getFieldValue(csvRecordData[20])+',';
	            headerString+=getFieldValue(csvRecordData[21])+',';
	            headerString+=getFieldValue(csvRecordData[22])+',';
	            headerString+=getFieldValue(csvRecordData[23])+',';
	            headerString+=getFieldValue(csvRecordData[24])+',';
	            headerString+='Error Message'+'\n';
	            
            }
            //System.debug('>>>headerString>>>'+headerString);
            for(Integer i=1;i<csvFileLines1.size();i++){
                WrapperModel m = new WrapperModel() ;
                string rowstr = getAmountFromString(csvFileLines1[i]);
                for(integer k=0;k<20;k++){rowstr = getAmountFromString(rowstr);}
                
                string[] csvRecordData = rowstr.split(',');
                
             //  System.debug('CSVRecData:......'+csvRecordData);
               // m.Account_Manager = getFieldValue(csvRecordData[0]);
                m.BSLA_Description = getFieldValue(csvRecordData[0]);
                m.BSLA_Number = getFieldValue(csvRecordData[1]);
                 
                m.CC_PLevel = getFieldValue(csvRecordData[2]);
                m.Annuity_Project = getFieldValue(csvRecordData[3]);
 
                m.GEO_Number =getFieldValue(csvRecordData[4]);
                m.GEO_Name = getFieldValue(csvRecordData[5]);
                m.Client_Name = getFieldValue(csvRecordData[6]);
                m.Contract_Number = getFieldValue(csvRecordData[7]);
               // System.debug('...... getFieldValue(csvRecordData[8])>>>>  '+getFieldValue(csvRecordData[8]));
                m.Contract_Name_Description = getFieldValue(csvRecordData[8]);
               
                m.Business_Unit = getFieldValue(csvRecordData[9]);
 
                m.Months = new list<decimal>();
                m.Months.add(getStringToNumber(getFieldValue(csvRecordData[10])));
                m.Months.add(getStringToNumber(getFieldValue(csvRecordData[11])));
                m.Months.add(getStringToNumber(getFieldValue(csvRecordData[12])));
                m.Months.add(getStringToNumber(getFieldValue(csvRecordData[13])));
                m.Months.add(getStringToNumber(getFieldValue(csvRecordData[14])));
                m.Months.add(getStringToNumber(getFieldValue(csvRecordData[15])));
                m.Months.add(getStringToNumber(getFieldValue(csvRecordData[16])));
                m.Months.add(getStringToNumber(getFieldValue(csvRecordData[17])));
                m.Months.add(getStringToNumber(getFieldValue(csvRecordData[18])));
                m.Months.add(getStringToNumber(getFieldValue(csvRecordData[19])));
                m.Months.add(getStringToNumber(getFieldValue(csvRecordData[20])));
                m.Months.add(getStringToNumber(getFieldValue(csvRecordData[21])));
               // m.Months.add(getStringToNumber(getFieldValue(csvRecordData[22])));

                m.Baseline_year = getFieldValue(csvRecordData[22]);
                m.Planning_version = getFieldValue(csvRecordData[23]);
                m.Year = getFieldValue(csvRecordData[24]);
                
                m.errorMessage = null;
                
                lstWrapperModel.add(m);
                
                SetAccount.add(m.Client_Name);
                SetContract_Number.add(m.Contract_Number);
              //  SetAccountManager.add(m.Account_Manager);
                SetYear.add(m.Year);
                SetPlanningVersion.add(m.Planning_version);
              //System.debug('SetAccount:'+SetAccount);
              /*    System.debug('SetContract_Number===>>'+SetContract_Number);
                System.debug('SetYear:'+SetYear);
                System.debug('SetPlanningVersion:'+SetPlanningVersion);*/
            }  
            
            //System.debug('lstWrapperModel:'+lstWrapperModel);
            
            map<string,FCST_Contract__c> mapExistingContract = new map<string,FCST_Contract__c>();
            for(FCST_Contract__c c: [select Id,Fcst_Account__c, Contract__c, Contract_Description__c, 
            FCST_Contract_Created_Year__c, Fcst_Geo_Name__c, Fcst_Geo_Numbers__c, FCST_Q__c, Opportunity__c 
            from FCST_Contract__c where Contract__c IN: SetContract_Number ]){
                //System.debug('mapExistingContract==>>'+mapExistingContract);
                mapExistingContract.put(c.Contract__c,c);
            }
                           // System.debug('mapExistingContract==>>'+mapExistingContract);

            
            map<string,Account> mapExistingAccount = new map<string,Account>();
            for(Account Acc: [select Id,Name from Account where Name IN: SetAccount]){
                mapExistingAccount.put(Acc.Name.trim(),Acc);
            }
           // map<string,User> mapExistingUser = new map<string,User>();
           // for(User v: [select Id,NAme,isActive from User where name IN:SetAccountManager]){
           //     mapExistingUser.put(v.Name,v);
          //  }
            map<string,Fiscal_Year_Planning__c> mapExistingYear = new map<string,Fiscal_Year_Planning__c>();
            map<string,Fiscal_Year_Model__c> mapExistingPeriod = new map<string,Fiscal_Year_Model__c>();
            for(Fiscal_Year_Planning__c y: [select Id,Name,(select Id,Name,Copy_Month__c from FCST_Planning_Fiscal_Years__r order by Copy_Month__c) from Fiscal_Year_Planning__c where Name IN: SetYear]){
                mapExistingYear.put(y.Name,y);
                for(Fiscal_Year_Model__c p:y.FCST_Planning_Fiscal_Years__r){
                    mapExistingPeriod.put(p.Name,p);
                }
            }
            map<string,Planning_Version__c> mapExistingVersions = new map<string,Planning_Version__c>();
            for(Planning_Version__c v: [select Id,Name from Planning_Version__c where name IN: SetPlanningVersion]){
                mapExistingVersions.put(v.Name,v);
            }
            
            List<FCST_Contract__c> lstContracts = new List<FCST_Contract__c>();
            set<string> setProcessedContactIds = new set<string>();
            for(WrapperModel m: lstWrapperModel){
                
                boolean isCorrect = true;
                
                if(m.Contract_Number == null){isCorrect = false;setErrorMessage(m,'Contract # is required');}
                
                if(m.Client_Name == null){isCorrect = false;setErrorMessage(m,'Client Name is requied');}
                else if(!mapExistingAccount.ContainsKey(m.Client_Name)){isCorrect = false;setErrorMessage(m,'Client Name is not present in org');}
                
              //  if(m.Account_Manager == null){isCorrect = false;setErrorMessage(m,'Account Manager is requied');}
              //  else if(!mapExistingUser.ContainsKey(m.Account_Manager)){isCorrect = false;setErrorMessage(m,'Account Manager is not present in org');}

                if(isCorrect && !setProcessedContactIds.contains(m.Contract_Number)){
                    FCST_Contract__c contract = new FCST_Contract__c();
                    if(mapExistingContract.containsKey(m.Contract_Number)){
                        contract = mapExistingContract.get(m.Contract_Number);
                    }else{
                        //contract.Opportunity__c = '0061U000007JQRQ';//hard coded value opportunty is not present in 
                    }
                    contract.Fcst_Account__c = mapExistingAccount.get(m.Client_Name).Id;
                    contract.Contract__c = m.Contract_Number;
                   // contract.Contract_Description__c = m.Contract_Name_Description;
                    //contract.Contract_Owner__c = mapExistingUser.get(m.Account_Manager).Id;
                    contract.Fcst_Geo_Numbers__c = m.GEO_Number;
                    contract.Fcst_Geo_Name__c = m.GEO_Name;
                    contract.FCST_Contract_Created_Year__c = m.Baseline_year;
                    lstContracts.add(contract);
                    setProcessedContactIds.add(m.Contract_Number);
                }
            }
            if(lstContracts.size()>0){
              // system.debug('lstContracts?>>>>:'+lstContracts);
                upsert lstContracts;
                
                mapExistingContract = new map<string,FCST_Contract__c>();
                for(FCST_Contract__c c: [select Id,Contract__c,
                (select Id,Cost_Center__c, Cost_Center_Description__c,FCST_Contract__r.Contract__c, FCST_Contract__c, FCST_Fiscal_Year_List__c, 
                Fcst_Geo_Code__c,Fcst_Revenue_Type__c, Line_Description__c, BSLA_Number__c,BSLA__c,Risk_Factor__c from Contract_LineItems__r)  
                from FCST_Contract__c where Contract__c IN: SetContract_Number  ]){
                    mapExistingContract.put(c.Contract__c,c);
                }
                
                List<Contract_LineItem__c> lstContractLines = new List<Contract_LineItem__c>();
                set<string> setProcessedContractLines = new set<string>();
                set<string> checkDuplicate = new set<string>();
                for(WrapperModel m: lstWrapperModel){
                    string key = m.Contract_Number +'#'+m.CC_PLevel+'#'+m.BSLA_Number+'#'+m.Contract_Name_Description;
                    boolean duplicateRecord=false;
                    if(checkDuplicate.contains(key)){
                    	setErrorMessage(m,'duplicate record');
                    	duplicateRecord=true;
                    }
                    else{
                    	checkDuplicate.add(key);
                    }
                    	
                   // System.debug('key>>>.>>>>>>>'+key);
                    boolean isCorrect = true;
                    if(m.CC_PLevel == null){isCorrect = false;setErrorMessage(m,'CC/PLevel is required');}
                    if(m.Year == null){isCorrect = false;setErrorMessage(m,'Year is required');}
                    else if(!mapExistingYear.containsKey(m.Year)){isCorrect = false;setErrorMessage(m,'Year is not present in org.');}
                    
                   // System.debug('key>>>.>>>>>>>'+key);
                  //  System.debug('mapExistingContract>>>.>>>>>>>'+mapExistingContract);
                    
                    if(!setProcessedContractLines.contains(key) && isCorrect && mapExistingContract.containsKey(m.Contract_Number)){
                        Contract_LineItem__c line = new Contract_LineItem__c();
                        string costcenter = (m.CC_PLevel.contains(' '))?(m.CC_PLevel).split(' ')[0]:null;
                        string linedescription = (m.CC_PLevel.contains(' '))?(m.CC_PLevel).substring((m.CC_PLevel).indexOf(' ')+1):null;
                        boolean chkduplicate=false;
                        for(Contract_LineItem__c l:  mapExistingContract.get(m.Contract_Number).Contract_LineItems__r){
                            if(
                            
                                (l.Cost_Center__c <> null && costcenter <> null && l.Cost_Center__c.equalsIgnoreCase(CostCenter)) && 
                                (l.Line_Description__c <> null && m.Contract_Name_Description <> null && l.Line_Description__c.equalsIgnoreCase(m.Contract_Name_Description))
                                ){chkduplicate=true;
                                	
                                	// System.debug('mapExistingContract>>>.>>>>>>>'+l.FCST_Contract__c+'#'+l.Cost_Center_Description__c+'#'+l.BSLA_Number__c+'#'+l.FCST_Contract__r.Contract_Description__c);
                                //line = l;break;
                                setErrorMessage(m,'Record already Exists.');
                            }
                        }
                        if(CostCenter <> null && m.Contract_Name_Description <> null){
                            line.Cost_Center__c = CostCenter;
                            line.Fcst_Revenue_Type__c = m.Annuity_Project;                           
                            line.Line_Description__c = m.Contract_Name_Description;
                            line.Cost_Center_Description__c = linedescription;
                            line.BSLA_Number__c = m.BSLA_Number;
                            line.BSLA__c = m.BSLA_Description;
                            if(m.Business_Unit!=null)
                            line.BU_Level1__c = m.Business_Unit;
                            
                            if(line.id == null)line.FCST_Contract__c = mapExistingContract.get(m.Contract_Number).Id;
                            line.FCST_Fiscal_Year_List__c = mapExistingYear.get(m.Year).Id;
                            if(chkduplicate==false && duplicateRecord==false)
                             lstContractLines.add(line);
                             
                            setProcessedContractLines.add(key);
                        }else{
                        	if(m.Contract_Name_Description==null){
                        		setErrorMessage(m,'Contract Name/ Desc is Mandatory');
                        	}
                        	
                        	else{
                            	setErrorMessage(m,'CC/PLevel must be in form of cost center space line description');
                        	}
                        }
                    }
                }
                
                if(lstContractLines.size()>0){
                    
                    upsert lstContractLines;
                    
                    mapExistingContract = new map<string,FCST_Contract__c>();
                    set<Id> setLineItems = new set<Id>();
                    for(FCST_Contract__c c: [select Id,Contract__c,
                    (select Id,Cost_Center__c, Cost_Center_Description__c, FCST_Contract__c, FCST_Fiscal_Year_List__c, 
                    Fcst_Geo_Code__c,Fcst_Revenue_Type__c, Line_Description__c, Risk_Factor__c from Contract_LineItems__r)  
                    from FCST_Contract__c WHERE Contract__c IN: SetContract_Number]){
                        mapExistingContract.put(c.Contract__c,c);
                        for(Contract_LineItem__c l: c.Contract_LineItems__r)setLineItems.add(l.id);
                    }
                
                    map<Id, List<FCST_Initial_Forecast__c>> mapLineInitialAmounts = new map<Id, List<FCST_Initial_Forecast__c>>();
                    for(FCST_Initial_Forecast__c i: [select id,FCST_Planning_Fiscal_Year__r.Name,Account__c, Account_Id__c, Account_OwnerId__c, Contract_LineItem__c, Fcst_Amount__c, 
                    FCST_Baseline_Created_Year__c, FCST_Contract__c, FCST_Fiscal_Year_List__c, FCST_Planning_Fiscal_Year__c, 
                    Fiscal_Period__c, Forecast_with_Risk__c, Planning_Version__c, RiskAmount__c from FCST_Initial_Forecast__c where Contract_LineItem__c IN: setLineItems]){
                    
                        List<FCST_Initial_Forecast__c> lstInitials = new List<FCST_Initial_Forecast__c>();
                        lstInitials.add(i);
                        if(mapLineInitialAmounts.containsKey(i.Contract_LineItem__c)){
                            lstInitials.addAll(mapLineInitialAmounts.get(i.Contract_LineItem__c));
                        }
                        mapLineInitialAmounts.put(i.Contract_LineItem__c,lstInitials);
                    }
                    
                    List<FCST_Initial_Forecast__c> lstInitials = new List<FCST_Initial_Forecast__c>();
                    set<string> setInitials = new set<string>();
                    for(WrapperModel m: lstWrapperModel){
                        string key = m.Contract_Number +'#'+m.CC_PLevel+'#'+m.BSLA_Number+'#'+m.Contract_Name_Description;
                        string costcenter = (m.CC_PLevel.contains(' '))?(m.CC_PLevel).split(' ')[0]:null;
                        string linedescription = (m.CC_PLevel.contains(' '))?(m.CC_PLevel).substring((m.CC_PLevel).indexOf(' ')+1):null;
                        boolean isCorrect = true;
                        if(m.Planning_Version == null){isCorrect = false;setErrorMessage(m,'Planning Version is required');}
                        else if(!mapExistingVersions.containsKey(m.Planning_Version)){isCorrect = false;setErrorMessage(m,'Planning Version is not present in org.');}
                        Contract_LineItem__c sLine;
                        
                        if(!setInitials.contains(key) && mapExistingContract.containsKey(m.Contract_Number) && isCorrect){
                            for(Contract_LineItem__c l:  mapExistingContract.get(m.Contract_Number).Contract_LineItems__r){ 
                                
                                if(l.Cost_Center__c <> null && costcenter <> null && l.Cost_Center__c.equalsIgnoreCase(CostCenter) && l.Line_Description__c <> null &&  m.Contract_Name_Description <> null && l.Line_Description__c.equalsIgnoreCase( m.Contract_Name_Description)){
                                    sLine = l;
                                    
                                }
                            }
                            
                          //  system.debug('#sLine:'+sLine);
                            if(sLine <> null){
                                for(integer i=1;i<=12;i++){
                                    string period = (i<10)?'0'+i:i+'';
                                    period = 'FY'+m.Year+'P'+period;
                                  //  system.debug('#mapExistingPeriod:'+mapExistingPeriod+'###'+period);
                                  //  system.debug('#mapExistingPeriod.containsKey(period):'+mapExistingPeriod.containsKey(period));
                                  boolean duplicate=false;
                                    if(mapExistingPeriod.containsKey(period)){
                                        FCST_Initial_Forecast__c initial = new FCST_Initial_Forecast__c();
                                        if(mapLineInitialAmounts.containsKey(sLine.id)){
                                            for(FCST_Initial_Forecast__c t: mapLineInitialAmounts.get(sLine.id)){
                                                if(period == t.FCST_Planning_Fiscal_Year__r.Name){
                                                	duplicate=true;
                                                    initial = t;break;
                                                    setErrorMessage(m,Period+' is not present in org.');
                                                }
                                            }
                                        }
                                        if(mapExistingAccount.containsKey(m.Client_Name))
                                         initial.Account__c = mapExistingAccount.get(m.Client_Name).Id;
                                         
                                        if(initial.id == null)initial.Contract_LineItem__c = sLine.Id;
                                        initial.Fcst_Amount__c = m.Months[i-1];
                                        initial.FCST_Contract__c = mapExistingContract.get(m.Contract_Number).Id;
                                        initial.FCST_Fiscal_Year_List__c=  mapExistingYear.get(m.Year).Id;
                                        initial.FCST_Planning_Fiscal_Year__c = mapExistingPeriod.get(Period).Id;
                                        initial.Planning_Version__c = mapExistingVersions.get(m.Planning_Version).Id;
                                        if(duplicate==false)
                                         lstInitials.add(initial);
                                         
                                        setInitials.add(key);
                                    }else{
                                        setErrorMessage(m,Period+' is not present in org.');
                                    }                                       
                                }
                            }
                        }
                    }
                   // system.debug('#lstInitials:'+lstInitials);
                    if(lstInitials.size()>0){
                        upsert lstInitials;
                    }
                }
            }
            
            
            
            //Report
            SuccessRecord = 0;
            List<Fcst_BaseLine_Error_Log__c> lstErrorLog = new List<Fcst_BaseLine_Error_Log__c>();
            bodyString='';
            for(WrapperModel m: lstWrapperModel){
                if(m.errorMessage <> null){
                	//System.debug(' is not present in org.mm=='+m);
                    Fcst_BaseLine_Error_Log__c error = new Fcst_BaseLine_Error_Log__c();        
                    error.Fcst_Account__c = m.Client_Name ;
                    //error.Fcst_Amount__c = m.Months+'' ;
                    error.Fcst_Baseline_year__c = m.Baseline_year ;
                    error.Fcst_Contract__c = m.Contract_Number ;
                    error.Fcst_Contract_Description__c = m.Contract_Name_Description ;
                    //error.Fcst_Cost_Center__c = m.CC_PLevel ;
                    error.Fcst_Fiscal_Year__c = m.Year ;
                    error.Fcst_Line_Description__c = m.CC_PLevel ;
                    error.Fcst_LineItem__c = null ;
                    error.Fcst_Month__c = null ;
                    error.Fcst_planning_version__c = null ;
                    error.Fcst_Year__c = m.year ;
                    error.ErrorMsg__c = m.errorMessage;
                    lstErrorLog.add(error);
                    
                    bodyString+= m.BSLA_Description+','+m.BSLA_Number +','+m.CC_PLevel+','+m.Annuity_Project+','+m.GEO_Number+','+m.GEO_Name+','+m.Client_Name+','+m.Contract_Number+','+m.Contract_Name_Description+','+m.Business_Unit+','+m.Months[0]+','+m.Months[1]+','+m.Months[2]+','+m.Months[3]+','+m.Months[4]+','+m.Months[5]+','+m.Months[6]+','+m.Months[7]+','+m.Months[8]+','+m.Months[9]+','+m.Months[10]+','+m.Months[11]+','+m.Baseline_year+','+m.Planning_version+','+m.Year+','+m.errorMessage+'\n';
                }else{
                    SuccessRecord++;
                }
            }
            Boolean bodyStringVal=true;
            if(bodyString==null || bodyString=='')
             bodyStringVal=false;
             
            bodyString=headerString+bodyString;
            TotalRecord = lstWrapperModel.size();            
            ErrorlogInsertedTime = system.now();            
            insert lstErrorLog;
            FailRecord = lstErrorLog.size();
            
            if(lstWrapperModel.size()>999)showmore = true;
            if(bodyStringVal==false){
	            String loginUserEmail=UserInfo.getUserEmail();
	
				Messaging.EmailFileAttachment csvAttachment = new Messaging.EmailFileAttachment();
				Blob csvBlob = blob.valueOf(bodyString);
				String csvSuccessName = 'Baseline Error Log.csv';
				csvAttachment.setFileName(csvSuccessName);
				csvAttachment.setBody(csvBlob);
				
				Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
				String[] toAddresses = new String[]{loginUserEmail};
				String subject = 'Baseline Error Log Details' ;
				email.setSubject(subject);
				email.setToAddresses(toAddresses);
				email.setPlainTextBody('All Failed Baseline Data');
				email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttachment});
				Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
            }
        /*}
        catch (Exception e)
        {
            csvFileBody = null;
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,e.getLinenumber()+', '+e.getMessage()+'');
            ApexPages.addMessage(errorMessage );
        }  */
    }
    public list<Fcst_BaseLine_Error_Log__c> getErrorFile(){
        if(ErrorlogInsertedTime == null)return null;
        return [select Id,Fcst_Account__c,Fcst_Amount__c,Fcst_Baseline_year__c,Fcst_Contract__c,ErrorMsg__c,Fcst_Contract_Description__c,Fcst_Cost_Center__c,Fcst_Fiscal_Year__c,Fcst_Line_Description__c,Fcst_LineItem__c,Fcst_Month__c,Fcst_planning_version__c,Fcst_Year__c
        from Fcst_BaseLine_Error_Log__c where Createddate >=: ErrorlogInsertedTime and CreatedById =: userinfo.getUserId() limit 1000];
    }


    public class WrapperModel{
 
        //public string Account_Manager;
        public string BSLA_Description;
        public string BSLA_Number;        
        public string CC_PLevel;
        public string Annuity_Project;
        
        public string GEO_Number;
        public string GEO_Name;
        public string Client_Name;
        public string Contract_Number;
        public string Contract_Name_Description;
        public string Business_Unit;
      
        public List<decimal> Months;
        
        public string Baseline_year;
        public string Planning_version;
        public string Year;

        
        public string errorMessage;
    }
    
    
}