global class Fcst_CopyPMForecast implements Database.Batchable<sObject>,Database.stateful{
    global Set<Id> setFailedAccounts = new Set<Id>();
    global String Query;
    global Set<FCST_Opportunity_Initial_Forecast__c> OppInitialForecast = new Set<FCST_Opportunity_Initial_Forecast__c>();
    map<Id,Id> mapVersionChange;
    global Fcst_CopyPMForecast(map<Id,Id> mv){
        mapVersionChange = mv;
        set<Id> setVersions = new set<Id>();
     
        Query = 'select Id,Fcst_Fiscal_Period__c,FCST_Planning_Version__c,FCST_Planning_Version__r.name,Fcst_Q__c,Fcst_Weighted_Revenue__c,User_Adjusted_Revenue__c,Fcst_Opportunity__c from FCST_Opportunity_Initial_Forecast__c where FCST_Planning_Version__c IN: setVersions';
       
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
     
        set<Id> setVersions = new set<Id>();
        setVersions = mapVersionChange.keyset();
        return Database.getQueryLocator(query);
    }
      
    global void execute(Database.BatchableContext BC, List<FCST_Opportunity_Initial_Forecast__c> scope){
        if(scope.size()>0){
    
            map<Id,Planning_Version__c> mapVersionChangev2 = new map<Id,Planning_Version__c>();
            set<Id> setModelVersion = new set<Id>();
            for(FCST_Opportunity_Initial_Forecast__c m: scope){
                setModelVersion.add(m.FCST_Planning_Version__c);
            }
            for(Planning_Version__c v : [select Id,Name,Previous_Version__c,Data_Entry_Closed_Date__c from Planning_Version__c where  Previous_Version__c IN: setModelVersion]){
                mapVersionChangev2.put(v.Previous_Version__c,v);
            }
            
            string cYear = string.valueOf(system.today().Year());            
            
            List<FCST_Opportunity_Initial_Forecast__c > lstModels = new List<FCST_Opportunity_Initial_Forecast__c >();
            List<FCST_Opportunity_Initial_Forecast__c > lstProcessModels = new List<FCST_Opportunity_Initial_Forecast__c >();
            
            set<string> processKeys = new set<string>();
            
            
            set<Id> setOppIds = new set<Id>();
           
            
            for(FCST_Opportunity_Initial_Forecast__c m :scope){
                
                       
                        Id newVersion = mapVersionChangev2.get(m.FCST_Planning_Version__c).id;
                           
                        string Key = LEFT15Digit(m.Fcst_Opportunity__c)+'#'+LEFT15Digit(m.Fcst_Fiscal_Period__c)+'#'+LEFT15Digit(newVersion);
                        processKeys.add(key);
                        lstProcessModels.add(m);
                
            }
            map<string,FCST_Opportunity_Initial_Forecast__c> mapExistingModel = new map<string,FCST_Opportunity_Initial_Forecast__c>();
            for(FCST_Opportunity_Initial_Forecast__c m :[select Id,Model_Name__c,Fcst_Fiscal_Period__c,FCST_Planning_Version__c,Fcst_Q__c,User_Adjusted_Revenue__c,Fcst_Weighted_Revenue__c,Fcst_Opportunity__c from FCST_Opportunity_Initial_Forecast__c where Model_Name__c IN: processKeys]){
                mapExistingModel.put(m.Model_Name__c,m);
            }
            
            
       
            for(FCST_Opportunity_Initial_Forecast__c m :lstProcessModels){
                
                Id newVersion = mapVersionChangev2.get(m.FCST_Planning_Version__c).id;
                string Key = LEFT15Digit(m.Fcst_Opportunity__c)+'#'+LEFT15Digit(m.Fcst_Fiscal_Period__c)+'#'+LEFT15Digit(m.FCST_Planning_Version__c);
                
                
                FCST_Opportunity_Initial_Forecast__c newModel;
                if(mapExistingModel.containsKey(key)){ newModel = mapExistingModel.get(key); newModel.Comments__c = 'Updated by copy from '+m.FCST_Planning_Version__r.Name; }
                else {
                    newModel = new FCST_Opportunity_Initial_Forecast__c ();
                    newModel.Comments__c = 'generated by copy from '+m.FCST_Planning_Version__r.Name;
                }
                    
                newModel.Fcst_Fiscal_Period__c = m.Fcst_Fiscal_Period__c;
                newModel.FCST_Planning_Version__c= newVersion;
                newModel.Fcst_Q__c = m.Fcst_Q__c;        
                newModel.Fcst_Weighted_Revenue__c = m.Fcst_Weighted_Revenue__c;
                newModel.Fcst_Opportunity__c = m.Fcst_Opportunity__c;
                newModel.User_Adjusted_Revenue__c = m.User_Adjusted_Revenue__c;
                lstModels.add(newModel);
                                              
                  
            }
             if(lstModels != null && lstModels.size()>0){ 
             Database.UpsertResult[] srList = Database.upsert(lstModels, false);
             for(Integer i=0;i<srList.size();i++){
                  if(!srList.get(i).isSuccess()){                      
                     OppInitialForecast.add(lstModels.get(i)); 
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
      //   System.debug('Finish');
      sendMailToAdmin();
    }
    global void sendMailToAdmin(){
        List<Fcst_Batch_Status__c> lstAllAdmins = Fcst_Batch_Status__c.getAll().values();
        List<id> lstUserIds = new List<String>();
        for(Fcst_Batch_Status__c getRec:lstAllAdmins){
           lstUserIds.add(getRec.User_Id__c ); 
            System.debug('lstUserIds'+lstUserIds);
        }

           if(OppInitialForecast != null && OppInitialForecast.size()>0){
             String strBody = '';
                strBody = 'Please find attachement for Product model error records';
                String finalstr =  'Id,Comments__c, Fcst_Fiscal_Period__c,FCST_Planning_Version__c,Fcst_Q__c ,Fcst_Weighted_Revenue__c ,Fcst_Opportunity__c ,User_Adjusted_Revenue__c\n';
                for(FCST_Opportunity_Initial_Forecast__c a:OppInitialForecast){
                    string recordString = a.id+',' +a.Comments__c+ ',' +a.Fcst_Fiscal_Period__c+',' +a.FCST_Planning_Version__c+',' +a.Fcst_Q__c+',' +a.Fcst_Weighted_Revenue__c+',' +a.Fcst_Opportunity__c+','+a.User_Adjusted_Revenue__c+'\n';
                    finalstr = finalstr +recordString; 
                }
              // System.debug('finalstr'+finalstr);
                sendErrorTemplate(lstUserIds,strBody,finalstr);

        }
          
     }
     public void sendErrorTemplate(List<Id> lstUserIds, String strMessage,String finalstr){
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
          
            mail.setToAddresses(lstUserIds);
            mail.subject = 'PM Forecast models Errror records | '+DateTime.now();
            mail.setPlainTextBody(strMessage);
         	//	System.debug('strMessage'+strMessage);
                 Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                    attach.setBody(Blob.valueOf(finalstr));
                    attach.setFileName('ErrorFile.csv');
                    mail.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});
        // Send the email you have created.
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

    }
}