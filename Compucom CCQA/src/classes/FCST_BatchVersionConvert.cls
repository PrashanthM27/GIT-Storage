global class FCST_BatchVersionConvert implements Database.Batchable<sObject>,Database.stateful{
    global Set<Id> setFailedAccounts = new Set<Id>();
    global Set<FCST_Product_Model__c> FailureAccounts = new Set<FCST_Product_Model__c>();
    global String Query;
    map<Id,Id> mapVersionChange;
    global FCST_BatchVersionConvert(map<Id,Id> mv){
        mapVersionChange = mv;
        set<Id> setVersions = new set<Id>();
        setVersions = mapVersionChange.keyset();
        Decimal PvNumber=0;
        List<Planning_Version__c> cPV = [select id,CopyNumber__c,Version_Status__c from Planning_Version__c where Version_Status__c='Open (Admin)'  limit 1];
        for(Planning_Version__c pv : cPV){
            PvNumber = pv.CopyNumber__c;
        }
        Query = 'select Id,EndNumber__c,Account__c,FCST_Revenue_Types__c,Account_Owner__c,Opportunity__r.AccountId,Opportunity__r.Account.OwnerId,Planning_Version__r.OpenByInProgressVersion__c,Product__c,Model_Name__c,Name,Amount__c,Opportunity__r.StageName,';
        Query += 'Opportunity__r.CloseDate,Planning_Version__c,Planning_Version__r.Data_Entry_Closed_Date__c,Planning_Version__r.Name,Fiscal_Period__c,Fiscal_Period__r.Name,Planning_Measure__r.Name,Planning_Measure__c,';
        Query += 'Opportunity__c,Account_Business_Unit__c,Account_CPM_Region__c,FCST_Product_Line_ID__c,Account_Sales_Region__c,Account_Sub_region__c,User_Adjusted_Revenue__c,Weighted_Revenue__c from FCST_Product_Model__c where Planning_Version__c IN: setVersions';
        Query += ' AND EndNumber__c >=: PvNumber order by Opportunity__r.AccountId';
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
       Decimal PvNumber=0;
       List<Planning_Version__c> cPV = [select id,CopyNumber__c,Version_Status__c from Planning_Version__c where Version_Status__c='Open (Admin)'  limit 1];
        for(Planning_Version__c pv : cPV){
            PvNumber = pv.CopyNumber__c;
        }
        set<Id> setVersions = new set<Id>();
        setVersions = mapVersionChange.keyset();
        return Database.getQueryLocator(query);
    }
      
    global void execute(Database.BatchableContext BC, List<FCST_Product_Model__c> scope){
        if(scope.size()>0){
            map<Id,Planning_Version__c> mapVersionChangev2 = new map<Id,Planning_Version__c>();
            set<Id> setModelVersion = new set<Id>();
            for(FCST_Product_Model__c m: scope){
                setModelVersion.add(m.Planning_Version__c);
            }
            for(Planning_Version__c v : [select Id,Name,Previous_Version__c,Data_Entry_Closed_Date__c from Planning_Version__c where  Previous_Version__c IN: setModelVersion]){
                mapVersionChangev2.put(v.Previous_Version__c,v);
            }
            
            string cYear = string.valueOf(system.today().Year());            
            
            List<FCST_Product_Model__c > lstModels = new List<FCST_Product_Model__c >();
            List<FCST_Product_Model__c > lstProcessModels = new List<FCST_Product_Model__c >();
            
            set<string> processKeys = new set<string>();
            
            
            set<Id> setOppIds = new set<Id>();
           
            
            for(FCST_Product_Model__c m :scope){
                
                        Id newVersion = mapVersionChangev2.get(m.Planning_Version__c).id;
                        string Key = LEFT15Digit(m.Opportunity__c)+'#'+LEFT15Digit(m.Fiscal_Period__c)+'#'+LEFT15Digit(newVersion)+'#'+LEFT15Digit(m.Product__c);
                        processKeys.add(key);
                        lstProcessModels.add(m);
                        setOppIds.add(m.opportunity__c);
                
            }
            map<string,FCST_Product_Model__c> mapExistingModel = new map<string,FCST_Product_Model__c>();
            for(FCST_Product_Model__c m :[select Id,EndNumber__c,FCST_Revenue_Types__c,Account__c,Account_Owner__c,Opportunity__r.AccountId,Opportunity__r.Account.OwnerId,Model_Name__c,Planning_Version__r.OpenByInProgressVersion__c,Product__c ,Name,Amount__c,Planning_Version__c,Planning_Version__r.Name,Fiscal_Period__c,Fiscal_Period__r.Name,
                    Planning_Measure__r.Name,Planning_Measure__c,FCST_Product_Line_ID__c,Opportunity__c from FCST_Product_Model__c where Model_Name__c IN: processKeys order by Opportunity__r.AccountId]){
                mapExistingModel.put(m.Model_Name__c,m);
            }
            
            
       
            for(FCST_Product_Model__c m :lstProcessModels){
                
                Id newVersion = mapVersionChangev2.get(m.Planning_Version__c).id;
                system.debug('##5:'+ mapVersionChangev2.get(m.Planning_Version__c).Name);
                string Key = LEFT15Digit(m.Opportunity__c)+'#'+LEFT15Digit(m.Fiscal_Period__c)+'#'+LEFT15Digit(newVersion)+'#'+LEFT15Digit(m.Product__c);
                
                
                FCST_Product_Model__c newModel;
                if(mapExistingModel.containsKey(key)){ 
                    newModel = mapExistingModel.get(key); 
                    newModel.Comments__c = 'Updated by copy from '+m.Planning_Version__r.Name; 
                }else {
                    newModel = new FCST_Product_Model__c ();
                    newModel.Comments__c = 'generated by copy from '+m.Planning_Version__r.Name;
                    newModel.Opportunity__c = m.Opportunity__c;
                }
                    
                newModel.Amount__c = m.Amount__c;
                newModel.Planning_Version__c = newVersion;        
                newModel.Fiscal_Period__c = m.Fiscal_Period__c;
                newModel.Planning_Measure__c = m.Planning_Measure__c;
                newModel.Product__c = m.Product__c;
                newModel.Account__c= m.Opportunity__r.AccountId;   
                newModel.Account_Owner__c= m.Opportunity__r.Account.OwnerId;
                newModel.EndNumber__c= m.EndNumber__c;
                newModel.Account_Business_Unit__c= m.Account_Business_Unit__c;
                newModel.Account_CPM_Region__c= m.Account_CPM_Region__c;
                newModel.Account_Sales_Region__c= m.Account_Sales_Region__c;
                newModel.Account_Sub_region__c= m.Account_Sub_region__c;
                newModel.FCST_Product_Line_ID__c= m.FCST_Product_Line_ID__c;
                newModel.Weighted_Revenue__c= m.Weighted_Revenue__c;
                newModel.User_Adjusted_Revenue__c= m.User_Adjusted_Revenue__c;
                newModel.FCST_Revenue_Types__c= m.FCST_Revenue_Types__c;
                lstModels.add(newModel);
                                              
                  
            }
             if(lstModels != null && lstModels.size()>0){ 
             Database.UpsertResult[] srList = Database.upsert(lstModels, false);
             for(Integer i=0;i<srList.size();i++){
                  if(!srList.get(i).isSuccess()){
                     FailureAccounts.add(lstModels.get(i));
                  }
                 
              }
        }
        }
    }
    public string LEFT15Digit(string str){
        if(str <> null && str <> '' && str.length() > 15){
            str = str.substring(0,15);
        }
        return str;
    }

    global void finish(Database.BatchableContext BC){
     // sendMailToAdmin();
    }
    global void sendMailToAdmin(){
        List<Fcst_Batch_Status__c> lstAllAdmins = Fcst_Batch_Status__c.getAll().values();
        List<id> lstUserIds = new List<String>();
        for(Fcst_Batch_Status__c getRec:lstAllAdmins){
           lstUserIds.add(getRec.User_Id__c ); 
        }

       if(FailureAccounts != null && FailureAccounts.size()>0){
             String strBody = '';
                strBody = 'Please find attachement for error records';
                String finalstr = 'Id,Comments__c, Amount__c, Planning_Version__c,  Fiscal_Period__c,  Planning_Measure__c,  Product__c,  Account__c,Account_Owner__c,EndNumber__c,Account_Business_Unit__c,Account_CPM_Region__c,Account_Sales_Region__c,Account_Sub_region__c,FCST_Product_Line_ID__c,Weighted_Revenue__c,User_Adjusted_Revenue__c,FCST_Revenue_Types__c\n';
                for(FCST_Product_Model__c a:FailureAccounts){
                    string recordString = a.id+',' +a.Comments__c+ ','+a.Amount__c+',' +a.Planning_Version__c+',' +a.Fiscal_Period__c+',' +a.Planning_Measure__c+',' +a.Product__c+',' +a.Account__c+',' +a.Account_Owner__c+',' +a.EndNumber__c+',' +a.Account_Business_Unit__c+',' +a.Account_CPM_Region__c+',' +a.Account_Sales_Region__c+',' +a.Account_Sub_region__c+',' +a.FCST_Product_Line_ID__c+',' +a.Weighted_Revenue__c+',' +a.User_Adjusted_Revenue__c+',' +a.FCST_Revenue_Types__c+'\n';
                    finalstr = finalstr +recordString; 
                }
                sendErrorTemplate(lstUserIds,strBody,finalstr);

        }
          
     }
     public void sendErrorTemplate(List<Id> lstUserIds, String strMessage,String finalstr){
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
          
            mail.setToAddresses(lstUserIds);
            mail.subject = 'Product model Errro records | '+DateTime.now();
            mail.setPlainTextBody(strMessage);
                 Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                    attach.setBody(Blob.valueOf(finalstr));
                    attach.setFileName('ErrorFile.csv');
                    mail.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});
        // Send the email you have created.
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

    }
}