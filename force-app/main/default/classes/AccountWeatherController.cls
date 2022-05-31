public with sharing class AccountWeatherController {

    @AuraEnabled(cacheable = true)
    public static Weather__c getWeather(Id accId){  
        Account acc = [SELECT Id, BillingCity FROM Account WHERE Id = :accId LIMIT 1];
        System.debug(acc);
        Weather__c Weather = [SELECT Id, City_Name__c, Date__c, Humidity__c,
                             Pressure__c, Temp_feels_like__c, Temperature__c,
                             Weather_description__c, Wind_speed__c, Main__c
                             FROM Weather__c WHERE City_Name__c =:acc.BillingCity LIMIT 1];
        Weather.Temperature__c = String.valueOf(Decimal.valueOf(Weather.Temperature__c) - 273.15);
        Weather.Temp_feels_like__c = String.valueOf(Decimal.valueOf(Weather.Temp_feels_like__c) - 273.15);
        //273.15
        System.debug(Weather);
        return Weather;
    }
    
    @AuraEnabled(cacheable = true)
    public static String getWeatherImage(String weatherMain){
        return Weather_Image__mdt.getInstance(weatherMain).Link__c;
    }

}
