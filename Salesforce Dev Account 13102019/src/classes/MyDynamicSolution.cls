public class MyDynamicSolution {
    @future
    public static void updateOwner(List<ID> objIds, ID newOwnerId) {
        // Validate input
        System.assert(objIds != null);
        System.assert(objIds.size() > 0);
        System.assert(newOwnerId!= null);
        
        // Get the sObject token from the first ID
        // (the List contains IDs of sObjects of the same type).
        Schema.SObjectType token = objIds[0].getSObjectType();
        
        // Using the token, do a describe 
        // and construct a query dynamically. 
        Schema.DescribeSObjectResult dr = token.getDescribe();
        String queryString = 'SELECT ownerId FROM ' + dr.getName() + 
            ' WHERE ';
        for(ID objId : objIds) {
            queryString += 'Id=\'' + objId + '\' OR ';
        }    
        // Remove the last ' OR'
        queryString = queryString.subString(0, queryString.length() - 4);

        sObject[] objDBList = Database.query(queryString);
        System.assert(objDBList.size() > 0);
        
        // Update the owner ID on the sObjects
        for(Integer i=0;i<objDBList.size();i++) {
            objDBList[i].put('ownerId', newOwnerId);
        }        
        Database.SaveResult[] srList = Database.update(objDBList, false);
        for(Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                System.debug('Updated owner ID successfully for ' + 
                    dr.getName() + ' ID ' + sr.getId());
            }
            else {
                System.debug('Updating ' + dr.getName() + ' returned the following errors.');
                for(Database.Error e : sr.getErrors()) {
                    System.debug(e.getMessage());
                }
            }
        }
    }
}