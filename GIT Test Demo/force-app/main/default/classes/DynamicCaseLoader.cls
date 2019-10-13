public class DynamicCaseLoader {

    public final Case caseDetails { get; private set; }

   
    public DynamicCaseLoader(ApexPages.StandardController controller) {
        String qid = ApexPages.currentPage().getParameters().get('id');
        String theQuery = 'SELECT Id, ' + joinList(caseFieldList, ', ') + 
                          ' FROM Case WHERE Id = :qid';
        this.caseDetails = Database.query(theQuery);
    }

    
    public List<String> caseFieldList { 
        get {
            if (caseFieldList == null) {
                caseFieldList = new List<String>();
                caseFieldList.add('CaseNumber');
                caseFieldList.add('Origin');
                caseFieldList.add('Status');
                caseFieldList.add('Contact.Name');  
                caseFieldList.add('Contact.Email'); 
                caseFieldList.add('Contact.Phone'); 
            }
            return caseFieldList;
        }
        private set;
    }
     public static String joinList(List<String> theList, String separator) {

        if (theList == null) {
            return null;
        }
        if (separator == null) {
            separator = '';
        }

        String joined = '';
        Boolean firstItem = true;
        for (String item : theList) {
            if(null != item) {
                if(firstItem){
                    firstItem = false;
                }
                else {
                    joined += separator;               
                }
                joined += item;
            }
        }
        return joined;
    }
}