@isTest
public class Test_TVRemoteControl {
    static testMethod void getRemoteData(){
         integer num=5;
        integer amt=23423;
        TVRemoteControl ctl = new TVRemoteControl(num);
        ctl.increaseVolume(amt);
        ctl.decreaseVolume(amt);
    }
        static testMethod void getRemData(){
        integer num=5;
        TVRemoteControl ctl = new TVRemoteControl(num);
        String str = TVRemoteControl.getMenuOptions();
        System.assertNotEquals(null,str);
        System.assertNotEquals('' ,null);
        }
    }