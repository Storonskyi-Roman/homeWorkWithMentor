public class ScheduledNotificationBatch implements Database.Batchable<sObject>, Database.stateful {
    private string massageBody = '<p>Here is a list of contacts turning 18 in 3 month:</p>';
    private string linkStart = 'https://redtag107-dev-ed.lightning.force.com/lightning/r/Contact/';

    public Database.QueryLocator  start(Database.BatchableContext bc) {
        string threeMonthAgo = (''+date.today().addYears(-18).addMonths(3));
        string threeMonthAgoPlusDay = (''+date.today().addYears(-18).addMonths(3).addDays(1)).substring(0,10);
        string query =  'SELECT id, name, Birthdate  FROM Contact WHERE OwnerId = \'' + UserInfo.getUserId() + '\' ' + 
                        + 'AND Birthdate >= ' + threeMonthAgo + ' AND Birthdate < ' + threeMonthAgoPlusDay;
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Contact> records){

        for(Contact con : records){
            massageBody +=  '<p><a href = \'' + linkStart +con.id +'/view\'>' + con.Name + '</a> - ' + con.Birthdate + '</p>';
        }
        //{Contact.Name (link to Contact)} - {Contact.Birthdate}
    }

    public void finish(Database.BatchableContext bc){
        list<String> mailAdress= new list<string>{UserInfo.getUserEmail()};
        Messaging.SingleEmailMessage mailToSend = new Messaging.SingleEmailMessage();
        mailToSend.setToAddresses(mailAdress);
        mailToSend.Subject = 'Contacts Turning 18';
        mailToSend.setHtmlBody(massageBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mailToSend });
    }
}