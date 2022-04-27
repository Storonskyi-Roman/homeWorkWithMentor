@isTest
public with sharing class ProgramNameTest {
    @isTest
    public static void ProgramNameTestInsert() {
        
        List<Program__c> progs = new List<Program__c>();
        for(Integer i =0; i < 200; i++){
            progs.add(new program__c(name = 'test' +i));
        }
        insert progs;
        Test.startTest();
        List<Contact> cons = new List<Contact>();
        for(Integer i =0; i < 200; i++){
            cons.add(new Contact(LastName = 'test' + i, Current_Program__c = progs[i].id));
        }
        insert cons;
        Test.stopTest();
        
        System.assertEquals('test0',[SELECT name, Current_Program_Name__c FROM Contact WHERE Lastname = 'test0' LIMIT 1].Current_Program_Name__c);

    }
    @isTest
    public static void ProgramNameTestUpdate() {
        
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
        //system.debug(consAfterInsert[0]);
        update consAfterInsert;
        Test.stopTest();
        system.debug([SELECT name, Current_Program_Name__c FROM Contact WHERE Lastname = 'test0' LIMIT 1].Current_Program_Name__c);
        System.assertEquals('test199',[SELECT name, Current_Program_Name__c FROM Contact WHERE Lastname = 'test0' LIMIT 1].Current_Program_Name__c);
        
    }
}
