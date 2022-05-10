@isTest
public with sharing class AccountTriggerTest {
    @TestSetup
    static void createAccounts(){
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < 10; i++){
            accounts.add(new Account(Name = 'Test' + i));
        }
        insert accounts;
    }
    @isTest
    public static void TestCreateRelatedOpp(){
        List<Opportunity> relatedOpportunities = new List<Opportunity>([SELECT Id FROM Opportunity]);
        System.assertEquals(10, relatedOpportunities.size(), 'Opportunities are created');
    }


    @isTest
    public static void TestDeleteRelatedOpp(){
        List<Account> accounts = new List<Account>([SELECT id FROM Account]);
        List<Opportunity> relatedOpportunities = new List<Opportunity>([SELECT Id FROM Opportunity]);
        System.assertEquals(10, relatedOpportunities.size(), 'Opportunities are created');
        Test.startTest();
        delete accounts;
        Test.stopTest();
        relatedOpportunities = [SELECT Id FROM Opportunity];
        System.assertEquals(0, relatedOpportunities.size(), 'Opportunities are deleted');
    }
}
