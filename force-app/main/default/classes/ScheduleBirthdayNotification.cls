public with sharing class ScheduleBirthdayNotification implements Schedulable{

    //public static String CRON_EXP = '0 0 10 1/1 * ? *';

    public void execute(SchedulableContext SC){
        ScheduledNotificationBatch BirthdayNotification = new ScheduledNotificationBatch();
        Id batchId = Database.executeBatch(BirthdayNotification);
    }
}
