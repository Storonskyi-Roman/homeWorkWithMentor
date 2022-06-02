trigger IntakeTrigger on Intake__c (after insert) {
    new IntakeTriggerHandler().run();
}