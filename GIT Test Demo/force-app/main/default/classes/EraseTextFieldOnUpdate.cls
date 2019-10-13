public class EraseTextFieldOnUpdate {
    public static void checkForRequiredField(List<Contact> reqCont){
        for(Contact ld:reqCont){
            if(String.isBlank(ld.LastName)){
                ld.addError('Contact LastName is required');
            }
        }
    }
    public static void EmptyRequiredField(List<Contact> emptyCont){
        for(Contact cont:emptyCont){
            if(!String.isBlank(cont.LastName)){
                cont.LastName = '';
            }
        }
    }
}