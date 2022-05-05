public class ScheduledNotificationBatch implements Database.Batchable<sObject>, Database.stateful {
    
    private string linkStart = 'https://redtag107-dev-ed.lightning.force.com/lightning/r/Contact/';
    @TestVisible public static Integer emailLimits;

    public Database.QueryLocator  start(Database.BatchableContext bc) {
        string threeMonthAgo = ('' + date.today().addYears(-18).addMonths(3)).substring(0,10);
        string query =  'SELECT Id, Name, Birthdate, OwnerId FROM Contact WHERE Birthdate = ' + threeMonthAgo;
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Contact> records){
        Map<Id, List<Contact>> ownerIdMap = new Map<Id, List<Contact>>();
        for(Contact con : records) {
            if(ownerIdMap.containsKey(con.OwnerId)) {
                List<Contact> consToPut = ownerIdMap.get(con.OwnerId);
                consToPut.add(con);
                ownerIdMap.put(con.OwnerId, consToPut);
            } else {
                ownerIdMap.put(con.OwnerId, new List<Contact> { con });
            }
        }

        List<User> owners = new List<User>([SELECT Id, email FROM User WHERE Id IN :ownerIdMap.keySet()]);

        for(User owner : owners){
            string massageBody = '<p>Here is a list of contacts turning 18 in 3 month:</p>';
            for(Contact con : ownerIdMap.get(owner.Id)){
                massageBody +=  '<p><a href = \'' + linkStart +con.Id +'/view\'>' + con.Name + '</a> - ' + con.Birthdate + '</p>';
                //{Contact.Name (link to Contact)} - {Contact.Birthdate}
            }

            list<String> mailAdress= new list<string>{owner.email};
            Messaging.SingleEmailMessage mailToSend = new Messaging.SingleEmailMessage();
            mailToSend.setToAddresses(mailAdress);
            mailToSend.Subject = 'Contacts Turning 18';
            mailToSend.setHtmlBody(massageBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mailToSend });
            ScheduledNotificationBatch.emailLimits = Limits.getEmailInvocations();
        }  
    }

    public void finish(Database.BatchableContext bc){
            list<String> mailAdress= new list<string>{UserInfo.getUserEmail()};
            Messaging.SingleEmailMessage mailToSend = new Messaging.SingleEmailMessage();
            mailToSend.setToAddresses(mailAdress);
            mailToSend.Subject = 'ScheduledNotificationBatch done';
            mailToSend.setHtmlBody('Job is done!');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mailToSend });
            ScheduledNotificationBatch.emailLimits = Limits.getEmailInvocations();
    }
}