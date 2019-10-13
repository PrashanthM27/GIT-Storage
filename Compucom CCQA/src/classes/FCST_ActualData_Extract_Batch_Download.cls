global class FCST_ActualData_Extract_Batch_Download implements Database.Batchable<sobject>,Database.stateful{
    
  	public string s_FilterPlanningYear{get;set;}
    public String selectedYr{get;set;}
    private String fromSelectedYear;
    public  string finalSuccessStr; 
    
    public String nextYear{get;set;}
    public String openAdminVersion{get;set;}
    
    public string cpmRegionLabelName;
    public string currentFullYear{get;set;}
    public string nextFullYear{get;set;}
    
    public date todayDate {get;set;}
    public String formattedDate {get;set;}
    
     public FCST_ActualData_Extract_Batch_Download(String selectedYear,String planningVersionval){
        
        
         fromSelectedYear=selectedYear;
     
     currentFullYear=fromSelectedYear;
     nextFullYear=String.ValueOf(Integer.ValueOf(currentFullYear)+1);
    
     selectedYr=fromSelectedYear.right(2);
       String nextYear=String.ValueOf(Integer.ValueOf(selectedYr)+1);
     openAdminVersion=planningVersionval;
        Mapping_Setting__c mapCustomObj=Mapping_Setting__c.getValues('FCST Mapping Data');
        cpmRegionLabelName = mapCustomObj.Fcst_CPM__c;
               
        todayDate=date.today();
       
        String accQuery='select Id from Account where   '+cpmRegionLabelName+'!=null LIMIT 500';
         List<Account> accListVal=database.query(accQuery);
        System.debug('accListVal'+accListVal);    
         formattedDate =todayDate.month()+'/'+todayDate.day()+'/'+todayDate.year();
     
        
        set<string> setValidVersions = new set<string>{'Open (Admin)'};
        List<Planning_Version__c> pvlist=[select Id,Name,Planning_Version_Fiscal_Year__c from Planning_Version__c where Version_Status__c IN: setValidVersions and Is_this_a_Budget_Planning_Version__c = false and Is_this_a_Gap_Planning_Version__c = false order by Planning_Version_Fiscal_Year__c];
        if(pvlist!=null && pvlist.size()>0)
            openAdminVersion=pvlist[0].Name;
            
        string fileHearder= 'Program Name,Revenue Type,Cost Center,GEO,Contract #,Contract Line Item Description,Last Modified By,Last modified Date,Planning Version,Date of Data Extraction,Jan-'+selectedYr+' ,Feb-'+selectedYr+' ,Mar-'+selectedYr+' ,Apr-'+selectedYr+',May-'+selectedYr+' ,Jun-'+selectedYr+' ,Jul-'+selectedYr+' ,Aug-'+selectedYr+' ,Sep-'+selectedYr+' ,Oct-'+selectedYr+',Nov-'+selectedYr+' ,Dec-'+selectedYr+' \n';
    finalSuccessStr=fileHearder; 
    }
    
    global database.QueryLocator start(Database.BatchableContext bc){
        
            return database.getQueryLocator('SELECT Id, name from Contract_LineItem__c where Id In(Select Contract_LineItem__c from  Actual_Model__c)');
       
    }
    
    global void execute(Database.BatchableContext bc,List<Contract_LineItem__c> conListVal){
          try{
            System.debug('In Execute method');
           System.debug('conListVal'+conListVal);
            System.debug('openAdminVersion'+openAdminVersion);
              System.debug('cpmRegionLabelName'+cpmRegionLabelName);
              system.debug('currentFullYear'+currentFullYear);
            Integer currentYear=date.today().Year();
            
            String ActualQuery ='SELECT Account__r.Name, Contract_LineItem__r.Fcst_Revenue_Type__c, Contract_LineItem__r.Cost_Center__c, GEO_Description__c,FCST_GEO__c,FCST_Contract__r.Contract__c,Contract_LineItem__c, Revenue_Stream__c,    FCST_Contract__r.Contract_Description__c,FCST_Contract__r.Name,FCST_Contract__r.Opportunity__c, LastModifiedBy.Name,LastModifiedDate, Contract_LineItem__r.Name, Contract_LineItem__r.Line_Description__c,Fiscal_Period__r.Fiscal_Year__c,Fiscal_Period__r.Month_Number__c, FCST_Planning_Version__r.Name,Actual_Amount__c from Actual_Model__c Where ';
             ActualQuery += ' FCST_Planning_Version__r.Name =: openAdminVersion and Contract_LineItem__c IN:conListVal  and Account__r.'+cpmRegionLabelName+' !=null  and Fiscal_Period__r.Fiscal_Year__c =:currentFullYear';
             ActualQuery += ' order by Account__r.Name,Contract_LineItem__r.Fcst_Revenue_Type__c';
            
             List<Actual_Model__c> ActualModelList = database.query(ActualQuery); 
            System.debug('ActualModelList'+ActualModelList);
            Map<Id,List<Actual_Model__c>> mapContractLineItemIdVsActualModelList = new Map<Id,List<Actual_Model__c>>();
            
            for(Actual_Model__c accModel : ActualModelList){
                    if(mapContractLineItemIdVsActualModelList.containsKey(accModel.Contract_LineItem__c)){
                        List<Actual_Model__c> existingModel=mapContractLineItemIdVsActualModelList.get(accModel.Contract_LineItem__c);
                        existingModel.add(accModel);
                        mapContractLineItemIdVsActualModelList.put(accModel.Contract_LineItem__c,existingModel);
                    }
                    else{
                        List<Actual_Model__c> newModelList = new List<Actual_Model__c>();
                        newModelList.add(accModel);
                        mapContractLineItemIdVsActualModelList.put(accModel.Contract_LineItem__c,newModelList);
                    }
            }
         
          //  datetime = createdDate;
            System.debug('In bodySmapContractLineItemIdVsActualModelListtr>>'+mapContractLineItemIdVsActualModelList);
              for(Id lineIdobj:mapContractLineItemIdVsActualModelList.keySet()){
             	 System.debug('In lineIdobj>>'+lineIdobj);
                  List<double> ActualAmountList = new List<double>();
                    double Actual1=0,Actual2=0,Actual3=0,Actual4=0,Actual5=0,Actual6=0,Actual7=0,Actual8=0,Actual9=0,Actual10=0,Actual11=0,Actual12=0;
                    String contractLineItemName='',AccountName='',RevenueType='',CostCentre='',Geo='',Contractnum='',ContractLineDesc='',LastModifiedBy='',planningversion='',dataextdate='',lastdate='';
                  String bodyStr='';
               datetime modDate;
               Integer i=0;
                for(Actual_Model__c accModel:mapContractLineItemIdVsActualModelList.get(lineIdobj)){
                     i++;
                    System.debug('i'+i);
                     if(i==1){
                       modDate=accModel.LastModifiedDate;
                       LastModifiedBy=accModel.LastModifiedBy.Name; 
                                 }
                    if(accModel.LastModifiedDate!=null && (modDate<accModel.LastModifiedDate)){
                        modDate=accModel.LastModifiedDate;
                        LastModifiedBy=accModel.LastModifiedBy.Name;
                    }
                    if(modDate!=null){
                       lastdate = modDate.month()+'/'+modDate.day()+'/'+modDate.year();
                    }
                    if(accModel.Contract_LineItem__r.Name!=null){
                        contractLineItemName = accModel.Contract_LineItem__r.Name;
                    	contractLineItemName = contractLineItemName.replaceAll(',', '').trim();
                    }
                    if(accModel.Account__r.Name!=null){
               			AccountName = accModel.Account__r.Name;
                        AccountName = AccountName.replaceAll(',', '').trim();
                    }
                    if(accModel.Contract_LineItem__r.Fcst_Revenue_Type__c!=null){
                        RevenueType= accModel.Contract_LineItem__r.Fcst_Revenue_Type__c;
                        RevenueType = RevenueType.replaceAll(',', '').trim();
                    }
                    if(accModel.Contract_LineItem__r.Cost_Center__c!=null){
                        CostCentre= accModel.Contract_LineItem__r.Cost_Center__c;
                    	CostCentre = CostCentre.replaceAll(',', '').trim();
                    }
                    if(accModel.GEO_Description__c!=null &&  accModel.FCST_GEO__c!=null){
                        Geo= accModel.FCST_GEO__c+' '+accModel.GEO_Description__c;
                        Geo = Geo.replaceAll(',', '').trim();
                    }
                    if(accModel.FCST_Contract__r.Contract__c!=null){
                        Contractnum=accModel.FCST_Contract__r.Contract__c;
                        Contractnum = Contractnum.replaceAll(',', '').trim();
                    }
                    if(accModel.Contract_LineItem__r.Line_Description__c!=null){
                        ContractLineDesc=accModel.Contract_LineItem__r.Line_Description__c;
                        ContractLineDesc = ContractLineDesc.replaceAll(',', '').trim();
                    }
                   
                    if(accModel.FCST_Planning_Version__r.Name!=null){
                        planningversion=accModel.FCST_Planning_Version__r.Name;
                        planningversion = planningversion.replaceAll(',', '').trim();
                    }
                    if(formattedDate!=null){                          
                    	dataextdate = formattedDate;
                        dataextdate = dataextdate.replaceAll(',', '').trim();
                    }
                   
                        if(accModel.Fiscal_Period__r.Month_Number__c==1 && accModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            Actual1+= accModel.Actual_Amount__c;
                            System.debug('Amount1'+accModel.Actual_Amount__c);
                        }
                        if(accModel.Fiscal_Period__r.Month_Number__c==2 && accModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            Actual2+= accModel.Actual_Amount__c;
                        }
                        if(accModel.Fiscal_Period__r.Month_Number__c==3 && accModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            Actual3+= accModel.Actual_Amount__c;
                        }
                        if(accModel.Fiscal_Period__r.Month_Number__c==4 && accModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            Actual4+= accModel.Actual_Amount__c;
                        }
                        if(accModel.Fiscal_Period__r.Month_Number__c==5 && accModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            Actual5+= accModel.Actual_Amount__c;
                        }
                        if(accModel.Fiscal_Period__r.Month_Number__c==6 && accModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            Actual6+= accModel.Actual_Amount__c;
                        }
                        if(accModel.Fiscal_Period__r.Month_Number__c==7 && accModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            Actual7+= accModel.Actual_Amount__c;
                        }
                        if(accModel.Fiscal_Period__r.Month_Number__c==8 && accModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            Actual8+= accModel.Actual_Amount__c;
                        }
                        if(accModel.Fiscal_Period__r.Month_Number__c==9 && accModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            Actual9+= accModel.Actual_Amount__c;
                        }
                        if(accModel.Fiscal_Period__r.Month_Number__c==10 && accModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            Actual10+= accModel.Actual_Amount__c;
                        }
                        if(accModel.Fiscal_Period__r.Month_Number__c==11 && accModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            Actual11+= accModel.Actual_Amount__c;
                        }
                        if(accModel.Fiscal_Period__r.Month_Number__c==12 && accModel.Fiscal_Period__r.Fiscal_Year__c==currentFullYear){
                            Actual12+= accModel.Actual_Amount__c;
                        }
                    
                    
                }
                  
                  System.debug('In check>>');
                        ActualAmountList.add(Actual1);
                        ActualAmountList.add(Actual2);
                        ActualAmountList.add(Actual3);
                        ActualAmountList.add(Actual4);
                        ActualAmountList.add(Actual5);
                        ActualAmountList.add(Actual6);
                        ActualAmountList.add(Actual7);
                        ActualAmountList.add(Actual8);
                        ActualAmountList.add(Actual9);
                        ActualAmountList.add(Actual10);
                        ActualAmountList.add(Actual11);
                        ActualAmountList.add(Actual12);
                        System.debug('ActualAmountList'+ActualAmountList);
                  
                          bodyStr+=AccountName+','+RevenueType+','+CostCentre+','+Geo+','+Contractnum+','+ContractLineDesc+','+LastModifiedBy+','+lastdate+','+planningversion+','+dataextdate+',';
                          if(ActualAmountList!=null&&ActualAmountList.size()>0){
                              for(Double obj:ActualAmountList){
                                  bodyStr+=math.round(obj)+',';
                              }
                          }
                   	     bodyStr+='\n';
                  System.debug('In bodyStr>>'+bodyStr);
               finalSuccessStr+=bodyStr;
              System.debug('In finalSuccessStr>>'+finalSuccessStr);
           }
              
              System.debug('final value finalSuccessStr>>'+finalSuccessStr);
          } 
        
        	catch(Exception e) {
          
                System.debug('The following exception has occurred: ' + e.getMessage());
                System.debug('Line number: ' + e.getLineNumber()); 
            }
        
        
    }
    
    global void finish(Database.BatchableContext bc){
       System.debug('finish finalSuccessStr>>'+finalSuccessStr);
         String loginUserEmail=UserInfo.getUserEmail();
        Messaging.EmailFileAttachment csvAttachment = new Messaging.EmailFileAttachment();
        Blob csvBlob = blob.valueOf(finalSuccessStr);
      String csvSuccessName = 'ActualData_Extract_'+fromSelectedYear+'.csv';
      csvAttachment.setFileName(csvSuccessName);
      csvAttachment.setBody(csvBlob);
      
      Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
      String[] toAddresses = new String[]{loginUserEmail};
      String subject = 'Actual Data Extract for year '+fromSelectedYear ;
      email.setSubject(subject);
      email.setToAddresses(toAddresses);
      email.setPlainTextBody('All forecast data and Contract Data');
      email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttachment});
      Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
     }    
    
}