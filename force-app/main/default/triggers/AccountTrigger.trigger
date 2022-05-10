trigger AccountTrigger on Account (after insert, before update, before delete) {

    new AccountTriggerHandler().run();

}