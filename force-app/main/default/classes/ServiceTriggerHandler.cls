public class ServiceTriggerHandler extends TriggerHandler {
    public override void afterInsert(){
        sharingSetup();
    }

    public void sharingSetup(){
        Map<Id, Service__c> newMap = new Map<Id, Service__c>((Map<Id, Service__c>)Trigger.newMap);
        for(Id serId : newMap.keySet()){
            if(UserInfo.getUserRoleId() != null){
                //UserInfo.getUserRoleId();
                Service__share SerShare = new Service__share();
                String currentUserRoleDevName = [SELECT DeveloperName FROM UserRole WHERE Id = :UserInfo.getUserRoleId() LIMIT 1].DeveloperName + '';
                SerShare.AccessLevel = 'All';
                SerShare.ParentId = serId;
                if(currentUserRoleDevName.contains('Lviv')){
                    SerShare.UserOrGroupId = [SELECT Id FROM Group
                                                WHERE DeveloperName = 'Lviv_director' 
                                                AND Type = 'RoleAndSubordinates' 
                                                LIMIT 1].Id;
                }
                
                else if(currentUserRoleDevName.contains('Kyiv')){
                    SerShare.UserOrGroupId = [SELECT Id FROM Group
                                                WHERE DeveloperName = 'Kyiv_director' 
                                                AND Type = 'RoleAndSubordinates' 
                                                LIMIT 1].Id;
                }

                else if(newMap.get(serId).City__c == 'Odesa'){
                    SerShare.UserOrGroupId = [SELECT Id FROM Group
                                                WHERE DeveloperName = 'Odesa_director' 
                                                AND Type = 'Role' 
                                                LIMIT 1].Id;
                }
                else{
                    SerShare.UserOrGroupId = UserInfo.getUserId();
                }

                Database.SaveResult sr = Database.insert(SerShare,false);

                if(sr.isSuccess()){

                }
                else {
                    Database.Error err = sr.getErrors()[0];

                }
            }
        }
    }
}
