@isTest
public class AccountWeatherControllerTest {
    @TestSetup
    static void makeData(){
        Account acc = new Account(BillingCity = 'Lviv', Name ='TestUpdate');
        insert acc;
        Weather__c Weather = new Weather__c(City_Name__c = 'Lviv', Name = 'Lviv Weather');
    }
    @isTest
    public static void GetWeatherTest(){
        Weather__c Weather = AccountWeatherController.getWeather([SELECT Id FROM Account LIMIT 1].Id);
        System.assertNotEquals(null, Weather.Id, 'The Weather was returned');
    }

}
