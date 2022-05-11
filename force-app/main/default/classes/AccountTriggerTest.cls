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
    public static void TestUpdateRelatedOpp(){
        List<Account> accounts = new List<Account>([SELECT Id, Name, CreatedDate, (SELECT Id, Name FROM Opportunities) FROM Account]);
        Test.startTest();
        Integer i = 0;
        for(Account acc : accounts){
            for(Opportunity opp : acc.Opportunities){
                System.assertEquals(acc.Name + acc.CreatedDate.Month() + acc.CreatedDate.Year(), opp.Name, 'Opp name befor Update is correct');
            }
            acc.Name = '1' + acc.Name;
        }
        update accounts;
        Test.stopTest();
        accounts = [SELECT Id, Name, CreatedDate, (SELECT Id, Name FROM Opportunities) FROM Account];
        for(Account acc : accounts){
            for(Opportunity opp : acc.Opportunities){
                System.assertEquals(acc.Name + acc.CreatedDate.Month() + acc.CreatedDate.Year(), opp.Name, 'Opp name after Update is correct');
            }
        }

    }

    @isTest
    public static void TestDeleteRelatedOpp(){
        List<Account> accounts = new List<Account>([SELECT Id FROM Account]);
        List<Opportunity> relatedOpportunities = new List<Opportunity>([SELECT Id FROM Opportunity]);
        System.assertEquals(10, relatedOpportunities.size(), 'Opportunities are created');
        Test.startTest();
        delete accounts;
        Test.stopTest();
        relatedOpportunities = [SELECT Id FROM Opportunity];
        System.assertEquals(0, relatedOpportunities.size(), 'Opportunities are deleted');
    }
}
