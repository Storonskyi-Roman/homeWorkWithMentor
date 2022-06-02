public class IntakeMemberUpdateControlle {
    @AuraEnabled
    public static string getMemberId(Id intakeId) {
        return String.valueOf([SELECT Id FROM Intake_Member__c WHERE Intake__c = :intakeId LIMIT 1].Id);
    }
}
