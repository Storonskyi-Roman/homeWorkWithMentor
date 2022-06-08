import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import Remove_Lead_confirmation	 from '@salesforce/label/c.Remove_Lead_confirmation';
import 	Remove_Lead_Starting from '@salesforce/label/c.Remove_Lead_Starting';

import DeleteAllLeadsCallBatch from '@salesforce/apex/DeleteAllLeadsBatchHandler.DeleteAllLeadsCallBatch';

export default class DeleteAllLeads extends LightningElement {

    @api visible; //used to hide/show dialog
    @api title; //modal title
    @api name; //reference name of the component
    @api message = Remove_Lead_confirmation; //modal message
    @api confirmLabel = 'Delete'; //confirm button label
    @api cancelLabel = 'Cancel'; //cancel button label
    @api originalMessage; //any event/message/detail to be published back to the parent component
    

    //Starting the deletion of all Lead records. This may take a while. You will receive an email once the deletion has finished
    

    
    handlClick(){
        this.visible = true;
    }
    //handles button clicks
    handleClickCancel(){
        this.visible = false;
    }

    handleClickDelete(){
        DeleteAllLeadsCallBatch()
        this.visible = false;

        const event = new ShowToastEvent({
            title: 'Done',
            message: Remove_Lead_Starting,
        });
        this.dispatchEvent(event);
        
    }
}