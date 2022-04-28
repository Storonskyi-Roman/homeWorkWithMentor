public class ContactTroggerHandler extends TriggerHandler{

    private list<id> programIds = new list<id>();
    private Map <ID,Program__c> names = new Map<ID,Program__c>();

    public ContactTroggerHandler() {
        for (Contact i : (List<Contact>)Trigger.New){
            programIds.add(i.Current_Program__c);
        }
        names.putAll([SELECT id, name FROM Program__c WHERE id IN :programIds]);

    }

    public override void beforeInsert(){
        for(Contact con : (List<Contact>)Trigger.New){
            con.Current_Program_Name__c = names.get(con.Current_Program__c).name;
        }
    }

    public override void beforeUpdate(){
        for (Contact con : (List<Contact>)Trigger.New){
            //Contact con = (Contact)Trigger.oldMap.get(i.id);
            //System.debug(con.Current_Program__c + ' => ' + i.id);
            if(((Contact)trigger.oldMap.get(con.id)).Current_Program__c != con.Current_Program__c){
                con.Current_Program_Name__c = names.get(con.Current_Program__c).name;
            }
        }
    }
}
