global class CallBatchApexonButtonClick{
webservice static void Submit(Id localId){
Approval.ProcessSubmitRequest req=new Approval.ProcessSubmitRequest();
req.setComments('Submitted for approval');
req.setObjectId(localId);
Approval.ProcessResult res=Approval.Process(req);
}
}