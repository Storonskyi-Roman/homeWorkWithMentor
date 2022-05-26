@isTest
public class ServiceTriggerHandlerTest {

    @TestSetup
    static void makeData(){
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Id RoleId = [SELECT Id FROM UserRole WHERE DeveloperName = 'Kyiv_Director' LIMIT 1].Id;
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard Platform User Extended'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                            EmailEncodingKey='UTF-8', LastName='Kyiv_Director', LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = RoleId, 
                            TimeZoneSidKey='America/Los_Angeles',
                            UserName=uniqueUserName); 
        insert u;
    }


    @isTest
    public static void sharingSetupTest(){
        /*
        *   [SELECT Id FROM UserRole WHERE DeveloperName = 'Lviv_Education_Manager']
        *   [SELECT Id FROM UserRole WHERE DeveloperName = 'Lviv_Director']
        *   [SELECT Id FROM UserRole WHERE DeveloperName = 'Kyiv_Director']
        *   [SELECT Id FROM UserRole WHERE DeveloperName = 'Odesa_Director']
        *   [SELECT Id FROM UserRole WHERE DeveloperName = 'Director']
        */
        List<UserRole> RoleIdList =new List<UserRole>([SELECT Id FROM UserRole
                                    WHERE DeveloperName = 'Lviv_Education_Manager' OR
                                    DeveloperName = 'Lviv_Director' OR
                                    DeveloperName = 'Kyiv_Director' OR
                                    DeveloperName = 'Odesa_Director' OR
                                    DeveloperName = 'Director']);
        List<User> users = [SELECT Id, Name, UserRole.DeveloperName FROM User WHERE IsActive = true AND UserRoleId = :RoleIdList];
        Map<String,User> usersMap = new Map<String,User>();
        for(User u :users){
            usersMap.put(u.UserRole.DeveloperName, u);
        }

        //run as Lviv_Director
        System.runAs(usersMap.get('Lviv_Director')){
            Service__c serv = new Service__c(Name = 'Lviv_Director');
            insert serv;
            System.assertEquals(1, [SELECT Id FROM Service__c].size(), 'number of services visible for Lviv Director 1');
        }

        //run as Lviv_Education_Manager
        System.runAs(usersMap.get('Lviv_Education_Manager')){
            Service__c serv = new Service__c(Name = 'Lviv_Education_Manager');
            insert serv;
            System.assertEquals(2, [SELECT Id FROM Service__c].size(), 'number of services visible for Lviv Manager 2');
        }      
        
        
        //run as Kyiv_Director
        System.runAs(usersMap.get('Kyiv_Director')){
            Service__c serv = new Service__c(Name = 'Kyiv_Director', City__c = 'Odesa');
            insert serv;
            System.assertEquals(1, [SELECT Id FROM Service__c].size(), 'number of services visible for Kyiv Director 1');
        }
        //run as Odesa_Director
        System.runAs(usersMap.get('Odesa_Director')){
            Service__c serv = new Service__c(Name = 'Odesa_Director', City__c = 'Odesa');
            insert serv;
            System.assertEquals(2, [SELECT Id FROM Service__c].size(), 'number of services visible for Odesa Director 1');
        }
        //run as Director
        System.runAs(usersMap.get('Director')){
            Service__c serv = new Service__c(Name = 'Director');
            insert serv;
            System.assertEquals(5, [SELECT Id FROM Service__c].size(), 'number of services visible for Director 4');
        }
        
        
    }
}
