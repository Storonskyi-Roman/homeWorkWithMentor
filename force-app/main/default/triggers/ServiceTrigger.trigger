trigger ServiceTrigger on Service__c (after insert) {
    new ServiceTriggerHandler().run();
}