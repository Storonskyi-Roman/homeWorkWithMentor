public class WeatherBatch implements Database.Batchable<sObject>, Database.AllowsCallouts  {
    private string apiKey = 'cf3f4c814fe327bbd2fd929814f190fb';

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, City_Name__c, Date__c, Humidity__c, Pressure__c, Temp_feels_like__c, Temperature__c, Weather_description__c, Wind_speed__c FROM Weather__c');
    }

    public void execute(Database.BatchableContext bc, List<Weather__c> records){
        for(Weather__c weatherObj : records){
            string url = 'https://api.openweathermap.org/data/2.5/weather?q=' + weatherObj.City_Name__c + '&appid=' + apiKey;
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(url);
            request.setMethod('GET');
            HttpResponse response = http.send(request);

            if(response.getStatusCode() == 200){

                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                Map<String, Object> mainResults = (Map<String, Object>)results.get('main');
                weatherObj.Temperature__c = mainResults.get('temp') + '';
                weatherObj.Temp_feels_like__c = mainResults.get('feels_like') + '';
                weatherObj.Humidity__c = (Decimal)mainResults.get('humidity');
                weatherObj.Pressure__c = mainResults.get('pressure') + '';

                Map<String, Object> windResults = (Map<String, Object>)results.get('wind');
                weatherObj.Wind_speed__c = windResults.get('speed') + '';

                List<Object> weatherResultsList = (List<Object>)results.get('weather');
                Map<String, Object> weatherResults = (Map<String, Object>)weatherResultsList[0];
                weatherObj.Weather_description__c = (String)weatherResults.get('description');

                weatherObj.Date__c = Date.today();

            }
        }
        update records;
    }

    public void finish(Database.BatchableContext bc){
        System.debug('Records are updated');
    }
}


/*
    public static void IntegrationServiceTest(){  
        String city = [SELECT BillingCity FROM Account WHERE BillingCity = 'Paris'].BillingCity;
        string url = 'https://api.openweathermap.org/data/2.5/weather?q=' + city + '&appid=' + apiKey;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        System.debug(response.getStatusCode());
            // Deserialize the JSON string into collections of primitive data types.
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        for(String key :results.keySet()){
            System.debug(key + ' => ' + results.get(key));
        }
        System.debug('--------------------------------');
        Map<String, Object> mainResults = (Map<String, Object>)results.get('main');
        //System.debug(mainResults.feels_like);
        for(String key : mainResults.keySet()){
            System.debug(key + ' => ' + mainResults.get(key));
        }

        Decimal feels_like = (Decimal)mainResults.get('feels_like');
        System.debug(feels_like);
        System.debug('--------------------------------');


        List<Object> weatherResultsList = (List<Object>)results.get('weather');
        System.debug(weatherResultsList[0]);
        Map<String, Object> weatherResults = (Map<String, Object>)weatherResultsList[0];
        for(String key : weatherResults.keySet()){
            System.debug(key + ' => ' + weatherResults.get(key));
        }
    }

}
*/
