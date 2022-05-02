@isTest
public class ScheduleBirthdayNotificationTest {
    

    @isTest
    public static void ScheduleTest(){
        ScheduleBirthdayNotification reminder = new ScheduleBirthdayNotification();
        Test.startTest();
        String sch = '0 0 23 * * ?';
        String jobID = System.schedule('Birthday Notification', sch, reminder);
        List<CronTrigger> jobWaiting = [Select State From CronTrigger WHERE id = :jobID LIMIT 1];
        System.assertEquals(0, jobWaiting[0].TimesTriggered, 'Job is not starnet now');
        Test.stopTest();

    }
}
