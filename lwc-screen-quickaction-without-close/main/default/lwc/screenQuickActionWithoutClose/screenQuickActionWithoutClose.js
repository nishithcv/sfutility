import { LightningElement } from 'lwc';
import { CloseActionScreenEvent } from "lightning/actions"; //To close screen
import { loadStyle } from 'lightning/platformResourceLoader'; //Standard command to load styles
import hideCloseButton from '@salesforce/resourceUrl/LWCQAHideClose'; //Static resource which contains code to hide close button

export default class ScreenQuickActionWithoutClose extends LightningElement {

    showSpinner = true;

    connectedCallback() {
        // Call the loadStyle function to load the style
        // file from the resource path.
        loadStyle(this, hideCloseButton);

        window.setTimeout(() => {
            this.showSpinner = false;
            this.handleClose();
        }, 5000);
    }

    //To close screen
    handleClose() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}