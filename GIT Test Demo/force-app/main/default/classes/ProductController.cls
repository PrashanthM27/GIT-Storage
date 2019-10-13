public class ProductController {
    
    @AuraEnabled
    public static List<Product2> returnCodes(){
      List<Product2> prdList = [SELECT Id,NAME,PRODUCTCODE FROM PRODUCT2];
        System.debug('===>>'+prdList);
        return prdList;
    }
}