public class WeatherBatch implements Database.Batchable<sObject>, Database.AllowsCallouts  {
    private string apiKey = 'cf3f4c814fe327bbd2fd929814f190fb';

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, City_Name__c, Date__c, Humidity__c, Pressure__c, Temp_feels_like__c, Temperature__c, Weather_description__c, Wind_speed__c, Main__c FROM Weather__c');
    }

    public void execute(Database.BatchableContext bc, List<Weather__c> records){
        for(Weather__c weatherObj : records){
            if(weatherObj.City_Name__c != null ){
                string url = 'https://api.openweathermap.org/data/2.5/weather?q=' + weatherObj.City_Name__c + '&appid=' + apiKey;
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint(url);
                request.setMethod('GET');
                HttpResponse response = http.send(request);

                if(response.getStatusCode() == 200){

                    Map<String, Object> results  = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                    Map<String, Object> mainResults = (Map<String, Object>)results.get('main');
                    weatherObj.Temperature__c = String.valueOf(mainResults.get('temp'));
                    weatherObj.Temp_feels_like__c = String.valueOf(mainResults.get('feels_like'));
                    weatherObj.Humidity__c = (Decimal)mainResults.get('humidity');
                    weatherObj.Pressure__c = String.valueOf(mainResults.get('pressure'));
                    

                    Map<String, Object> windResults = (Map<String, Object>)results.get('wind');
                    weatherObj.Wind_speed__c = String.valueOf(windResults.get('speed'));

                    List<Object> weatherResultsList = (List<Object>)results.get('weather');
                    Map<String, Object> weatherResults = (Map<String, Object>)weatherResultsList[0];
                    weatherObj.Weather_description__c = String.valueOf(weatherResults.get('description'));
                    weatherObj.Main__c = String.valueOf(weatherResults.get('main'));

                    weatherObj.Date__c = Date.today();

                }
            }
        }
        update records;
    }

    public void finish(Database.BatchableContext bc){
        System.debug('Records are updated');
    }
}

