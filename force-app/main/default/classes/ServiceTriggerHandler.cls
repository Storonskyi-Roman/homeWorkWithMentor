public class ServiceTriggerHandler extends TriggerHandler {
    public override void afterInsert(){
        sharingSetup();
    }

    public void sharingSetup(){
        Map<Id, Service__c> newMap = new Map<Id, Service__c>((Map<Id, Service__c>)Trigger.newMap);
        List<Service__share> ServicesShareToItsert = new List<Service__Share>();

        Set<Id> ownerIdList = new Set<Id>();
        for(Service__c serv :[SELECT OwnerId FROM Service__c WHERE Id IN :Trigger.new]){
            ownerIdList.add(serv.OwnerId);
        }
        Map<Id, User> ownerRoleMap = new Map<Id, User>([SELECT Id, UserRoleId, UserRole.DeveloperName FROM User WHERE Id IN :ownerIdList]);

        List<Group> gList = [SELECT DeveloperName, Id FROM Group
                            WHERE (DeveloperName = 'Lviv_director' AND Type = 'RoleAndSubordinates')
                            OR (DeveloperName = 'Kyiv_director' AND Type = 'RoleAndSubordinates') 
                            OR (DeveloperName = 'Odesa_director' AND Type = 'Role')];
        Map<String, Group> roleGroupMap = new Map<String, Group>();
        for(Group role : gList){
            roleGroupMap.put(role.DeveloperName, role);
        }

        for(Id serId : newMap.keySet()){
            if(UserInfo.getUserRoleId() != null){

                if(newMap.get(serId).City__c == 'Odesa'){
                    Service__share odesaShare = new Service__share();
                    odesaShare.AccessLevel = 'Edit';
                    odesaShare.ParentId = serId;
                    odesaShare.RowCause = Schema.Service__Share.RowCause.ServiceTrigger__c;
                    odesaShare.UserOrGroupId = roleGroupMap.get('Odesa_Director').Id;
                    servicesShareToItsert.add(odesaShare);
                }

                //UserInfo.getUserRoleId();
                String currentUserRoleDevName = ownerRoleMap.get(newMap.get(serId).OwnerId).userRole.DeveloperName;
                
                if (currentUserRoleDevName.contains('Lviv') || currentUserRoleDevName.contains('Kyiv')){
                    Service__share serShare = new Service__share();
                    serShare.AccessLevel = 'Edit';
                    serShare.ParentId = serId;

                        if(currentUserRoleDevName.contains('Lviv')){
                            serShare.UserOrGroupId = roleGroupMap.get('Lviv_Director').Id;
                        } else if(currentUserRoleDevName.contains('Kyiv')){
                            serShare.UserOrGroupId = roleGroupMap.get('Kyiv_Director').Id;
                        }
                    serShare.RowCause = Schema.Service__Share.RowCause.ServiceTrigger__c;
                    servicesShareToItsert.add(serShare);
                }
                
            }
        }

        Database.insert(servicesShareToItsert, true);
    }
}
