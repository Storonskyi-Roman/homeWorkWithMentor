@isTest
public class ServicesListControllerTest {

    @TestSetup
    static void makeData(){
        Program__c prog = new program__c(Name = 'testProgram');
        insert prog;
        Contact con = new Contact(LastName = 'test', Current_Program__c = prog.Id);
        insert con;
        Id recordTypeId = Schema.SObjectType.Service__c.getRecordTypeInfosByDeveloperName().get('Education_Note').getRecordTypeId();
        Service__c serv = new Service__c(Name = 'testServ', Contact__c = con.Id, RecordTypeId = recordTypeId);
        insert serv;
    }
    @IsTest
    static void inputOutputServises(){
        Id recordTypeId = Schema.SObjectType.Service__c.getRecordTypeInfosByDeveloperName().get('Education_Note').getRecordTypeId();
        Contact con = [SELECT id FROM Contact LIMIT 1][0];

        PageReference conPage = new ApexPages.StandardController(con).view();
        Test.setCurrentPage(conPage);
        ApexPages.currentPage().getParameters().put('id',con.Id);

        Test.startTest();

        ServicesListController serviceInputData = new ServicesListController();
        serviceInputData.recordType = string.valueOf(recordTypeId);
        pageReference afterGeneratePDF = serviceInputData.generatePDF();
        Test.setCurrentPage(afterGeneratePDF);
        Set<Id> idsForServises = ServicesListController.getServices();

        Test.stopTest();
        System.assertEquals(1, idsForServises.size(), 'added one service to pdf');
    }

    @IsTest
    static void getTypeItemsTest(){
        ServicesListController qqq = new ServicesListController();
        List<Selectoption> res = qqq.getTypeItems();

        String eduRecordType =String.valueOf(Schema.SObjectType.Service__c.getRecordTypeInfosByDeveloperName().get('Education_Note').getRecordTypeId());
        System.assertEquals(eduRecordType, res[0].getValue(), 'right recordtype was added');
    }
}


