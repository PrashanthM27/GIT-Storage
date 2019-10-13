@isTest
private class TemperatureConverterTest{
static testMethod void Save(){
Decimal tc=TemperatureConverter.FahrenheitToCelcius(80);
System.assertEquals(26.67,tc);
}
static testmethod void TempToCel(){
Decimal dc=TemperatureConverter.FahrenheitToCelcius(90);
System.assertEquals(32.22,dc);
}
static testmethod void TempConv(){
Decimal tct=TemperatureConverter.FahrenheitToCelcius(240);
System.assertEquals(115.56,tct,'This is boiling water');
}
}