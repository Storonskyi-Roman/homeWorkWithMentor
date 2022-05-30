@isTest
public class ScheduledWeatherUpdateTest {
    @TestSetup
    static void makeData(){
        Weather__c Weather = new Weather__c(City_Name__c = 'Lviv', Name = 'Lviv Weather');
        insert Weather;
    }

    @isTest
    public static void WeatherBatchTest(){
        Test.setMock(HttpCalloutMock.class, new BatchSyncMock());
        Test.startTest();
        ScheduledWeatherUpdate m = new ScheduledWeatherUpdate();
        String sch = '0 0 0 ? * * 2045';
        String jobID = system.schedule('Merge Job', sch, m);
        m.execute(null);
        Test.stopTest();
        System.debug([SELECT Temperature__c, City_Name__c FROM Weather__c]);
        System.assertNotEquals(null, [SELECT Temperature__c FROM Weather__c].Temperature__c, 'Data was successfully updated');
    }
}
