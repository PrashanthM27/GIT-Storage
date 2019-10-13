public class ActualModelCSVImportController{
    
    public Blob csvFileBody{get;set;}
    public string fileName{get;set;}    
    public String headerString; 
    public String bodyString;
    
    public datetime ErrorlogInsertedTime;
    public Planning_Version__c currentVersion;
    public Integer TotalRecord{get;set;}
    public Integer SuccessRecord{get;set;}
    public Integer FailRecord{get;set;}
    public boolean showmore{get;set;}
    public string prjClin; 
    public ActualModelCSVImportController(){
        showmore = false;
        TotalRecord = SuccessRecord = FailRecord= 0;
        
        
        
        List<Planning_Version__c> lstMPlanningversion = [select Id,Name from Planning_Version__c where Data_Entry_Start_Date__c <> null
        and Is_this_a_Budget_Planning_Version__c = false 
        and Is_this_a_Gap_Planning_Version__c = false
        and (Version_Status__c = 'Open (Admin)')
        ];
      //  System.debug('lstMPlanningversion:'+lstMPlanningversion);
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
            }catch(Exception e){}
        }
        if(str <> null && str <> ''){
            str = str.replaceAll(' ,',',');
            str = str.replaceAll(', ',',');
        }
        return str;
    }
    
     public static string getFieldStrValue(string column){  
        //System.debug('...column>>>>'+column);    
        if(column <> null && column <> '')
        {
            column = column.replaceAll(':quotes:', '').replaceAll(':comma:', ',');
        }//System.debug('.after ..column>>>>'+column); 
        return column;  
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
        if(fv.contains('$') || fv.contains('(') || fv.contains(')')  || fv.contains(',')){
            fv = fv.replace('$','');
            fv = fv.replace('(','');
            fv = fv.replace(')','');
            fv = fv.replace(',','');
            fv = fv.trim();
        }
        
        Boolean ReturnValue=True;
        try{
            Decimal.valueOf(fv);
            ReturnValue = TRUE; 
        } catch (Exception e) {
            ReturnValue = FALSE;
        }
        
        if(fv <> null && ReturnValue==TRUE){return decimal.valueOf(fv);}
        return 0;
    }
    public void uploadCSV(){
        showmore = false;
        
        List<WrapperModel> lstWrapperModel;
        List<Actual_Model__c> lstActualModels;
        lstActualModels =  new List<Actual_Model__c>();
        lstWrapperModel = new List<WrapperModel>();
        set<string> setAccountNames = new set<string>();
        set<string> setProductNames = new set<string>();
        set<string> setLineDescription = new set<string>();
        try{
            
            if(csvFileBody == null){
                ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'Please Select File to upload');
                ApexPages.addMessage(errorMessage );
                return;
            }
            string csvAsString = blobToString(csvFileBody,'ISO-8859-1');
            csvAsString = csvAsString.replace('\n', '');
            csvAsString = csvAsString.trim();
            String[] csvFileLines1 = csvAsString.split('####'); 
           string rowstr1 = getAmountFromString(csvFileLines1[0]);
            if(rowstr1!=null){
	            string[] csvRecordData = rowstr1.split(',');
	            headerString =getFieldValue(csvRecordData[0]).trim()+',';
	            headerString+=getFieldValue(csvRecordData[1]).trim()+',';
	            headerString+=getFieldValue(csvRecordData[2]).trim()+',';
	            headerString+=getFieldValue(csvRecordData[3]).trim()+',';
	            headerString+=getFieldValue(csvRecordData[4]).trim()+',';
	            headerString+=getFieldValue(csvRecordData[5]).trim()+',';
	            headerString+=getFieldValue(csvRecordData[6]).trim()+',';
	            headerString+=getFieldValue(csvRecordData[7]).trim()+',';
	            headerString+=getFieldValue(csvRecordData[8]).trim()+',';
	            headerString+=getFieldValue(csvRecordData[9]).trim()+',';
	            
	            headerString+=getFieldValue(csvRecordData[10]).trim()+',';
	            headerString+=getFieldValue(csvRecordData[11]).trim()+',';
	            headerString+=getFieldValue(csvRecordData[12]).trim()+',';
	            headerString+=getFieldValue(csvRecordData[13]).trim()+',';
	            headerString+='Error Message'+'\n';
	            
            }
            map<string,FCST_Contract__c> mapContract = new map<string,FCST_Contract__c>();
            map<string,Fiscal_Year_Model__c> mapPeriods = new map<string,Fiscal_Year_Model__c>();
        	map<string,WrapperModel> mapexcelRecords = new map<string,WrapperModel>();
            for(Integer i=1;i<csvFileLines1.size();i++){
                WrapperModel m = new WrapperModel() ;
                
                string rowstr = getAmountFromString(csvFileLines1[i]);
                string[] csvRecordData = rowstr.split(',');
                    m.Revenue_Stream = getFieldValue(csvRecordData[0]).trim();
                    string amount = (csvRecordData[1]).trim();  
                             
                    m.Current_Month_Expected_Revenue = getStringToNumber(amount);   
                    m.Contract_Id = getFieldValue(csvRecordData[2]).trim();
                    m.revenueType = getFieldValue(csvRecordData[3]).trim();
                    
                    m.CDR_Description =   getFieldValue(csvRecordData[4]).trim();
                    m.CDR =   getFieldValue(csvRecordData[5]).trim();
                    m.CC_Description   =   getFieldValue(csvRecordData[6]).trim();
                    m.CC    =   getFieldValue(csvRecordData[7]).trim();               
                    m.Geo_Description = getFieldValue(csvRecordData[8]).trim();
                    m.Geo = getFieldValue(csvRecordData[9]).trim();
                    m.BSLA  =  getFieldValue( csvRecordData[10]).trim();
                    Integer period = (getFieldValue(csvRecordData[13]) <> null && getFieldValue(csvRecordData[13]) <> '')?Integer.valueOf(getFieldValue(csvRecordData[13]).trim()):0;
                    string periodstr = (period <= 9)?'P0'+period:'P'+period;
                    m.Period  =   'FY'+getFieldValue(csvRecordData[12]).trim()+periodstr;
                    m.CurrencyISO = getFieldValue(csvRecordData[11]).trim();
                    mapPeriods.put(m.Period,null);
                    mapContract.put(m.Contract_Id,null);
                    
                    m.year=getFieldValue(csvRecordData[12]).trim();
                    m.periodNumber=getFieldValue(csvRecordData[13]).trim();
                    setLineDescription.add(m.Revenue_Stream);
             	 lstWrapperModel.add(m);
            }  
            
            
            for(Fiscal_Year_Model__c y: [select Id,Name,Fiscal_Planning_Year__c,Copy_Month__c from  Fiscal_Year_Model__c where 
            Name IN: mapPeriods.keyset()]){
                mapPeriods.put(y.Name,y);
            }
            for(FCST_Contract__c c : [Select id,(select BSLA_Number__c,BSLA__c,Cost_Center__c,Id,Name,Line_Description__c,Fcst_Revenue_Type__c from Contract_LineItems__r where Line_Description__c IN: setLineDescription),Fcst_Account__c,Contract__c from FCST_Contract__c where Contract__c=:mapContract.keyset()]){
               System.debug('....c.Contract__c...'+c.Contract_LineItems__r);
                mapContract.put(c.Contract__c,c);
            }
            
            map<string,Actual_Model__c> mapExisitingActuals = new map<string,Actual_Model__c>();
            for(Actual_Model__c m: [select Id,Name,Fiscal_Year__c,Account__c,Actual_Type__c,FCST_Contract__c,Contract_LineItem__c,Revenue_Type__c,
            Revenue_Stream__c, CDR_Description__c,CDR__c,CC__c,CC_Description__c,FCST_GEO__c,GEO_Description__c,BSLA__c,Fiscal_Period__r.Name,
            Actual_Amount__c,FCST_Planning_Version__c,Fiscal_Period__c,Opportunity__c,FCST_Contract__r.Contract__c from Actual_Model__c where Fiscal_Period__r.Name IN: mapPeriods.keyset() and FCST_Planning_Version__c =: currentVersion.Id and FCST_Contract__c IN: mapContract.values()]){
                mapExisitingActuals.put(m.Fiscal_Period__r.Name+'#'+m.FCST_Planning_Version__c+'#'+m.FCST_Contract__r.Contract__c+'#'+m.Revenue_Stream__c+'#'+m.CC__c+'#'+m.BSLA__c+'#'+m.Revenue_Type__c,m);
            }
            
            
            List<Actual_Model__c> lstModels = new List<Actual_Model__c>();
            List<Upload_File__c> lstErrorLog = new List<Upload_File__c>();
            bodyString='';
            for(WrapperModel m: lstWrapperModel){  
            	 
                 string errorMsg='Record do not have Required Contract Id';
                
                if(m.Contract_Id <> null && m.Contract_Id <> ''){
                    if(mapContract.containsKey(m.Contract_Id) && mapContract.get(m.Contract_Id) == null){
                        errorMsg = 'Contract number do not have related Contract record';
                    }
                    else if(mapContract.containsKey(m.Contract_Id) && mapContract.get(m.Contract_Id) <> null && mapContract.get(m.Contract_Id).Fcst_Account__c == null){
                        errorMsg = 'Contract do not have Account';
                    }
                    else if(m.Revenue_Stream==null || m.Revenue_Stream==''){
                        errorMsg='Revenue Stream is Mandatory';
                    }
                    else if(mapexcelRecords.containsKey(m.Period+'#'+currentVersion.Id+'#'+m.Contract_Id+'#'+m.Revenue_Stream+'#'+m.CC+'#'+m.BSLA+'#'+m.revenueType)){
                    	errorMsg='Duplicate records';
                    }
                    else{
                        errorMsg = null;
                        string key = m.Period+'#'+currentVersion.Id+'#'+m.Contract_Id+'#'+m.Revenue_Stream+'#'+m.CC+'#'+m.BSLA+'#'+m.revenueType;
                        Actual_Model__c model = new Actual_Model__c();
                        string period = m.period;
                        if(mapExisitingActuals.containsKey(Key)){
                            model = mapExisitingActuals.get(Key);                     
                        }else{
                            model.Account__c = mapContract.get(m.Contract_Id).Fcst_Account__c;
                        }
                        model.Revenue_Stream__c = m.Revenue_Stream;
                        model.CDR_Description__c = m.CDR_Description;
                        model.CDR__c = decimal.valueOf(m.CDR);
                        model.CC_Description__c = m.CC_Description;
                        model.CC__c = decimal.valueOf(m.CC);
                        model.FCST_GEO__c = m.Geo;
                        model.GEO_Description__c = m.Geo_Description;
                        model.BSLA__c = m.BSLA;
                        model.Revenue_Type__c = m.revenueType;
                        
                        List<Contract_LineItem__c> lstLines = mapContract.get(m.Contract_Id).Contract_LineItems__r;
                        if(lstLines <> null){
                            Contract_LineItem__c LineItem;
                            for(Contract_LineItem__c c: lstLines){
                            	System.debug('>>>>>>MODEL >> cccccc>>>'+c);
                            	System.debug('>>>>>>MODEL >>>>>'+m.CC+'#'+m.Revenue_Stream+'#'+m.BSLA+'#'+m.revenueType);
                            	System.debug('>>>>>>bodyString>>>>>'+c.Cost_Center__c+'#'+c.Line_Description__c+'#'+c.BSLA_Number__c+'#'+c.Fcst_Revenue_Type__c);
                                if((m.CC).equalsIgnoreCase(c.Cost_Center__c) && m.Revenue_Stream==c.Line_Description__c && m.BSLA==c.BSLA_Number__c && m.revenueType==c.Fcst_Revenue_Type__c){
                                    LineItem= c;                                    
                                }
                            }
                            if(LineItem <> null){
                                model.Revenue_Type__c = LineItem.Fcst_Revenue_Type__c; 
                                model.Contract_LineItem__c = LineItem.Id; 
                            }
                            else{
                            	errorMsg = 'Contract LineItem is not present';
                            }
                            
                        } 
                        
                        model.FCST_Contract__c = mapContract.get(m.Contract_Id).Id;
                    
                        model.Fiscal_Year__c = (period <> null && mapPeriods.containsKey(period) && mapPeriods.get(period) <> null)?mapPeriods.get(period).Fiscal_Planning_Year__c:model.Fiscal_Year__c;
                        model.FCST_Planning_Version__c = (currentVersion <> null)?currentVersion.Id:model.FCST_Planning_Version__c;
                        model.Fiscal_Period__c = (period <> null && mapPeriods.containsKey(period) && mapPeriods.get(period) <> null)?mapPeriods.get(period).Id:model.Fiscal_Period__c;
                        model.Actual_Amount__c = m.Current_Month_Expected_Revenue;
                        if(model.Fiscal_Year__c == null || model.Fiscal_Period__c == null){
                            errorMsg = 'record related to period '+ period + 'is not present in org.';
                        }
                        else if (model.Contract_LineItem__c==null){
                        	errorMsg = 'Contract LineItem is not present';
                        }else{   
                            lstModels.add(model);
                            mapexcelRecords.put(m.Period+'#'+currentVersion.Id+'#'+m.Contract_Id+'#'+m.Revenue_Stream+'#'+m.CC+'#'+m.BSLA,m);
               
                        }
                    }
                }
                if(errorMsg != null){
                    Upload_File__c error = new Upload_File__c();        
                    error.BSLA__c  =   m.BSLA;
                    error.CC__c    =   m.CC;
                    error.CC_Description__c   =   m.CC_Description;
                    error.CDR__c   =   m.CDR;
                    error.CDR_Description__c =   m.CDR_Description;
                    error.Contract_Id__c = m.Contract_Id;
                    error.Current_Month_Expected_Revenue__c = m.Current_Month_Expected_Revenue;
                    error.Geo_Description__c = m.Geo_Description;
                    error.Geo__c = m.Geo;
                    error.Revenue_Stream__c = m.Revenue_Stream;
                    error.Period__c = m.period;
                    error.ErrorMsg__c = errorMsg;
                    lstErrorLog.add(error);
                    bodyString+=m.Revenue_Stream+','+m.Current_Month_Expected_Revenue+','+m.Contract_Id+','+m.revenueType+','+m.CDR_Description+','+m.CDR+','+m.CC_Description+','+m.CC+','+m.Geo_Description+','+m.Geo+','+m.BSLA+','+m.CurrencyISO+','+m.year+','+m.periodNumber+','+errorMsg+'\n';
                }
            
            
            
                }
                
            System.debug('>>>>>>bodyString>>>>>'+bodyString);
            Boolean bodyStringVal=false;
            if(bodyString!=null || bodyString!='')
             bodyStringVal=true;
             
            bodyString=headerString+bodyString;
            TotalRecord = lstWrapperModel.size();            
            database.upsert(lstModels,false);
            
           // upsert lstModels;
            SuccessRecord = lstModels.size();
            ErrorlogInsertedTime = system.now();            
            insert lstErrorLog;
            FailRecord = lstErrorLog.size();
            //system.debug('lstErrorLog:'+lstErrorLog);
            
            if(lstWrapperModel.size()>999)showmore = true;
            
            if(bodyStringVal==true){
	            String loginUserEmail=UserInfo.getUserEmail();
				
				Messaging.EmailFileAttachment csvAttachment = new Messaging.EmailFileAttachment();
				Blob csvBlob = blob.valueOf(bodyString);
				String csvSuccessName = 'Actual Error Log.csv';
				csvAttachment.setFileName(csvSuccessName);
				csvAttachment.setBody(csvBlob);
				
				Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
				String[] toAddresses = new String[]{loginUserEmail};
				String subject = 'Actual Error Log Details' ;
				email.setSubject(subject);
				email.setToAddresses(toAddresses);
				email.setPlainTextBody('All Failed Actual Data');
				email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttachment});
				Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
            }
       }
        catch (Exception e)
        {
            csvFileBody = null;
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,e.getLinenumber()+', '+e.getMessage()+'');
            ApexPages.addMessage(errorMessage );
        }  
    }
    public list<Upload_File__c> getErrorFile(){
        if(ErrorlogInsertedTime == null)return null;
        return [select Id,BSLA__c, CC__c,ErrorMsg__c , CC_Description__c, CDR__c, CDR_Description__c, Contract_Id__c, 
        Current_Month_Expected_Revenue__c, Geo__c, Geo_Description__c, Revenue_Stream__c,Period__c from Upload_File__c 
        where Createddate >: ErrorlogInsertedTime and CreatedById =: userinfo.getUserId() limit 1000];
    }


    public class WrapperModel{
        public string BSLA;
        public string CC;
        public string CC_Description; 
        public string CDR;
        public string CDR_Description;
        public string Contract_Id;
        public decimal Current_Month_Expected_Revenue;
        public string Geo;
        public string Geo_Description;
        public string Revenue_Stream;
        public string CurrencyISO;      
        public string Period;
        
        public string periodNumber;
        public String year;
        public string revenueType;
    }
}