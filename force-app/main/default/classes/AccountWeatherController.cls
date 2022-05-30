public with sharing class AccountWeatherController {

    @AuraEnabled(cacheable = true)
    public static Weather__c getWeather(Id accId)
    {  
        Account acc = [SELECT Id, BillingCity FROM Account WHERE Id = :accId LIMIT 1];
        System.debug(acc);
        Weather__c Weather = [SELECT Id, City_Name__c, Date__c, Humidity__c,
                             Pressure__c, Temp_feels_like__c, Temperature__c,
                             Weather_description__c, Wind_speed__c, Main__c
                             FROM Weather__c WHERE City_Name__c =:acc.BillingCity LIMIT 1];
        System.debug(Weather);
        return Weather;
    }
    
    // @AuraEnabled(cacheable = true)
    // public static String getWeatherImage(String WeatherMain){
    //     Map<String,String> ImageMap = new Map<String,String>();
    //     ImageMap.put('Rain','https://img.freepik.com/free-photo/rain-drop-falling-onto-blackboard-with-green-nature-background_34152-328.jpg');
    //     ImageMap.put('Snow','https://cdn.wallpapersafari.com/59/52/oMKxzU.jpg');
    //     ImageMap.put('Sun','https://zinginstruments.com/wp-content/uploads/the-sun.jpg');
    //     System.debug(ImageMap);
    //     return ImageMap.get(WeatherMain);
    // }

}
