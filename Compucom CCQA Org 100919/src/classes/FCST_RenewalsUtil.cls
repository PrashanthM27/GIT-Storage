public class FCST_RenewalsUtil {
	
    public static String RenewalsSum(List<String> args2,id AccIdd,id UserI,String pVVersionStringId,String strPlanningVersion,Set<Id> pagSet, Map<id,List<FCST_Product_Model__c>> mapProductIdOppIdVsProductListFunnel){
       
        Decimal TotalRenewalTotalAdjustedForecasAmount=0,RenewalTotalAdjustedForecasAmount1=0,RenewalTotalAdjustedForecasAmount2=0,RenewalTotalAdjustedForecasAmount3=0,RenewalTotalAdjustedForecasAmount4=0,RenewalTotalAdjustedForecasAmount5=0,RenewalTotalAdjustedForecasAmount6=0,RenewalTotalAdjustedForecasAmount7=0,RenewalTotalAdjustedForecasAmount8=0,RenewalTotalAdjustedForecasAmount9=0,RenewalTotalAdjustedForecasAmount10=0,RenewalTotalAdjustedForecasAmount11=0,RenewalTotalAdjustedForecasAmount12=0;
    	Decimal TotalRenewalTotalUnAdjustedForecasAmount=0,RenewalTotalUnAdjustedForecasAmount1=0,RenewalTotalUnAdjustedForecasAmount2=0,RenewalTotalUnAdjustedForecasAmount3=0,RenewalTotalUnAdjustedForecasAmount4=0,RenewalTotalUnAdjustedForecasAmount5=0,RenewalTotalUnAdjustedForecasAmount6=0,RenewalTotalUnAdjustedForecasAmount7=0,RenewalTotalUnAdjustedForecasAmount8=0,RenewalTotalUnAdjustedForecasAmount9=0,RenewalTotalUnAdjustedForecasAmount10=0,RenewalTotalUnAdjustedForecasAmount11=0,RenewalTotalUnAdjustedForecasAmount12=0;
    	String FinalStr;
       for(Id acciD :pagSet){  
        if(mapProductIdOppIdVsProductListFunnel.containsKey(acciD)){

       Decimal AdjustedRenewalForecastAmount=0,AdjustedRenewalForecast=0,AdjustedRenewalForecast1=0,AdjustedRenewalForecast2=0,AdjustedRenewalForecast3=0,AdjustedRenewalForecast4=0,AdjustedRenewalForecast5=0,AdjustedRenewalForecast6=0,AdjustedRenewalForecast7=0,AdjustedRenewalForecast8=0,AdjustedRenewalForecast9=0,AdjustedRenewalForecast10=0,AdjustedRenewalForecast11=0,AdjustedRenewalForecast12=0,UnadjustedRenewalForecastAmount=0,TotalUnadjustedRenewalForecastAmount=0,UnadjustedRenewalForecastAmount1=0,UnadjustedRenewalForecastAmount2=0,UnadjustedRenewalForecastAmount3=0,UnadjustedRenewalForecastAmount4=0,UnadjustedRenewalForecastAmount5=0,UnadjustedRenewalForecastAmount6=0,UnadjustedRenewalForecastAmount7=0,UnadjustedRenewalForecastAmount8=0,UnadjustedRenewalForecastAmount9=0,UnadjustedRenewalForecastAmount10=0,UnadjustedRenewalForecastAmount11=0,UnadjustedRenewalForecastAmount12=0;
      ID ModelIdd,ModelIdd1,ModelIdd2,ModelIdd3,ModelIdd4,ModelIdd5,ModelIdd6,ModelIdd7,ModelIdd8,ModelIdd9,ModelIdd10,ModelIdd11,ModelIdd12 ;
    
      List<FCST_Product_Model__c> getproductModelList=mapProductIdOppIdVsProductListFunnel.get(acciD);
      for(FCST_Product_Model__c productModelObj:getproductModelList){String fiscalPeriod=productModelObj.Fiscal_Period__r.Name;String planningP = fiscalPeriod.split('P')[1];                                    
                                     if(productModelObj.User_Adjusted_Revenue__c!=null && productModelObj.Weighted_Revenue__c!=null){AdjustedRenewalForecastAmount=Math.round(productModelObj.User_Adjusted_Revenue__c);UnadjustedRenewalForecastAmount=Math.round(productModelObj.Weighted_Revenue__c);}
       if( planningP=='01' && productModelObj.Planning_Version__r.Name==strPlanningVersion){AdjustedRenewalForecast1=AdjustedRenewalForecastAmount;UnadjustedRenewalForecastAmount1=UnadjustedRenewalForecastAmount;RenewalTotalAdjustedForecasAmount1+=AdjustedRenewalForecast1;RenewalTotalUnAdjustedForecasAmount1+=UnadjustedRenewalForecastAmount1;}
        else if( planningP=='02' && productModelObj.Planning_Version__r.Name==strPlanningVersion){AdjustedRenewalForecast2=AdjustedRenewalForecastAmount;UnadjustedRenewalForecastAmount2=UnadjustedRenewalForecastAmount;RenewalTotalAdjustedForecasAmount2+=AdjustedRenewalForecast2;RenewalTotalUnAdjustedForecasAmount2+=UnadjustedRenewalForecastAmount2;}
        else if( planningP=='03' && productModelObj.Planning_Version__r.Name==strPlanningVersion){AdjustedRenewalForecast3=AdjustedRenewalForecastAmount;UnadjustedRenewalForecastAmount3=UnadjustedRenewalForecastAmount;RenewalTotalAdjustedForecasAmount3+=AdjustedRenewalForecast3;RenewalTotalUnAdjustedForecasAmount3+=UnadjustedRenewalForecastAmount3;}
        else if( planningP=='04' && productModelObj.Planning_Version__r.Name==strPlanningVersion){AdjustedRenewalForecast4=AdjustedRenewalForecastAmount;UnadjustedRenewalForecastAmount4=UnadjustedRenewalForecastAmount;RenewalTotalAdjustedForecasAmount4+=AdjustedRenewalForecast4;RenewalTotalUnAdjustedForecasAmount4+=UnadjustedRenewalForecastAmount4;}
        else if( planningP=='05' && productModelObj.Planning_Version__r.Name==strPlanningVersion){AdjustedRenewalForecast5=AdjustedRenewalForecastAmount;UnadjustedRenewalForecastAmount5=UnadjustedRenewalForecastAmount;RenewalTotalAdjustedForecasAmount5+=AdjustedRenewalForecast5;RenewalTotalUnAdjustedForecasAmount5+=UnadjustedRenewalForecastAmount5;}
        else if( planningP=='06' && productModelObj.Planning_Version__r.Name==strPlanningVersion){AdjustedRenewalForecast6=AdjustedRenewalForecastAmount;UnadjustedRenewalForecastAmount6=UnadjustedRenewalForecastAmount;RenewalTotalAdjustedForecasAmount6+=AdjustedRenewalForecast6;RenewalTotalUnAdjustedForecasAmount6+=UnadjustedRenewalForecastAmount6;}
        else if( planningP=='07' && productModelObj.Planning_Version__r.Name==strPlanningVersion){AdjustedRenewalForecast7=AdjustedRenewalForecastAmount;UnadjustedRenewalForecastAmount7=UnadjustedRenewalForecastAmount;RenewalTotalAdjustedForecasAmount7+=AdjustedRenewalForecast7;RenewalTotalUnAdjustedForecasAmount7+=UnadjustedRenewalForecastAmount7;}
        else if( planningP=='08' && productModelObj.Planning_Version__r.Name==strPlanningVersion){AdjustedRenewalForecast8=AdjustedRenewalForecastAmount;UnadjustedRenewalForecastAmount8=UnadjustedRenewalForecastAmount;RenewalTotalAdjustedForecasAmount8+=AdjustedRenewalForecast8;RenewalTotalUnAdjustedForecasAmount8+=UnadjustedRenewalForecastAmount8;}
        else if( planningP=='09' && productModelObj.Planning_Version__r.Name==strPlanningVersion){AdjustedRenewalForecast9=AdjustedRenewalForecastAmount;UnadjustedRenewalForecastAmount9=UnadjustedRenewalForecastAmount;RenewalTotalAdjustedForecasAmount9+=AdjustedRenewalForecast9;RenewalTotalUnAdjustedForecasAmount9+=UnadjustedRenewalForecastAmount9;}
       else if( planningP=='10' && productModelObj.Planning_Version__r.Name==strPlanningVersion){AdjustedRenewalForecast10=AdjustedRenewalForecastAmount;UnadjustedRenewalForecastAmount10=UnadjustedRenewalForecastAmount;RenewalTotalAdjustedForecasAmount10+=AdjustedRenewalForecast10;RenewalTotalUnAdjustedForecasAmount10+=UnadjustedRenewalForecastAmount10;}
       else if( planningP=='11' && productModelObj.Planning_Version__r.Name==strPlanningVersion){AdjustedRenewalForecast11=AdjustedRenewalForecastAmount;UnadjustedRenewalForecastAmount11=UnadjustedRenewalForecastAmount;RenewalTotalAdjustedForecasAmount11+=AdjustedRenewalForecast11;RenewalTotalUnAdjustedForecasAmount11+=UnadjustedRenewalForecastAmount11;}
       else if( planningP=='12' && productModelObj.Planning_Version__r.Name==strPlanningVersion){AdjustedRenewalForecast12=AdjustedRenewalForecastAmount;UnadjustedRenewalForecastAmount12=UnadjustedRenewalForecastAmount;RenewalTotalAdjustedForecasAmount12+=AdjustedRenewalForecast12;RenewalTotalUnAdjustedForecasAmount12+=UnadjustedRenewalForecastAmount12;}                                     }
      }
        String OpenCatRow='<tr style="background-color:#313A8B;"><th style="background-color:#313A8B;color: white;size: 10%;text-align: center;" colspan="14"><b>Open Opportunities</b></th></tr>';
        TotalRenewalTotalUnAdjustedForecasAmount=RenewalTotalUnAdjustedForecasAmount1+RenewalTotalUnAdjustedForecasAmount2+RenewalTotalUnAdjustedForecasAmount3+RenewalTotalUnAdjustedForecasAmount4+RenewalTotalUnAdjustedForecasAmount5+RenewalTotalUnAdjustedForecasAmount6+RenewalTotalUnAdjustedForecasAmount7+RenewalTotalUnAdjustedForecasAmount8+RenewalTotalUnAdjustedForecasAmount9+RenewalTotalUnAdjustedForecasAmount10+RenewalTotalUnAdjustedForecasAmount11+RenewalTotalUnAdjustedForecasAmount12;        TotalRenewalTotalAdjustedForecasAmount=RenewalTotalAdjustedForecasAmount1+RenewalTotalAdjustedForecasAmount2+RenewalTotalAdjustedForecasAmount3+RenewalTotalAdjustedForecasAmount4+RenewalTotalAdjustedForecasAmount5+RenewalTotalAdjustedForecasAmount6+RenewalTotalAdjustedForecasAmount7+RenewalTotalAdjustedForecasAmount8+RenewalTotalAdjustedForecasAmount9+RenewalTotalAdjustedForecasAmount10+RenewalTotalAdjustedForecasAmount11+RenewalTotalAdjustedForecasAmount12;
        String  RenewalRow='<tr><th title="Forecast Category" class=worstRow'+acciD+'  style="background-color:#D9E1F2;color:black;size: 10%;font-size: 110%;"><b><center>Open - Renewals</center></b><a href="/apex/Fcst_RenewalSW?pv='+pVVersionStringId+'&su='+UserI+'&AccId='+AccIdd+'" target="_blank">(Click here to view detailed Forecast)</a></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#D9E1F2;border-right-color: #D9E1F2;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#D9E1F2;border-right-color: #D9E1F2;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#D9E1F2;border-right-color: #D9E1F2;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#D9E1F2;border-right-color: #D9E1F2;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#D9E1F2;border-right-color: #D9E1F2;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#D9E1F2;border-right-color: #D9E1F2;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#D9E1F2;border-right-color: #D9E1F2;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#D9E1F2;border-right-color: #D9E1F2;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#D9E1F2;border-right-color: #D9E1F2;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#D9E1F2;border-right-color: #D9E1F2;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#D9E1F2;border-right-color: #D9E1F2;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#D9E1F2;border-right-color: #D9E1F2;"></th><th class=worstRow'+acciD+' style="text-align: center;background-color:#D9E1F2;border-right-color: #D9E1F2;"></th></tr>';
        String  TotalAdjustedRenewal='<tr ><th title="Adjusted Forecast" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;">  Adjusted Forecast</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format( RenewalTotalAdjustedForecasAmount1.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; "  class=mostlLikelyOpp'+acciD+'>$'+String.format( RenewalTotalAdjustedForecasAmount2.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( RenewalTotalAdjustedForecasAmount3.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( RenewalTotalAdjustedForecasAmount4.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format( RenewalTotalAdjustedForecasAmount5.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format( RenewalTotalAdjustedForecasAmount6.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( RenewalTotalAdjustedForecasAmount7.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( RenewalTotalAdjustedForecasAmount8.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( RenewalTotalAdjustedForecasAmount9.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( RenewalTotalAdjustedForecasAmount10.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( RenewalTotalAdjustedForecasAmount11.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( RenewalTotalAdjustedForecasAmount12.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( TotalRenewalTotalAdjustedForecasAmount.setscale(0).format(), args2)+'</th></tr>';   
        String  TotalUnAdjustedRenewal='<tr ><th title="Unadjusted Forecast" class=bestOppRow'+acciD+'  style="background-color:white;color:black;text-align: right;"> Unadjusted Forecast</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format( RenewalTotalUnAdjustedForecasAmount1.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; "  class=mostlLikelyOpp'+acciD+'>$'+String.format( RenewalTotalUnAdjustedForecasAmount2.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( RenewalTotalUnAdjustedForecasAmount3.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( RenewalTotalUnAdjustedForecasAmount4.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format( RenewalTotalUnAdjustedForecasAmount5.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center;" class=mostlLikelyOpp'+acciD+'>$'+String.format( RenewalTotalUnAdjustedForecasAmount6.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( RenewalTotalUnAdjustedForecasAmount7.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( RenewalTotalUnAdjustedForecasAmount8.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( RenewalTotalUnAdjustedForecasAmount9.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( RenewalTotalUnAdjustedForecasAmount10.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( RenewalTotalUnAdjustedForecasAmount11.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( RenewalTotalUnAdjustedForecasAmount12.setscale(0).format(), args2)+'</th><th style="background-color:#D0CECE;text-align: center; " class=mostlLikelyOpp'+acciD+'>$'+String.format( TotalRenewalTotalUnAdjustedForecasAmount.setscale(0).format(), args2)+'</th></tr>';   
        FinalStr = OpenCatRow+RenewalRow+TotalAdjustedRenewal+TotalUnAdjustedRenewal;
           
       }
        return FinalStr;

    }
}