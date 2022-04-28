@isTest
public with sharing class ContactTriggerTest {
    @isTest
    public static void ContactTriggerTestInsert() {
        
        List<Program__c> progs = new List<Program__c>();
        for(Integer i =100; i < 301; i++){
            progs.add(new program__c(Name = 'test' + i));
        }
        insert progs;
        Test.startTest();
        List<Contact> cons = new List<Contact>();
        for(Integer i =100; i < 301; i++){
            cons.add(new Contact(LastName = '' + i, Current_Program__c = progs[i-100].id));
        }
        insert cons;
        Test.stopTest();
        
        List<Contact> consEnd = new List<Contact>([SELECT name, Current_Program_Name__c FROM Contact ORDER BY name]);
        System.debug(consEnd);
        Integer i = 100;
        for(Contact con :consEnd){
            System.debug('test' + i + '==>' + con.Current_Program_Name__c);
            System.assertEquals('test' + i, con.Current_Program_Name__c);
            i++;
        }

    }
    @isTest
    public static void ContactTriggerTestUpdate() {
        
        List<Program__c> progs = new List<Program__c>();
        for(Integer i =0; i < 200; i++){
            progs.add(new program__c(name = 'test' +i));
        }
        insert progs;
        List<Contact> cons = new List<Contact>();
        for(Integer i =0; i < 200; i++){
            cons.add(new Contact(LastName = 'test' + i, Current_Program__c = progs[i].id));
        }
        insert cons;
        Test.startTest();
        List<Contact> consAfterInsert = [SELECT name, Current_Program__c FROM Contact ORDER BY name];
        for(Integer i = 0; i < 200; i++){
            consAfterInsert[i].Current_Program__c = progs[199-i].id;
            
        }
        update consAfterInsert;
        Test.stopTest();
        List<Contact> consEnd = new List<Contact>([SELECT name, Current_Program_Name__c FROM Contact ORDER BY name]);
        System.debug(consEnd);
        Integer i = consEnd.size();
        for(Contact con :consEnd){
            System.debug('test' + (i-1) + '==>' + con.Current_Program_Name__c);
            System.assertEquals('test' + (i-1), con.Current_Program_Name__c);
            i--;
        }   
    }
}
