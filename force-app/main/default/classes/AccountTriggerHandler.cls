public class AccountTriggerHandler extends TriggerHandler {

    public override void afterInsert(){
        createRelatedOpp();
    }

    public override void beforeUpdate(){
        checkRelatedOpp();
    }

    public override void beforeDelete(){
        deleteRelatedOpp();
    }

    public void createRelatedOpp(){
        List<Opportunity> relatedOpportunities = new List<Opportunity>();
        for(Account acc :(List<Account>)Trigger.New) {
            relatedOpportunities.add(new Opportunity(Name = acc.Name + Date.Today().Month() + Date.Today().Year() ,
                                    StageName = 'Prospecting', Closedate = Date.Today().addDays(90), AccountId = acc.Id));
        }
        insert relatedOpportunities;
    }

    public void checkRelatedOpp(){

        Map<Id, Account> newMap = new Map<Id, Account>((Map<Id, Account>)Trigger.newMap);
        Map<Id, Account> oldMap = new Map<Id, Account>((Map<Id, Account>)Trigger.oldMap);
        List<Account> accounts = [SELECT Id, Name, (SELECT Id, Name FROM Opportunities) FROM Account WHERE Id IN :newMap.keySet()];

        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        for(Account acc : accounts){
            if(oldMap.get(acc.Id).Name != newMap.get(acc.Id).Name){
                for(Opportunity relatedOpp : acc.Opportunities){
                    if(relatedOpp.Name.contains(acc.Name)){
                        relatedOpp.Name = RelatedOpp.Name.replace(acc.Name, newMap.get(acc.Id).Name);
                        oppsToUpdate.add(RelatedOpp);
                    }
                }
            }
        }
        update oppsToUpdate;
    }

    public void deleteRelatedOpp(){
        List<Opportunity> OppsToDelete = new List<Opportunity>();
        List<Messaging.SingleEmailMessage> mailsToSend = new List<Messaging.SingleEmailMessage>();

        for (Account acc : [SELECT Id, Name, (SELECT Id, Name, Amount FROM Opportunities) FROM Account WHERE Id IN :Trigger.OldMap.keySet()]){
            string massage = 'Hi ' + UserInfo.getUserName() + '\nDue to deletion of Account ' + acc.Name + ' all next related Opportunities were deleted as well: \n';
            Integer i = 1;
            for(Opportunity opp : acc.Opportunities){
                OppsToDelete.add(opp);
                massage += i++ + '. ' + opp.Id + ', ' + opp.Name + ', ' + opp.Amount + '\n';
            }
            massage += 'Best regards,\nRed Tag Service Team.';
            list<String> mailAdress= new list<string>{UserInfo.getUserEmail()};
            Messaging.SingleEmailMessage mailToCurrentOwner = new Messaging.SingleEmailMessage();
            mailToCurrentOwner.setToAddresses(mailAdress);
            mailToCurrentOwner.Subject = 'Account ' + acc.Name + ' is deleted.';
            mailToCurrentOwner.setPlainTextBody(massage);
            mailsToSend.add(mailToCurrentOwner);
        }
        Messaging.sendEmail(mailsToSend);
        delete OppsToDelete;
    }

}
