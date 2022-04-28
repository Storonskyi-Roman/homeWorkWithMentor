public class ContactTriggerHandler extends TriggerHandler{

    private List<Id> programIds = new List<Id>();
    private Map <ID,Program__c> programNames = new Map<ID,Program__c>();

    public ContactTriggerHandler() {
        for (Contact i : (List<Contact>)Trigger.New){
            programIds.add(i.Current_Program__c);
        }
        programNames.putAll([SELECT Id, Name FROM Program__c WHERE Id IN :programIds]);

    }
    
    public override void beforeInsert(){
        insertProgramNameField();
    }

    public override void beforeUpdate(){
        updatePragramNameField();
    }
    
    public void insertProgramNameField(){
        for(Contact con : (List<Contact>)Trigger.New){
            con.Current_Program_Name__c = programNames.get(con.Current_Program__c).name;
        }
    }

    public void updatePragramNameField(){
        for (Contact con : (List<Contact>)Trigger.New){
            if(((Contact)trigger.oldMap.get(con.Id)).Current_Program__c != con.Current_Program__c){
                con.Current_Program_Name__c = programNames.get(con.Current_Program__c).name;
            }
        }
    }
}




        