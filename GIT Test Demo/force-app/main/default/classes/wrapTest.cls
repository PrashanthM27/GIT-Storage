public class wrapTest{

   public wrapTest(){
   }
   
   List<Contact> contacts = [select FirstName,LastName,Phone,Email from Contact];
   Set<Employee> employees =new Set<Employee>();
   
   public void myMethod(){
       for(Contact c : contacts ){
            Employee e =new Employee();
            e.LastName=c.LastName;
            e.firstName=c.firstName;
            e.Phone=c.Phone;
            e.Email =c.Email;
            employees.add(e);
        
       }
   }
   
   
   public class Employee {
        public String lastName;
        public String firstName;
        public String phone;
        public String email;
   }
        
}