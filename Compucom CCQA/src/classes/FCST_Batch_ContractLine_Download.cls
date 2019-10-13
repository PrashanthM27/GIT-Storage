//We are not using this Class	
	
	
global class FCST_Batch_ContractLine_Download implements Database.Batchable<sObject>,Database.Stateful {
	/*private String fromSelectedYear;
    private  string finalSuccessStr;	
    public String selectedYr{get;set;}
    
    public String stringHead{get;set;}
    
    public String dataRelatedUS{get;set;}
    public String dataRelatedCANADA{get;set;}
    public String dataRelatedOtherRevenue{get;set;}
    */
    
	global FCST_Batch_ContractLine_Download(String selectedYear) {
	/*	dataRelatedUS='';
		dataRelatedCANADA='';
		dataRelatedOtherRevenue='';
		fromSelectedYear=selectedYear;
		selectedYr=fromSelectedYear.right(2);
		
		//string fileHearder= ',BSLA ,Cost Center + Cost Center Description,Geo# + Geo Name,Revenue Type,Jan FY-'+selectedYr+' ,Feb FY-'+selectedYr+' ,Mar FY-'+selectedYr+' ,Apr FY-'+selectedYr+',May FY-'+selectedYr+' ,Jun FY-'+selectedYr+' ,Jul FY-'+selectedYr+' ,Aug FY-'+selectedYr+' ,Sep FY-'+selectedYr+' ,Oct FY-'+selectedYr+',Nov FY-'+selectedYr+' ,Dec FY-'+selectedYr+' \n';
        
		
		
		
		 stringHead=',,,,,Forecast,Forecast,Forecast,Forecast,Forecast,Forecast,Forecast,Forecast,Forecast,Forecast,Forecast,Forecast \n';
		stringHead+=',,,,,No Customer,No Customer,No Customer,No Customer,No Customer,No Customer,No Customer,No Customer,No Customer,No Customer,No Customer,No Customer\n';
		stringHead+=',,,,,Working Version,Working Version,Working Version,Working Version,Working Version,Working Version,Working Version,Working Version,Working Version,Working Version,Working Version,Working Version \n';
		
		string fileHearder= ', ,,,, FY'+selectedYr+' , FY'+selectedYr+' , FY'+selectedYr+' , FY'+selectedYr+', FY'+selectedYr+' , FY'+selectedYr+' , FY'+selectedYr+' , FY'+selectedYr+' , FY'+selectedYr+' , FY'+selectedYr+', FY'+selectedYr+' , FY'+selectedYr+' \n';
		fileHearder+=', ,,,,Jan  ,Feb ,Mar  ,Apr,May,Jun ,Jul ,Aug  ,Sep,Oct ,Nov ,Dec \n';
		stringHead+=fileHearder;
         
         
        
		*/
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext bc) {
	/*	String openAdminVersion;
		set<string> setValidVersions = new set<string>{'In Progress','Open (Admin)'};
		List<Planning_Version__c> pvlist=[select Id,Name,Planning_Version_Fiscal_Year__c from Planning_Version__c where Version_Status__c IN: setValidVersions and Is_this_a_Budget_Planning_Version__c = false and Is_this_a_Gap_Planning_Version__c = false order by Planning_Version_Fiscal_Year__c];
		if(pvlist!=null && pvlist.size()>0)
			openAdminVersion=pvlist[0].Name;
			
	    if(fromSelectedYear!=null && fromSelectedYear!=''){
	    	String likeStr='FY'+fromSelectedYear+'%';
	      return Database.getQueryLocator('Select Contract_LineItem__r.Hyperion_Revenue_Type__c,Contract_LineItem__r.BSLA_Number__c,Id,Fiscal_Period__c,FCST_Planning_Fiscal_Year__r.Month_Number__c,Forecast_with_Risk__c ,Contract_LineItem__r.Id,Contract_LineItem__r.Name,Contract_LineItem__r.Geo_Geo_Name__c,Contract_LineItem__r.Cost_Center__c,Contract_LineItem__r.Cost_Center_Description__c,Contract_LineItem__r.Fcst_Revenue_Type__c,Contract_LineItem__r.BSLA__c    from FCST_Initial_Forecast__c where FCST_Fiscal_Year_List__r.Name=:fromSelectedYear and FCST_Planning_Fiscal_Year__r.Name  LIKE :likeStr and Planning_Version__r.Name=:openAdminVersion order by FCST_Contract__c ');
	    }
	    else{
	      return null;
	    } */
	    return Database.getQueryLocator('Select Contract_LineItem__r.Hyperion_Revenue_Type__c,Contract_LineItem__r.BSLA_Number__c,Id,Fiscal_Period__c,FCST_Planning_Fiscal_Year__r.Month_Number__c,Forecast_with_Risk__c ,Contract_LineItem__r.Id,Contract_LineItem__r.Name,Contract_LineItem__r.Geo_Geo_Name__c,Contract_LineItem__r.Cost_Center__c,Contract_LineItem__r.Cost_Center_Description__c,Contract_LineItem__r.Fcst_Revenue_Type__c,Contract_LineItem__r.BSLA__c    from FCST_Initial_Forecast__c LIMIT 1');
	    
    }
    
     global void execute(Database.BatchableContext bc, List<FCST_Initial_Forecast__c> contractIntialForecastList){
     	
     /*	try{
     		
     		Map<Id,List<FCST_Initial_Forecast__c>> mapIdVsContractIntialList =new Map<Id,List<FCST_Initial_Forecast__c>>();
			
			if(contractIntialForecastList!=null && contractIntialForecastList.size()>0){
	    		for(FCST_Initial_Forecast__c conIntialForecastObj:contractIntialForecastList){
	    			if(mapIdVsContractIntialList.containsKey(conIntialForecastObj.Contract_LineItem__r.Id)){
	    				List<FCST_Initial_Forecast__c> existingModel=mapIdVsContractIntialList.get(conIntialForecastObj.Contract_LineItem__r.Id);
	    				existingModel.add(conIntialForecastObj);
	    				mapIdVsContractIntialList.put(conIntialForecastObj.Contract_LineItem__r.Id,existingModel);
	    			}
	    			else{
	    				List<FCST_Initial_Forecast__c> newModelList = new List<FCST_Initial_Forecast__c>();
	    				newModelList.add(conIntialForecastObj);
	    				mapIdVsContractIntialList.put(conIntialForecastObj.Contract_LineItem__r.Id,newModelList);
	    			}
	    		}
	    	}
	    	
	    	  for(Id contractLineId:mapIdVsContractIntialList.keyset())	{
			  	if(mapIdVsContractIntialList.containsKey(contractLineId)){
					List<double> amountList = new List<double>();
					double m1=0,m2=0,m3=0,m4=0,m5=0,m6=0,m7=0,m8=0,m9=0,m10=0,m11=0,m12=0,Mtotal=0;
					FCST_Initial_Forecast__c fcstObj;
					for(FCST_Initial_Forecast__c initialObj:mapIdVsContractIntialList.get(contractLineId)){
						fcstObj=initialObj;
						if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==1){
							m1+=initialObj.Forecast_with_Risk__c;
						}
						if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==2){
							m2+=initialObj.Forecast_with_Risk__c;
						}
						if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==3){
							m3+=initialObj.Forecast_with_Risk__c;
						}
						if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==4){
							m4+=initialObj.Forecast_with_Risk__c;
						}
						if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==5){
							m5+=initialObj.Forecast_with_Risk__c;
						}
						if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==6){
							m6+=initialObj.Forecast_with_Risk__c;
						}
						if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==7){
							m7+=initialObj.Forecast_with_Risk__c;
						}
						if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==8){
							m8+=initialObj.Forecast_with_Risk__c;
						}
						
						if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==9){
							m9+=initialObj.Forecast_with_Risk__c;
						}
						if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==10){
							m10+=initialObj.Forecast_with_Risk__c;
						}
						
						if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==11){
							m11+=initialObj.Forecast_with_Risk__c;
						}
						if(initialObj.FCST_Planning_Fiscal_Year__r.Month_Number__c==12){
							m12+=initialObj.Forecast_with_Risk__c;
						}
						
					}
					m1=math.round(m1);
					m2=math.round(m2);
					m3=math.round(m3);
					m4=math.round(m4);
					m5=math.round(m5);
					m6=math.round(m6);
					m7=math.round(m7);
					m8=math.round(m8);
					m9=math.round(m9);
					m10=math.round(m10);
					m11=math.round(m11);
					m12=math.round(m12);
					
					if(m1==null)
						m1=0;
					if(m2==null)
						m2=0;
				    if(m3==null)
						m3=0;
					if(m4==null)
						m4=0;
				    if(m5==null)
						m5=0;
					if(m6==null)
						m6=0;
				    if(m7==null)
						m7=0;
					if(m8==null)
						m8=0;
					if(m9==null)
						m9=0;
					if(m10==null)
						m10=0;
				    if(m11==null)
						m11=0;
					if(m12==null)
						m12=0;
						
					if(fcstObj.Contract_LineItem__r.Cost_Center__c==null)	
						fcstObj.Contract_LineItem__r.Cost_Center__c='';
						
				    if(fcstObj.Contract_LineItem__r.Cost_Center_Description__c==null)	
						fcstObj.Contract_LineItem__r.Cost_Center_Description__c='';
						
					if(fcstObj.Contract_LineItem__r.Fcst_Revenue_Type__c==null)	
						fcstObj.Contract_LineItem__r.Fcst_Revenue_Type__c='';
						
					if(fcstObj.Contract_LineItem__r.BSLA__c==null)	
						fcstObj.Contract_LineItem__r.BSLA__c='';	
					
					String bsla='';
					 bsla=fcstObj.Contract_LineItem__r.BSLA_Number__c;
					bsla=bsla.replaceAll(',', '').trim();
					
					String costcenter='';
					 costcenter=fcstObj.Contract_LineItem__r.Cost_Center__c;
					costcenter=costcenter.replaceAll(',', '').trim();
					
					String costcenterDescription='';
					 costcenterDescription=fcstObj.Contract_LineItem__r.Cost_Center_Description__c;
					costcenterDescription=costcenterDescription.replaceAll(',', '').trim();
					
					String geoName=fcstObj.Contract_LineItem__r.Geo_Geo_Name__c;
					if(geoName!=null)
						geoName=geoName.replaceAll(',', '').trim();
					else{
						geoName='';
					}
					
					String revenueType='';
					 revenueType=fcstObj.Contract_LineItem__r.Hyperion_Revenue_Type__c;
					revenueType=revenueType.replaceAll(',', '').trim();
					
					if(revenueType!='Gross Sales-Enterprise Hardware' && revenueType!='Gross Sales-Commodity Hardware'  && revenueType!='ITO Annuity Revenue' && revenueType!='ITO Project Revenue'){
						dataRelatedOtherRevenue+='USD,'+bsla+' CompuCom Systems Inc,'+costcenter+' '+costcenterDescription+','+geoName+','+revenueType+' ,'+m1+','+m2+','+m3+','+m4+','+m5+','+m6+','+m7+','+m8+','+m9+','+m10+','+m11+','+m12+',\n';
	
					}
					else if(bsla=='203563'){
						dataRelatedCANADA+='USD,'+bsla+' CompuCom Systems Inc,'+costcenter+' '+costcenterDescription+','+geoName+','+revenueType+' ,'+m1+','+m2+','+m3+','+m4+','+m5+','+m6+','+m7+','+m8+','+m9+','+m10+','+m11+','+m12+',\n';
	
					}
					else if(bsla=='10C363'){
						dataRelatedUS+='USD,'+bsla+' CompuCom Systems Inc,'+costcenter+' '+costcenterDescription+','+geoName+','+revenueType+' ,'+m1+','+m2+','+m3+','+m4+','+m5+','+m6+','+m7+','+m8+','+m9+','+m10+','+m11+','+m12+',\n';
	
					}
					
			    }
			  
			 }
			 
     		
		    }
	       catch(Exception e) {
	            System.debug('Exception Message '+e);
	            System.debug('Exception Line Number: '+e.getLineNumber());
	        }*/
     }
     
     global void finish(Database.BatchableContext bc){
     	/*
        String loginUserEmail=UserInfo.getUserEmail();
        System.debug('Exception dataRelatedUS '+dataRelatedUS);
        System.debug('Exception dataRelatedCANADA '+dataRelatedCANADA);
        System.debug('Exception dataRelatedOtherRevenue '+dataRelatedOtherRevenue);
        
        Messaging.EmailFileAttachment csvAttachment1 = new Messaging.EmailFileAttachment();
        Blob csvBlob1 = blob.valueOf(stringHead+dataRelatedUS);
	    String csvSuccessName1 = 'Hyoreport_US_'+fromSelectedYear+'.csv';
	    csvAttachment1.setFileName(csvSuccessName1);
	    csvAttachment1.setBody(csvBlob1);
	    
	    Messaging.EmailFileAttachment csvAttachment2 = new Messaging.EmailFileAttachment();
        Blob csvBlob2 = blob.valueOf(stringHead+dataRelatedCANADA);
	    String csvSuccessName2 = 'Hyoreport_Canada_'+fromSelectedYear+'.csv';
	    csvAttachment2.setFileName(csvSuccessName2);
	    csvAttachment2.setBody(csvBlob2);
	    
	    Messaging.EmailFileAttachment csvAttachment3 = new Messaging.EmailFileAttachment();
        Blob csvBlob3 = blob.valueOf(stringHead+dataRelatedOtherRevenue);
	    String csvSuccessName3 = 'Hyoreport_Other_Revenue_'+fromSelectedYear+'.csv';
	    csvAttachment3.setFileName(csvSuccessName3);
	    csvAttachment3.setBody(csvBlob3);
	    
	    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
	    String[] toAddresses = new String[]{loginUserEmail};
	    String subject = 'Hyperion upload Data for year '+fromSelectedYear ;
	    email.setSubject(subject);
	    email.setToAddresses(toAddresses);
	    email.setPlainTextBody('All forecast data for cost center and geo');
	    
	    List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
	      
	   // email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttachment1,csvAttachment2,csvAttachment3});
	   if(dataRelatedUS!=null && dataRelatedUS!='')
	    	fileAttachments.add(csvAttachment1);
	     
	    if(dataRelatedCANADA!=null && dataRelatedCANADA!='')
	    fileAttachments.add(csvAttachment2);
	    
	    if(dataRelatedOtherRevenue!=null && dataRelatedOtherRevenue!='')
	    fileAttachments.add(csvAttachment3);
	    
	     email.setFileAttachments(fileAttachments);
	    
	    Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email}); */ 
     }  
}