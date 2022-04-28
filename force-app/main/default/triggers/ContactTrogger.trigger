trigger ContactTrogger on Contact (before insert, before update) {

    new ContactTroggerHandler().run();

    /*list<id> ptr= new list<id>();
    for (Contact i : Trigger.New){
        ptr.add(i.Current_Program__c);
    }

    List<Program__c> ls = [SELECT id, name FROM Program__c WHERE id IN :ptr];
    Map <ID,Program__c> names = new Map<ID,Program__c>(ls);
 
    for(Contact con : Trigger.New){

        con.Current_Program_Name__c = names.get(con.Current_Program__c).name;

    }*/
    
}