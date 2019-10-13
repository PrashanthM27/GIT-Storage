@istest
public class Test_VisibleSampleClass {
    static testMethod void getSampleData(){
        String stName='Raj';
        String phNUm = '23232';
        VisibleSampleClass vsc = new VisibleSampleClass();
        vsc.publicMethod();
        VisibleSampleClass.Employee emp = new VisibleSampleClass.Employee(stName,phNum);
        vsc.privateMethod(emp);
    }
        /*static testMethod void getExceptionData(){
            {
                throw new VisibleSampleClass.MyException(Exception e);
            }catch(VisibleSampleClass.MyException e){
                
            }
            }*/
        }