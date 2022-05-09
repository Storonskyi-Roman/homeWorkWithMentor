public with sharing class ServicesListController {
    
    public String page {get; set;}
    public String openPageURL {get; set;}
    public String recordType {get;set;}
    public Date startDate {get;set;}
    public Date endDate {get;set;}   

    public static Set<Id> getServices() {
        
        String recordType = (ApexPages.currentPage().getParameters().get('RecordType')).replace('+',' ');
        String startDate = ApexPages.currentPage().getParameters().get('StartDate');
        String endDate = ApexPages.currentPage().getParameters().get('EndDate');
        String ContactId = ApexPages.currentPage().getParameters().get('ContactId');
        Id recordTypeId = Schema.SObjectType.Service__c.getRecordTypeInfosByName().get(recordType).getRecordTypeId();

        String query = 'SELECT id FROM Service__c WHERE RecordTypeId = \'' + recordTypeId +
                        + '\' AND Service_Date__c >= ' + startDate + ' AND Service_Date__c <= ' + endDate +
                        + ' AND Contact__c = \'' + ContactId + '\'';

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
        pageRef.GetParameters().put('UserId', UserInfo.getUserId());
        pageRef.GetParameters().put('ContactId', String.valueOf(ApexPages.currentPage().getParameters().get('id')));
        return pageRef;
    }

    public List<Selectoption> getTypeItems(){
        List<Selectoption> choiceSet = new List<selectoption>();
        choiceSet.add(new selectOption('Education Note', 'Education Note'));
        choiceSet.add(new selectOption('Clinical Note', 'Clinical Note'));
        choiceSet.add(new selectOption('Medical Note', 'Medical Note'));
        return choiceSet; 
    }

}
