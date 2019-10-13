public class MappingFieldUtility{
    
    Mapping_Setting__c setting; 
    public MappingFieldUtility(){
        setting = Mapping_Setting__c.getValues('FCST Mapping Data'); 
    }
  
    
   
  
    
    public string getOpportunityDynamicFields(){ 
        string query='';
      
        return query;
    }
 
  
    
    public string getRevenueType(){
        if(setting <> null && setting.Fcst_Revenue_Type__c <> null) return setting.Fcst_Revenue_Type__c;
        return '';
    }   
    public string getRevenueType(sobject Obj){ 
        if(setting <> null && Obj <> null && setting.Fcst_Revenue_Type__c <> null ) 
            return string.valueOf(obj.get(setting.Fcst_Revenue_Type__c));
        return null;
    }
    public string getProjectStartDate(){ 
        if(setting <> null && setting.Fcst_StartDate__c <> null) return setting.Fcst_StartDate__c;
        return '';
    }   
    public string getProjectStartDate(sobject Obj){
        if(setting <> null && Obj <> null && setting.Fcst_StartDate__c <> null && obj.get(setting.Fcst_StartDate__c) <> null) 
            return string.valueOf(obj.get(setting.Fcst_StartDate__c));
        return null;
    }
    public string getProjectEndDate(){
        if(setting <> null && setting.Fcst_EndDate__c <> null) return setting.Fcst_EndDate__c;
        return '';
    }   
    public string getProjectEndDate(sobject Obj){
        if(setting <> null && Obj <> null && setting.Fcst_EndDate__c <> null && obj.get(setting.Fcst_EndDate__c) <> null) 
            return string.valueOf(obj.get(setting.Fcst_EndDate__c));
        return null;
    }
    public string getSalesRegion(){
        if(setting <> null && setting.Fcst_SalesRegion__c <> null) return setting.Fcst_SalesRegion__c;
        return '';
    }   
    public string getSalesRegion(sobject Obj){ 
        if(setting <> null && Obj <> null && setting.Fcst_SalesRegion__c <> null && obj.get(setting.Fcst_SalesRegion__c) <> null) 
            return string.valueOf(obj.get(setting.Fcst_SalesRegion__c));
        return null;
    }
    public string getSubRegion(){
        if(setting <> null && setting.Fcst_SubRegion__c <> null) return setting.Fcst_SubRegion__c;
        return '';
    }   
    public string getSubRegion(sobject Obj){
        if(setting <> null && Obj <> null && setting.Fcst_SubRegion__c <> null && obj.get(setting.Fcst_SubRegion__c) <> null) 
            return string.valueOf(obj.get(setting.Fcst_SubRegion__c));
        return null;
    }
    public string getCPMRegion(){
        if(setting <> null && setting.Fcst_CPM__c <> null) return setting.Fcst_CPM__c;
        return '';
    }   
    public string getCPMRegion(sobject Obj){
        if(setting <> null && Obj <> null && setting.Fcst_CPM__c <> null && obj.get(setting.Fcst_CPM__c) <> null) 
            return string.valueOf(obj.get(setting.Fcst_CPM__c));
        return null;
    }
   /* public string getBusinessUnit(){
        if(setting <> null && setting.Fcst_BusinessUnit__c <> null) return setting.Fcst_BusinessUnit__c;
        return '';
    }   
    public string getBusinessUnit(sobject Obj){
        if(setting <> null && Obj <> null && setting.Fcst_BusinessUnit__c <> null && obj.get(setting.Fcst_BusinessUnit__c) <> null) 
            return string.valueOf(obj.get(setting.Fcst_BusinessUnit__c));
        return null;
    } */
     public string getQNum(){
        if(setting <> null && setting.fcst_Q__c<> null) return setting.fcst_Q__c;
        return '';
    } 
    public string getGeoNum(){
        if(setting <> null && setting.Geo__c<> null) return setting.Geo__c;
        return '';
    } 
   public string getProgramManager(){
        if(setting <> null && setting.FCST_ProgramManager__c<> null) return setting.FCST_ProgramManager__c;
        return '';
    } 
    
}