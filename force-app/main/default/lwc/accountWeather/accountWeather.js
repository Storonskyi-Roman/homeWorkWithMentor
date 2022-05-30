import { LightningElement , api, wire, track } from 'lwc';
import getWeather from '@salesforce/apex/AccountWeatherController.getWeather';
import getWeatherImage from '@salesforce/apex/AccountWeatherController.getWeatherImage';
import AccountId from '@salesforce/schema/Case.AccountId';


export default class AccountWeather extends LightningElement {
    @track error;
    @track weather = {};
    @track weatherImage = '';
    @api recordId;
    
    connectedCallback(){
        getWeather({accId : this.recordId })
        .then(result => {
            console.log('accId' + result);
            this.weather = result;
            this.error = undefined;
            console.log('this.weather.main__c ' + JSON.stringify(this.weather));
            getWeatherImage({weatherMain: this.weather.Main__c })
                .then(result => {
                    console.log('weatherMain' + result);
                    this.weatherImage = result;
                    this.error = undefined;
                })
                .catch(error => {
                    this.error = error;
                    this.weather = undefined;
                });
        })
        .catch(error => {
            this.error = error;
            this.weather = undefined;
        });
    }


    // @wire(getWeather, {accId: '$recordId' })
    // getWeather({data, error}){
    //     if(data){
    //         console.log(data);
    //         this.weather = data;
    //         console.log(data.main__c);
    //         this.weatherImage = data.main__c;
    //     }
    // }
}