@isTest
public class IntakeTriggerHandlerTest {
    @TestSetup
    static void makeData(){
        Account acc = new Account(Name = 'testAcc');
        insert acc;
        List<Contact> cons = new List<Contact>();
        for(Integer i = 1; i < 3; i++){
            Contact con = new Contact(LastName = 'test' + i, AccountId = acc.Id, Gender__c = 'Male', SSN__c = '1234567890A');
            cons.add(con);
        }
        insert cons;
    }
    @isTest
    public static void MemberCreateTest(){
        Contact con = [SELECT Id FROM Contact LIMIT 1];
        Intake__c intake = new Intake__c(Name = 'IntakeTest', Contact__c = con.Id);
        System.assertEquals(true, [SELECT Id FROM Intake_Member__c].isEmpty());
        insert intake;
        System.assertEquals(2, [SELECT Id FROM Intake_Member__c].size());
    }
}
