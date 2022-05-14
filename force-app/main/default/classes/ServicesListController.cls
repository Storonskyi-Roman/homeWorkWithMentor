public with sharing class ServicesListController {
    
    public String recordType {get;set;}
    public Date startDate {get;set;}
    public Date endDate {get;set;}   

    public static Set<Id> getServices() {
        
        Id recordTypeId = ApexPages.currentPage().getParameters().get('RecordType');
        System.debug(ApexPages.currentPage().getParameters().get('RecordType'));
        String startDate = ApexPages.currentPage().getParameters().get('StartDate');
        String endDate = ApexPages.currentPage().getParameters().get('EndDate');
        String contactId = ApexPages.currentPage().getParameters().get('ContactId');
        //Id recordTypeId = Schema.SObjectType.Service__c.getRecordTypeInfosByDeveloperName().get(recordType).getRecordTypeId();

        String query = 'SELECT Id FROM Service__c WHERE RecordTypeId = \'' + recordTypeId +
                        + '\' AND Contact__c = \'' + contactId + '\'';
        if (startDate != null) {
            query += 'AND Service_Date__c >= ' + startDate;
        }
        if(endDate != null){
            query += ' AND Service_Date__c <= ' + endDate;
        }
                        

        List<sObject> sObjList = Database.query(query);
        Map<Id,sObject> mapToGetIds = new Map<Id, sObject>(sObjList);

        return(mapToGetIds.keySet());
    }

    //by button click

    public pageReference generatePDF() {
        PageReference pageRef = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/ServicesList');
        pageRef.setRedirect(true);
        pageRef.getParameters().put('StartDate',String.valueOf(startDate));
        pageRef.getParameters().put('EndDate',String.valueOf(endDate));
        pageRef.getParameters().put('RecordType',recordType);
        System.debug(ApexPages.currentPage().getParameters().get('id'));
        pageRef.getParameters().put('ContactId', String.valueOf(ApexPages.currentPage().getParameters().get('id')));
        return pageRef;
    }

    public List<Selectoption> getTypeItems(){
        List<Selectoption> choiceSet = new List<selectoption>();
        Set<Id> recordTypeIds = new Set<Id>();
        for (Service__c s : [SELECT Id, recordTypeId FROM Service__c]){
            recordTypeIds.add(s.recordTypeId);
        }
        for(Id recordTypeId : recordTypeIds){
            choiceSet.add(new selectOption(recordTypeId, Schema.SObjectType.Service__c.getRecordTypeInfosById().get(recordTypeId).getName()));
        }
        return choiceSet; 
    }

}
