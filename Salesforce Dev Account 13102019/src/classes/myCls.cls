public class myCls {
   static final Integer PRIVATE_INT_CONST = 200;
   static final Integer PRIVATE_INT_CONST2; 

   public static Integer calculate() {
       return 2 + 7;
   }
   static {
       PRIVATE_INT_CONST2 = calculate();
   }
}