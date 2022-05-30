import { LightningElement , api, wire, track } from 'lwc';
import getWeather from '@salesforce/apex/AccountWeatherController.getWeather';
import getWeatherImage from '@salesforce/apex/AccountWeatherController.getWeather';


export default class AccountWeather extends LightningElement {

    @track weather = {};
    @track weatherImage;
    @api recordId;
    
    // @wire(getWeatherImage, {accId: '$weather.main__c' })
    // getWeatherImage({data, error}){
    //     if(data){
    //         console.log(data);
    //         this.weatherImage = data;
    //     }
    // }
    

    @wire(getWeather, {accId: '$recordId' })
    getWeather({data, error}){
        if(data){
            console.log(data);
            this.weather = data;
        }
    }

    

    //get Weather record for this city

    //display the Weather record
}