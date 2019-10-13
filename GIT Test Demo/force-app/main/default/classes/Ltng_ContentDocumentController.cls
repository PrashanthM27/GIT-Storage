public class Ltng_ContentDocumentController {
@AuraEnabled
    public static List<ContentDocument> getContDocument(){
     return [Select Id,Title,FileType,CreatedBy.Name,ContentSize from ContentDocument];
    }
}