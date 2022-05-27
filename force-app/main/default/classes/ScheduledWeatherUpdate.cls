public class ScheduledWeatherUpdate implements Schedulable{
    public void execute(SchedulableContext ctx) {
        
        WeatherBatch myBatchObject = new WeatherBatch();
        Id batchId = Database.executeBatch(myBatchObject);
    }
}
