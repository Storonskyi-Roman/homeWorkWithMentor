@isTest
public with sharing class ScheduledNotificationBatchTest {
    @testSetup
    static void Setup(){
        Program__c prog = new Program__c(Name = 'test');
        insert prog;
        List<Contact> cons = new List<Contact>();
        for (Integer i = 0; i < 100; i++){
            cons.add(new Contact(Lastname = 'Test' + i, Birthdate = date.today().addYears(-18).addMonths(3), Current_Program__c = prog.id));
        }
        insert cons;
    }
    
    @isTest
    public static void NotificationBatchTest() {
        Test.startTest();
        System.assertEquals(0, Limits.getEmailInvocations(), 'Email should be not sent');
        ScheduledNotificationBatch BirthdayNotification = new ScheduledNotificationBatch();
        Id batchId = Database.executeBatch(BirthdayNotification);

        //System.assertEquals(1, BirthdayNotification.emailLimits, 'Email should be sent');
        Test.stopTest();
        
    }
}
