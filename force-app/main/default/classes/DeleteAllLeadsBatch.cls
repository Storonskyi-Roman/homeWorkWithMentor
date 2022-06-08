public class DeleteAllLeadsBatch implements Database.Batchable<sObject>{
   
    

    public Database.QueryLocator  start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id FROM Lead Where Rating = \'Cold\'');
    }

    public void execute(Database.BatchableContext bc, List<Lead> records){
        delete records;
    }
    
    public void finish(Database.BatchableContext bc){
        System.debug('Batch is done!' + UserInfo.getUserEmail());
        //send email to UserInfo.getUserEmail()
    }
}
