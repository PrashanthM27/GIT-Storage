public with sharing class FCST_DefaultSettingResponse{
    public boolean isSuccess;
    public String response;
    public Integer recordCount; 
    public FCST_DefaultSettingResponse(boolean isSuccess,String response,Integer recordCount){
        this.isSuccess = isSuccess;
        this.response = response;
        this.recordCount = recordCount;
    }
}