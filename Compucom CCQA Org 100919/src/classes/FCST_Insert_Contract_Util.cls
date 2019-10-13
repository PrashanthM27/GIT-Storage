public with sharing class FCST_Insert_Contract_Util {
    
    public static void createContracts(list<Opportunity> oppList){
        try {
        Mapping_Setting__c mapCustomObj=Mapping_Setting__c.getValues('FCST Mapping Data');
        
        List<FCST_Contract__c> insertCOntractList =new List<FCST_Contract__c>();
        Map<Id,FCST_Contract__c> mapContarct= new Map<Id,FCST_Contract__c>();
        
        List<FCST_Contract__c> conlIst=[Select Opportunity__c,Id from FCST_Contract__c where Opportunity__c IN:oppList];
        if(conlIst!=null && conlIst.size()>0){
            for(FCST_Contract__c conObj:conlIst){
                mapContarct.put(conObj.Opportunity__c,conObj);
            }
        }
      
        
        List<String> geoIdList = new List<String>();
        if(oppList!=null && oppList.size()>0){
        	for(Opportunity oppObj:oppList){
		        if(mapCustomObj.Geo__c!=null && oppObj!=null){
		          String geoId = (String)oppObj.get(mapCustomObj.Geo__c);
		          geoIdList.add(geoId);
		        }
        	}
       
        }   
        Map<String,String> geoIdVsName = new Map<String,String>(); 
        if(geoIdList != null && geoIdList.size()>0){
            String geoquery = 'SELECT Id,Name FROM '+mapCustomObj.Geo__c+' Where id =: geoIdList ';
            List<SObject>  geoList = database.query(geoquery);
            
            if(geoList!=null && geoList.size()>0){
            	for(SObject sobj:geoList){
            		 String geoName = (String)sobj.get('Name');
            		geoIdVsName.put(String.ValueOf(sobj.Id),geoName);
            	}
            }
        }
                
        if(oppList!=null && oppList.size()>0){
            for(Opportunity oppObj:oppList){
                boolean havingContract=false;
                if(mapContarct.containsKey(oppObj.Id)){
                    havingContract=true;
                }
                if(havingContract==false){
                FCST_Contract__c conOnj =new FCST_Contract__c();
                
                String QhashNumber=(String) oppObj.get(mapCustomObj.Fcst_Q__c);
                
                String geonumber,geoname,geoId;
                if(mapCustomObj.Geo__c!=null && oppObj!=null){
		           geoId = (String)oppObj.get(mapCustomObj.Geo__c);
		        }
                                                    
                if(geoIdVsName.containskey(geoId)){
                	String geoNameNumber=geoIdVsName.get(geoId);
                	geonumber = geoNameNumber.SubStringBefore(' ');
            		geoname = geoNameNumber.substringAfter(' '); 
                }
                
                conOnj.Opportunity__c=oppObj.Id;
                if(oppObj.AccountId!=null)
                    conOnj.Fcst_Account__c=oppObj.AccountId;
                if(geoname!=null)   
                    conOnj.Fcst_Geo_Name__c=geoname;
                if(geonumber!=null && geonumber.isNumeric())
                    conOnj.Fcst_Geo_Numbers__c=geonumber;
                if(QhashNumber!=null)
                    conOnj.FCST_Q__c=QhashNumber;
                if(oppObj.CloseDate!=null)
                    conOnj.FCST_Contract_Created_Year__c=String.ValueOf(oppObj.CloseDate.year()); 
                if(oppObj.OwnerId!=null)
                //conOnj.Contract_Owner__c=oppObj.OwnerId;
                
                insertCOntractList.add(conOnj);
                
                }
            }
        }
        
        if(insertCOntractList!=null && insertCOntractList.size()>0)
            insert insertCOntractList;
            
            
          } 
         catch(Exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            System.debug('Line number: ' + e.getLineNumber()); 
         }
    }
    
    public static void updateCPMRegionOfContract(list<Opportunity> oppListval){
        try{
            Mapping_Setting__c mapCustomObj=Mapping_Setting__c.getValues('FCST Mapping Data');
            String geolableName='';
            if(mapCustomObj.Geo__c!=null){
                geolableName=mapCustomObj.Geo__c;
            }
            geolableName=geolableName.removeEnd('c')+'r';
                //  geolableName = (String)oppObj.get(mapCustomObj.Geo__c);
            String OppQuery='Select Id,'+geolableName+'.Name,(Select Id,Opportunity__c,Fcst_Geo_Name__c,Fcst_Geo_Numbers__c from FCST_Contracts__r) from Opportunity where Id IN:oppListval';
            
            List<FCST_Contract__c> updateContractList = new List<FCST_Contract__c>();
            
            List<Opportunity> oppList =database.query(OppQuery);
            
            if(oppList!=null && oppList.size()>0){
                for(Opportunity oppObj:oppList){
                    String geoFulName='',geonumber='',geoname='';
                    if(oppObj.getSObject(geolableName)!=null){
                     geoFulName = (String)oppObj.getSObject(geolableName).get('Name');
                    }
                    System.debug('geoFulName>>>>'+geoFulName);
                    if(geoFulName!=null){
                        geonumber = geoFulName.SubStringBefore(' ');
                        geoname = geoFulName.substringAfter(' '); 
                    }else{
                      System.debug('geoFulNameElse>>>>'+geoFulName);   
                    geonumber='';
                    geoname='';
                    }
                    for(FCST_Contract__c contractObj:oppObj.FCST_Contracts__r){
                        contractObj.Fcst_Geo_Numbers__c=geonumber;
                        contractObj.Fcst_Geo_Name__c=geoname;
                        updateContractList.add(contractObj);
                    }
                    
                }
            }
            if(updateContractList!=null && updateContractList.size()>0)
                update updateContractList;
            
        } 
         catch(Exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            System.debug('Line number: ' + e.getLineNumber()); 
         }
    }
    
}