public class IntakeTriggerHandler extends TriggerHandler {

    public override void afterInsert(){
        createMembers();
    }

    public void createMembers(){
        List<Intake_Member__c> membersToInsert = new List<Intake_Member__c>();
        List<Intake__c> intakes = [SELECT Contact__r.Account.Id FROM Intake__c WHERE Contact__c != null AND Intake__c.Id IN :Trigger.newMap.keySet()];
        Set<Id> accId = new Set<Id>();
        for(Intake__c q : intakes){
            accId.add(q.Contact__r.Account.Id);
        }
        List<Contact> cons = [SELECT Id, Name, Age__c, SSN__c, Gender__c, (SELECT Id FROM Intakes__r WHERE Id IN :Trigger.newMap.keySet() LIMIT 1) FROM Contact WHERE AccountId IN :accId];
        for(Contact con : cons){
            Intake_Member__c intakeMember = new Intake_Member__c();
            intakeMember.Contact__c = con.Id;
            intakeMember.Age__c = con.Age__c;
            intakeMember.SSN__c = con.SSN__c;
            intakeMember.Gender__c = con.Gender__c;
            intakeMember.Name = con.Name;
            if(!con.Intakes__r.isEmpty()){
                System.debug(con.Intakes__r);
                intakeMember.Intake__c = con.Intakes__r[0].Id;
            }
            membersToInsert.add(intakeMember);
        }
        insert membersToInsert;
    }
}
