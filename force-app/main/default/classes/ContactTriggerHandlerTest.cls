@isTest
public with sharing class ContactTriggerHandlerTest {

    @testSetup
    public static void setup() {
        List<Program__c> progs = new List<Program__c>();
        for(Integer i =100; i < 300; i++){
            progs.add(new program__c(Name = 'test' + i));
        }
        insert progs;
        List<Contact> cons = new List<Contact>();
        for(Integer i =100; i < 300; i++){
            cons.add(new Contact(LastName = '' + i, Current_Program__c = progs[i-100].id));
        }
        insert cons;
    }

    @isTest
    public static void insertProgramNameFieldTest() {
        Test.startTest();

        Test.stopTest();
        
        List<Contact> consEnd = new List<Contact>([SELECT name, Current_Program_Name__c FROM Contact ORDER BY name]);
        Integer i = 100;
        for(Contact con :consEnd){
            System.assertEquals('test' + i, con.Current_Program_Name__c, 'Current Program Name should match');
            i++;
        }

    }
    @isTest
    public static void updatePragramNameFieldTest() {
        Test.startTest();
        List<Contact> consAfterInsert = [SELECT name, Current_Program__c FROM Contact ORDER BY name];
        List<Program__c> progs = [SELECT name FROM Program__c ORDER BY name];
        for(Integer i = 0; i < 200; i++){
            consAfterInsert[i].Current_Program__c = progs[199-i].id;
            
        }
        update consAfterInsert;
        Test.stopTest();

        List<Contact> consEnd = new List<Contact>([SELECT name, Current_Program_Name__c FROM Contact ORDER BY name]);
        Integer i = consEnd.size()+99;
        for(Contact con :consEnd){
            System.debug(con);
            System.assertEquals('test' + i, con.Current_Program_Name__c, 'Current Program Name should match');
            i--;
        }   
    }
}
