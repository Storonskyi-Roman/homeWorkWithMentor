public class AccountTriggerHandler extends TriggerHandler {

    public override void afterInsert(){
        CreateRelatedOpp();
    }

    public override void beforeUpdate(){
        CheckRelatedOpp();
    }

    public override void beforeDelete(){
        DeleteRelatedOpp();
    }

    public void CreateRelatedOpp(){
        List<Opportunity> relatedOpportunities = new List<Opportunity>();
        for(Account acc :(List<Account>)Trigger.New) {
            relatedOpportunities.add(new Opportunity(Name = acc.Name + Date.Today().Month() + Date.Today().Year() ,
                                    StageName = 'Prospecting', Closedate = Date.Today().addDays(90), AccountId = acc.Id));
        }
        insert relatedOpportunities;
    }

    public void CheckRelatedOpp(){

    }

    public void DeleteRelatedOpp(){
        List<Opportunity> OppsToDelete = new List<Opportunity>();
        List<Messaging.SingleEmailMessage> mailsToSend = new List<Messaging.SingleEmailMessage>();

        for (Account acc : [SELECT id, Name, (SELECT id, Name, Amount FROM Opportunities) FROM Account WHERE id IN :Trigger.Old]){
            string massage = 'Hi' + UserInfo.getUserName() + '\n Due to deletion of Account' + acc.Name + 'all next related Opportunities were deleted as well:';
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
