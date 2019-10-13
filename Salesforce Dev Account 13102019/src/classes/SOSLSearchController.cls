/*public class SOSLController {  
  
    public static List < List < SObject > > searchAccountContactLead( String strSearch ) {  
      
        String searchQuery = 'FIND \'' + strSearch + '*\' IN ALL FIELDS RETURNING Account( Id, Name WHERE Industry = \'Apparel\' ), Contact, Lead';   
        return search.query( searchQuery );  */
      
        public class SOSLSearchController {
 
    public List<List<SObject>> Search(String strSearch){
        String searchQuery= 'FIND\''+strSearch+'*\' IN ALL WORDS RETURNING ACCOUNT(ID,NAME,INDUSTRY WHERE INDUSTRY=\'BANKING\'),CONTACT';
        System.debug('searchQuery');
        return search.query(searchQuery);
      }
}