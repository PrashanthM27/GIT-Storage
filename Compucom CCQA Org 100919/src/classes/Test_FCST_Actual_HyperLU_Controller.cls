@istest
public class Test_FCST_Actual_HyperLU_Controller {
    static testMethod void Test_Actual(){
        FCST_Actual_HyperLinkUpload_Controller actualCont = new FCST_Actual_HyperLinkUpload_Controller();
        actualCont.onChangeYear();
        actualCont.updateWrapperList();
        actualCont.getFilterPlanningYear();
        actualCont.getMonthName();
        actualCont.gotohomepage();
        actualCont.callBatchClass();
    }
}