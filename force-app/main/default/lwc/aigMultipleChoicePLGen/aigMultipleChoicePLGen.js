import { LightningElement, api, wire } from 'lwc';
import getResponseDetails from '@salesforce/apex/aigMultipleChoicePLGenController.getResponseDetails';
import updateRiskResponse from '@salesforce/apex/aigMultipleChoicePLGenController.updateRiskResponse';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import AIG_AI_USE_CASE_RISK_MSG_CHANNEL from '@salesforce/messageChannel/aigAIUseCaseRiskMsgChannel__c'; 
import { publish, MessageContext } from 'lightning/messageService'; 

export default class AigMultipleChoicePLGen extends LightningElement {
    @api recordId;
    @api flowRecordId;

    @api responseLabel;
    @api impact;
    @api likelihood;
    @api isFlow = false;
    
    options = [];
    value = '';
    riskValue = ''; 
    stakeholder = '';
    selectedLabel = '';
    selectedImpact = '';
    selectedLikelihood = '';
    isMultipleChoice = false;
    error;
    showTextBoxMessage = false;
    wiredResponseDetailsResult;

    @wire(MessageContext)
    messageContext;

    @wire(getResponseDetails, { recordId: '$recordId' })
    wiredResponseDetails(result) {
        this.wiredResponseDetailsResult = result; 
        const { error, data } = result;
        if (data) {
            this.isMultipleChoice = data.responseType === 'Multiple Choice';
            this.riskValue = data.riskValue;
            this.stakeholder = data.stakeholder;

            if (this.isMultipleChoice) {
                this.options = data.options.map(option => ({
                    label: option.label, 
                    value: option.value,
                    impact: option.impact,
                    likelihood: option.likelihood
                }));

                const matchingOption = this.options.find(option => option.label === data.currentResponse);
                if (matchingOption) {
                    this.value = matchingOption.value;
                    this.selectedLabel = matchingOption.label;
                    this.selectedImpact = matchingOption.impact;
                    this.selectedLikelihood = matchingOption.likelihood;
                } else {
                    this.value = data.currentResponse;
                }
            } else {
                this.value = data.currentResponse;
                this.selectedLabel = this.value;
            }

            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.options = [];
        }
    }

    handlePicklistChange(event) {
        this.value = event.detail.value;
        const selectedOption = this.options.find(option => option.value === this.value);
        if (selectedOption) {
            this.selectedLabel = selectedOption.label;
            this.selectedImpact = selectedOption.impact;
            this.selectedLikelihood = selectedOption.likelihood;
        }

        // Automatically save after the dropdown is changed
        this.saveResponse();
    }

    handleTextBlur(event) {
        this.value = event.target.value;

        // Automatically save after the text field loses focus (on blur)
        this.saveResponse();
    }

    saveResponse() {
        updateRiskResponse({ 
            recordId: this.recordId, 
            selectedChoiceId: this.isMultipleChoice ? this.value : null,
            responseText: this.isMultipleChoice ? null : this.value
        })
        .then(() => {
            this.showToast('Success', 'Record updated successfully', 'success');
    
            const message = {
                recordId: this.recordId
            };
            publish(this.messageContext, AIG_AI_USE_CASE_RISK_MSG_CHANNEL, message);
    
            return refreshApex(this.wiredResponseDetailsResult);
        })
        .catch(error => {
            let errorMessage = 'An error occurred';
            if (error && error.body && error.body.message) {
                errorMessage = error.body.message;
            } else if (error && error.message) {
                errorMessage = error.message;
            }
            this.showToast('Error', errorMessage, 'error');
        });
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant
            })
        );
    }
}