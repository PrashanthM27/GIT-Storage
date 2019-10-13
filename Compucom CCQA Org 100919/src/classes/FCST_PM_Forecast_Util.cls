/****
  Developer Name/Author:  Pritam Gupta
  Created Date: 9-Sep-2019
  Work item number from JIRA:-CRN-173
  Description: we are creating PM forecast and deleting Product model using Opporunity trigger and util class is-FCST_PM_Forecast_Util.

****/

public with sharing class FCST_PM_Forecast_Util {
    
    public FCST_PM_Forecast_Util(){
        
      }
    
    public Static Integer getDateId(Date dd){
        
        if(dd <> null){
            string cPeriod = (dd.Month()<10)? '0'+dd.Month():dd.Month()+'';
            string cDay = (dd.Day()<10)? '0'+dd.Day():dd.Day()+'';
            return Integer.ValueOf(dd.Year()+''+cPeriod+''+cDay);
        }
        return null;
    }
    
    public Static string get15DigitId(String mId){
        if(mId <> null && mId.trim() <> ''){
            return mId.substring(0,15);
        }
        return '';
    }
    
    public static void createPMForecast(list<Opportunity> oppList){
        try{
       
	        List<FCST_Product_Model__c> productmodelList =[Select Id from FCST_Product_Model__c where Opportunity__c IN :oppList];
	        List<Planning_Version__c> lstMPlanningversion =new List<Planning_Version__c>();
	                
	        if(Schema.sObjectType.Planning_Version__c.fields.Id.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Name.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Previous_Version__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Version_Status__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Closed_Date__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Data_Entry_Start_Date__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Budget_Planning_Version__c.isAccessible() && Schema.sObjectType.Planning_Version__c.fields.Is_this_a_Gap_Planning_Version__c.isAccessible()  ){
	            lstMPlanningversion = [select Id,Name,Previous_Version__c,Version_Status__c,Data_Entry_Closed_Date__c,Data_Entry_Start_Date__c from Planning_Version__c where Data_Entry_Start_Date__c <> null
	                                                         and Is_this_a_Budget_Planning_Version__c = false 
	                                                         and Is_this_a_Gap_Planning_Version__c = false
	                                                         and (Version_Status__c = 'Open (Admin)')
	                                                        ];
	        
	         }
	         
	         set<string> setRevenueType= new set<string>();
	         if(Schema.sObjectType.Fcst_Rev_Rec_Revenue_Type__c.fields.Id.isAccessible() && Schema.sObjectType.Fcst_Rev_Rec_Revenue_Type__c.fields.Name.isAccessible() && Schema.sObjectType.Fcst_Rev_Rec_Revenue_Type__c.fields.Fcst_12_Month_Duration__c.isAccessible()){
	            for(Fcst_Rev_Rec_Revenue_Type__c p: [select Id,Name from Fcst_Rev_Rec_Revenue_Type__c where Fcst_12_Month_Duration__c = true]){
	                setRevenueType.add(p.Name);
	            }
	         }
	         
	          map<Integer,Fiscal_Year_Model__c> mapFiscalYear = new map<Integer,Fiscal_Year_Model__c>();
	         map<String,Integer> mapFiscalId = new map<String,Integer>();
	         
	         map<String,Fiscal_Year_Model__c> mapPeriodNameVsPeriodObj = new map<String,Fiscal_Year_Model__c>();
	         
	         if(Schema.sObjectType.Fiscal_Year_Model__c.fields.Id.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Name.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Fiscal_Year__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Start_Date__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.End_Date__c.isAccessible() && Schema.sObjectType.Fiscal_Year_Model__c.fields.Period_Number__c.isAccessible() ){
	            for(Fiscal_Year_Model__c fy : [select Id,Name,Fiscal_Year__c,Start_Date__c,End_Date__c,Period_Number__c from Fiscal_Year_Model__c where name <> null]){
	                if(fy.Name <> null && fy.Period_Number__c <> null && fy.Fiscal_Year__c <> null ){
	                    string cPeriod = (fy.Period_Number__c < 10)? '0'+fy.Period_Number__c:fy.Period_Number__c+'';
	                    mapFiscalYear.put(Integer.valueOf(fy.Fiscal_Year__c+''+cPeriod),fy);
	                    mapFiscalId.put(getDateId(fy.Start_Date__c)+'-'+getDateId(fy.End_Date__c),Integer.valueOf(fy.Fiscal_Year__c+''+cPeriod));
	                    
	                    mapPeriodNameVsPeriodObj.put(fy.Name,fy);
	                }
	            }
	        
	        }
	        
	           
	        
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
	         
	         String oppTrYR1AmountAPI,oppSVCFullTCVAmountAPI,oppSVCYR1AmountAPI,oppTermMonthAPI,oppStartDateAPI,oppEndDateAPI,oppQhashAPI,productRevenueTypeAPI;
	         Mapping_Setting__c mapCustomObj=Mapping_Setting__c.getValues('FCST Mapping Data');
	        
	        if(mapCustomObj.FCST_TR_YR1_Amount__c!=null)
	            oppTrYR1AmountAPI=mapCustomObj.FCST_TR_YR1_Amount__c;
	            
	        if(mapCustomObj.Opportunity_SVC_YR1__c!=null)
	            oppSVCYR1AmountAPI=mapCustomObj.Opportunity_SVC_YR1__c;
	        
	        if(mapCustomObj.Opportunity_TCV__c!=null)
	            oppSVCFullTCVAmountAPI=mapCustomObj.Opportunity_TCV__c;
	            
	        if(mapCustomObj.Term_In_Months__c!=null)
	            oppTermMonthAPI=mapCustomObj.Term_In_Months__c;
	        
	        if(mapCustomObj.Fcst_StartDate__c!=null)
	            oppStartDateAPI=mapCustomObj.Fcst_StartDate__c;
	         
	        if(mapCustomObj.Fcst_EndDate__c!=null)
	            oppEndDateAPI=mapCustomObj.Fcst_EndDate__c;
	        
	        if(mapCustomObj.Fcst_Q__c!=null)
	            oppQhashAPI=mapCustomObj.Fcst_Q__c;
	        
	        if(mapCustomObj.Fcst_Revenue_Type__c!=null)
	            productRevenueTypeAPI=mapCustomObj.Fcst_Revenue_Type__c;    
	        
	        
	        
	        
	        String OppQuery='Select Id,'+oppTrYR1AmountAPI+','+oppSVCFullTCVAmountAPI+','+oppSVCYR1AmountAPI+','+oppTermMonthAPI+','+oppStartDateAPI+','+oppEndDateAPI+','+oppQhashAPI+',(select Id,TotalPrice ,opportunityId,Product2Id,Product2.'+productRevenueTypeAPI+' from OpportunitylineItems) from Opportunity where Id In:oppList';
	        List<Opportunity> oppListwithLineItem=database.query(OppQuery);
	        
	        If(oppListwithLineItem!=null && oppListwithLineItem.size()>0){
	            for(Opportunity oppObj:oppListwithLineItem){
	                
	                Decimal oppTrYR1Amount=0,oppSVCFullTCVAmount=0,oppSVCYR1Amount=0,oppTermMonth=0,trAmount=0,firstYr1SrAmount=0,modelservice12Month=0,modelserviceMore12Month=0,SrAFYR1Amount=0;
	                String oppQhash='';
	                date  oppStartDate,oppEndDate;
	                
	                Integer monthCount=0;
	                
	                if((Decimal) oppObj.get(oppTrYR1AmountAPI)!=null) 
	                    oppTrYR1Amount=(Decimal) oppObj.get(oppTrYR1AmountAPI);
	                if((Decimal) oppObj.get(oppSVCFullTCVAmountAPI)!=null) 
	                    oppSVCFullTCVAmount=(Decimal) oppObj.get(oppSVCFullTCVAmountAPI);
	                if((Decimal) oppObj.get(oppSVCYR1AmountAPI)!=null) 
	                    oppSVCYR1Amount=(Decimal) oppObj.get(oppSVCYR1AmountAPI);
	                
	                if((Date) oppObj.get(oppStartDateAPI)!=null) 
	                    oppStartDate=(Date) oppObj.get(oppStartDateAPI);
	                if((Date) oppObj.get(oppEndDateAPI)!=null) 
	                    oppEndDate=(Date) oppObj.get(oppEndDateAPI);
	                
	                if((Decimal) oppObj.get(oppTermMonthAPI)!=null) 
	                    oppTermMonth=(Decimal) oppObj.get(oppTermMonthAPI);
	                
	                if((String) oppObj.get(oppQhashAPI)!=null) 
	                    oppQhash=(String) oppObj.get(oppQhashAPI);    
	        
	                 monthCount = oppStartDate.monthsBetween(oppEndDate);
	                 monthCount++;
	                
	                if(monthCount!=null && monthCount!=0)
	                trAmount=oppTrYR1Amount/monthCount;
	                
	                
	                firstYr1SrAmount=oppSVCYR1Amount-oppTrYR1Amount;
	                
	                SrAFYR1Amount=oppSVCFullTCVAmount-oppSVCYR1Amount;
	                
	                if(monthCount<13){
	                	modelservice12Month=firstYr1SrAmount/monthCount;
	                }
	                if(monthCount>12 && (monthCount-12)!=0){
	                	modelserviceMore12Month=SrAFYR1Amount/(monthCount-12);
	                	modelservice12Month=firstYr1SrAmount/12;
	                }
	                
	                
	                
	                List<FCST_Opportunity_Initial_Forecast__c> newPMForecastModelList = new List<FCST_Opportunity_Initial_Forecast__c>();
	                Map<String,FCST_Opportunity_Initial_Forecast__c> mapPeriodNameVsMOdel= new  Map<String,FCST_Opportunity_Initial_Forecast__c>();
	                Integer year=0,month=0;
	                
	                year=oppStartDate.year();
	                month=oppStartDate.month();
	                
	                decimal serviceAmount=0;
	                serviceAmount=modelservice12Month;
	                Integer modelCount=1;
	                if(lstMPlanningversion!=null && lstMPlanningversion.size()>0){
		                for(Integer i=0;i<monthCount;i++){
		                	if(modelCount==13)
		                		serviceAmount= modelserviceMore12Month;
		                		
		                	String monthStr='';
		                	if(month==13){
		                		year++;
		                		month=1;
		                	}
		                	if(month<10){
		                		monthStr='0'+month;
		                	}
		                	else{
		                		monthStr=String.valueOf(month);
		                	}
		                	
		                	String periodName='FY'+year+'P'+monthStr;
		                	
				
		                	FCST_Opportunity_Initial_Forecast__c pmForecastObj = new FCST_Opportunity_Initial_Forecast__c();
		                	pmForecastObj.FCST_Planning_Version__c =lstMPlanningversion[0].Id;
		                	if(mapPeriodNameVsPeriodObj.containsKey(periodName)){
		                		pmForecastObj.Fcst_Fiscal_Period__c=mapPeriodNameVsPeriodObj.get(periodName).Id;
		                	}
		                	pmForecastObj.Fcst_Opportunity__c=oppObj.Id;
		                	if(oppQhash!=null){
		                		pmForecastObj.Fcst_Q__c=oppQhash;
		                	}	
		                	pmForecastObj.FCST_Transition_Revenue__c=trAmount;
		                	pmForecastObj.FCST_Service_Revenue__c=serviceAmount;
		                	
		                	
		                	newPMForecastModelList.add(pmForecastObj);
		                	mapPeriodNameVsMOdel.put(periodName,pmForecastObj);
		                	month++;
		                	modelCount++;
		                }
	                }
	                
	                for(OpportunitylineItem lineObj:oppObj.OpportunitylineItems){
	                    String revenueType='';
	                    
	                    Integer yearPro=0,monthPro=0,productNumber=1;
	                    yearPro=oppStartDate.year();
	                	monthPro=oppStartDate.month();
	                    Decimal totalLineItemAmount=0;
	                    
	                    if(lineObj.TotalPrice!=null)
	                    totalLineItemAmount=lineObj.TotalPrice;
	                    
	                    
	                    if(lineObj.getSObject('Product2')!=null && (String)lineObj.getSObject('Product2').get(productRevenueTypeAPI)!=null)
	                         revenueType=(String)lineObj.getSObject('Product2').get(productRevenueTypeAPI);
	                    
	                        
	                        if(setRevenueType.contains(revenueType) && mapRegimeCount.containsKey(revenueType+'#'+get15DigitId(lineObj.Product2Id))){
	                            Integer monthDiff=mapRegimeCount.get(revenueType+'#'+get15DigitId(lineObj.Product2Id));
	                              
	                            for(Integer i=0;i<monthDiff;i++){
				                	
				                Decimal productnumberPercent=0;
				                
				                if(mapCMPercentage.containskey(revenueType+'#'+get15DigitId(lineObj.Product2Id)+'#M+'+productNumber)){
				                	productnumberPercent=mapCMPercentage.get(revenueType+'#'+get15DigitId(lineObj.Product2Id)+'#M+'+productNumber);
				                }
				                Decimal productAmout=(totalLineItemAmount*	productnumberPercent)/100;	
				                	String monthStr='';
				                	if(monthPro==13){
				                		yearPro++;
				                		monthPro=1;
				                	}
				                	if(monthPro<10){
				                		monthStr='0'+monthPro;
				                	}
				                	else{
				                		monthStr=String.valueOf(monthPro);
				                	}
				                	
				                	String periodName='FY'+yearPro+'P'+monthStr;
				                	
									if(mapPeriodNameVsMOdel.containsKey(periodName)){
										FCST_Opportunity_Initial_Forecast__c pmObj=mapPeriodNameVsMOdel.get(periodName);
										if(pmObj.FCST_Product_Revenue__c==null)
											pmObj.FCST_Product_Revenue__c=0;
											
											
										pmObj.FCST_Product_Revenue__c=pmObj.FCST_Product_Revenue__c+productAmout;
									}
									
									else{
					                	FCST_Opportunity_Initial_Forecast__c pmForecastObj = new FCST_Opportunity_Initial_Forecast__c();
					                	pmForecastObj.FCST_Planning_Version__c =lstMPlanningversion[0].Id;
					                	if(mapPeriodNameVsPeriodObj.containsKey(periodName)){
					                		pmForecastObj.Fcst_Fiscal_Period__c=mapPeriodNameVsPeriodObj.get(periodName).Id;
					                	}
					                	pmForecastObj.Fcst_Opportunity__c=oppObj.Id;
					                	if(oppQhash!=null){
					                		pmForecastObj.Fcst_Q__c=oppQhash;
					                	}
					                	pmForecastObj.FCST_Product_Revenue__c=productAmout;	
					                	
					                	newPMForecastModelList.add(pmForecastObj);
					                	mapPeriodNameVsMOdel.put(periodName,pmForecastObj);
									}
				                	monthPro++;
				                	productNumber++;
				                }    
	                                
	                        }
	                    }
	               if(newPMForecastModelList!=null && newPMForecastModelList.size()>0){
	               		for(FCST_Opportunity_Initial_Forecast__c pnObj:newPMForecastModelList){
	               			decimal totalAmount=0;
	               			if(pnObj.FCST_Transition_Revenue__c!=null)
	               				totalAmount+=pnObj.FCST_Transition_Revenue__c;
	               			if(pnObj.FCST_Service_Revenue__c!=null)	
	               				totalAmount+=pnObj.FCST_Service_Revenue__c;
	               			if(pnObj.FCST_Product_Revenue__c!=null)	
	               				totalAmount+=pnObj.FCST_Product_Revenue__c;
	               			
	               			pnObj.Fcst_Weighted_Revenue__c=totalAmount;
	               			pnObj.User_Adjusted_Revenue__c=totalAmount;
	               			
	               		}
	               } 
	                                            
	             insert newPMForecastModelList;   
	            }
	        }
	        
	        
	        
	            
	         if(productmodelList!=null && productmodelList.size()>0)
	         	delete productmodelList;       
           
        }catch(Exception e) {
            System.debug('The following exception has occurred:' + e.getMessage());
            System.debug('Line number: ' + e.getLineNumber()); 
          }     
            
    }
}