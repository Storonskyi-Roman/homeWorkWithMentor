public class ContactTriggerHandler extends TriggerHandler{
    
    public override void beforeInsert(){
        changePragramNameField();
    }

    public override void beforeUpdate(){
        changePragramNameField();
    }

    public void changePragramNameField(){
        List<Id> programIds = new List<Id>();
        Map <ID,Program__c> programNames = new Map<ID,Program__c>();

        for (Contact i : (List<Contact>)Trigger.New){
            programIds.add(i.Current_Program__c);
        }
        programNames.putAll([SELECT Id, Name FROM Program__c WHERE Id IN :programIds]);

        for (Contact con : (List<Contact>)Trigger.New){
            if(Trigger.isUpdate){
                if(((Contact)trigger.oldMap.get(con.Id)).Current_Program__c != con.Current_Program__c){
                    con.Current_Program_Name__c = programNames.get(con.Current_Program__c).name;
                }
            }
            if(Trigger.isInsert){
                con.Current_Program_Name__c = programNames.get(con.Current_Program__c).name;
            }
        }
    }
}




        