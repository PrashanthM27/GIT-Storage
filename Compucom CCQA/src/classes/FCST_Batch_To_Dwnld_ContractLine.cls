//We are not using this Class	
	
global class FCST_Batch_To_Dwnld_ContractLine implements Database.Batchable<sObject>,Database.Stateful {
	public string fromSelectedYear;
	global FCST_Batch_To_Dwnld_ContractLine(String selectedYear) {
	/*	fromSelectedYear=selectedYear;
		selectedYr=fromSelectedYear.right(2);
		
		//string fileHearder= ',BSLA ,Cost Center + Cost Center Description,Geo# + Geo Name,Revenue Type,Jan FY-'+selectedYr+' ,Feb FY-'+selectedYr+' ,Mar FY-'+selectedYr+' ,Apr FY-'+selectedYr+',May FY-'+selectedYr+' ,Jun FY-'+selectedYr+' ,Jul FY-'+selectedYr+' ,Aug FY-'+selectedYr+' ,Sep FY-'+selectedYr+' ,Oct FY-'+selectedYr+',Nov FY-'+selectedYr+' ,Dec FY-'+selectedYr+' \n';
        
		
		
		
		String stringHead=',,,,,Budget,Budget,Budget,Budget,Budget,Budget,Budget,Budget,Budget,Budget,Budget,Budget \n';
		stringHead+=',,,,,No Customer,No Customer,No Customer,No Customer,No Customer,No Customer,No Customer,No Customer,No Customer,No Customer,No Customer,No Customer\n';
		stringHead+=',,,,,Working Version,Working Version,Working Version,Working Version,Working Version,Working Version,Working Version,Working Version,Working Version,Working Version,Working Version,Working Version \n';
		
		string fileHearder= ',BSLA ,Cost Center + Cost Center Description,Geo# + Geo Name,Revenue Type,Jan FY-'+selectedYr+' ,Feb FY-'+selectedYr+' ,Mar FY-'+selectedYr+' ,Apr FY-'+selectedYr+',May FY-'+selectedYr+' ,Jun FY-'+selectedYr+' ,Jul FY-'+selectedYr+' ,Aug FY-'+selectedYr+' ,Sep FY-'+selectedYr+' ,Oct FY-'+selectedYr+',Nov FY-'+selectedYr+' ,Dec FY-'+selectedYr+' \n';
		
		stringHead+=fileHearder;

		finalSuccessStr=stringHead;
		*/
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext bc) {
	    return Database.getQueryLocator('Select Id   from FCST_Contract__c limit 1 ');
	      
    }
    
     global void execute(Database.BatchableContext bc, List<Contract_LineItem__c> conLineItemList){
     	/*
     	try{
     		if(conLineItemList!=null && conLineItemList.size()>0){
				for(Contract_LineItem__c conObj:conLineItemList){
					double m1=0,m2=0,m3=0,m4=0,m5=0,m6=0,m7=0,m8=0,m9=0,m10=0,m11=0,m12=0,Mtotal=0;
					
					for(FCST_Initial_Forecast__c initialObj:conObj.FCST_Initial_Forecasts__r){
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
					
				
						
					if(conObj.Cost_Center__c==null)	
						conObj.Cost_Center__c='';
						
				    if(conObj.Cost_Center_Description__c==null)	
						conObj.Cost_Center_Description__c='';
						
					if(conObj.Fcst_Revenue_Type__c==null)	
						conObj.Fcst_Revenue_Type__c='';
					if(conObj.BSLA__c==null)	
						conObj.BSLA__c='';	
						
						
						
						
					finalSuccessStr+='Local,'+conObj.BSLA__c+' CompuCom Systems Inc,'+conObj.Cost_Center__c+' '+conObj.Cost_Center_Description__c+','+conObj.Geo_Geo_Name__c+','+conObj.Fcst_Revenue_Type__c+' Revenue,'+m1+','+m2+','+m3+','+m4+','+m5+','+m6+','+m7+','+m8+','+m9+','+m10+','+m11+','+m12+',\n';
			    }
		      }
		    }
	       catch(Exception e) {
	            System.debug('Exception Message '+e);
	            System.debug('Exception Line Number: '+e.getLineNumber());
	        }*/
     }
     
     global void finish(Database.BatchableContext bc){
     	
       /* String loginUserEmail=UserInfo.getUserEmail();
        
        Messaging.EmailFileAttachment csvAttachment = new Messaging.EmailFileAttachment();
        Blob csvBlob = blob.valueOf(finalSuccessStr);
	    String csvSuccessName = 'Hyoreport_'+fromSelectedYear+'.csv';
	    csvAttachment.setFileName(csvSuccessName);
	    csvAttachment.setBody(csvBlob);
	    
	    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
	    String[] toAddresses = new String[]{loginUserEmail};
	    String subject = 'Hyperian upload Data for year '+fromSelectedYear ;
	    email.setSubject(subject);
	    email.setToAddresses(toAddresses);
	    email.setPlainTextBody('All forecast data for castcenter and geo');
	    email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttachment});
	    Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});*/
     }    
}