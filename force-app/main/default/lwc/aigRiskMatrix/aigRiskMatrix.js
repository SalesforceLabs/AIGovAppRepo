import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { subscribe, MessageContext } from 'lightning/messageService';
import { refreshApex } from '@salesforce/apex'; // Import refreshApex
import AIG_IMPACT_FIELD from '@salesforce/schema/aig_AI_Use_Case_Risk__c.aig_Impact__c';
import AIG_LIKELIHOOD_FIELD from '@salesforce/schema/aig_AI_Use_Case_Risk__c.aig_Likelihood__c';
import AIG_RISK_SCORE_FIELD from '@salesforce/schema/aig_AI_Use_Case_Risk__c.aig_Risk_Score__c';
import AIG_AI_USE_CASE_RISK_MSG_CHANNEL from '@salesforce/messageChannel/aigAIUseCaseRiskMsgChannel__c'; 

const fields = [AIG_IMPACT_FIELD, AIG_LIKELIHOOD_FIELD, AIG_RISK_SCORE_FIELD];

const likelihoodMapping = {
    'Very Unlikely': 1,
    'Unlikely': 2,
    'Possible': 3,
    'Likely': 4,
    'Very Likely': 5
};

const impactMapping = {
    'Very Low': 1,
    'Low': 2,
    'Moderate': 3,
    'High': 4,
    'Very High': 5
};

export default class AigRiskMatrix extends LightningElement {
    @api recordId;
    impact;
    likelihood;
    riskScore;
    rows = [];
    subscription = null;
    wiredRiskRecord; // To store the wired record result for refresh

    // Wire the message context
    @wire(MessageContext)
    messageContext;

    // Subscribe to the message channel when the component is initialized
    connectedCallback() {
        this.subscribeToMessageChannel();
    }

    subscribeToMessageChannel() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                AIG_AI_USE_CASE_RISK_MSG_CHANNEL,
                (message) => this.handleMessage(message)
            );
        }
    }

    handleMessage(message) {
        // Check if the message contains the recordId of interest
        if (message.recordId === this.recordId) {
            // Refresh the risk matrix by manually refreshing the wire adapter data
            this.refreshRiskMatrix();
        }
    }

    // Wire the record data
    @wire(getRecord, { recordId: '$recordId', fields })
    wiredRiskRecord(result) {
        this.wiredRiskRecord = result; // Store the wired result for future refresh

        const { data, error } = result;
        if (data) {
            this.impact = getFieldValue(data, AIG_IMPACT_FIELD);
            this.likelihood = getFieldValue(data, AIG_LIKELIHOOD_FIELD);
            this.riskScore = getFieldValue(data, AIG_RISK_SCORE_FIELD);
            this.generateMatrix();
        } else if (error) {
            console.error('Error retrieving record:', error);
        }
    }

    // Method to refresh the record data
    refreshRiskMatrix() {
        // Use refreshApex to refresh the wire data
        refreshApex(this.wiredRiskRecord);
    }

    generateMatrix() {
        const impactValue = impactMapping[this.impact];
        const likelihoodValue = likelihoodMapping[this.likelihood];
        const riskScoreValue = this.riskScore;

        let matrix = [];
        for (let i = 1; i <= 5; i++) { // Likelihood from Very Unlikely (bottom) to Very Likely (top)
            let row = { rowKey: `row-${i}`, cells: [] };
            for (let j = 5; j >= 1; j--) { // Impact from Very Low (left) to Very High (right)
                let cellClass = 'custom-cell slds-box_x-small slds-align_absolute-center';
                let value = '';

                if ((i === 1 && j === 1) || (i === 1 && j === 2) || (i === 2 && j === 1)) {
                    cellClass += ' highlight-very-low';
                }
                if ((i === 2 && j === 2) || (i === 1 && j === 3) || (i === 3 && j === 1)) {
                    cellClass += ' highlight-low';
                }
                if ((i === 3 && j === 3) || (i === 1 && j === 5) || (i === 5 && j === 1) 
                    || (i === 1 && j === 4) || (i === 4 && j === 1)
                    || (i === 2 && j === 4) || (i === 4 && j === 2)
                    || (i === 2 && j === 3) || (i === 3 && j === 2)) {
                    cellClass += ' highlight-moderate';
                }
                if ((i === 5 && j === 2) || (i === 2 && j === 5) || (i === 4 && j === 3) || (i === 3 && j === 4)) {
                    cellClass += ' highlight-mod-high';
                }
                if ((i === 4 && j === 4) || (i === 5 && j === 3) || (i === 3 && j === 5)) {
                    cellClass += ' highlight-high';
                }
                if ((i === 5 && j === 5) || (i === 4 && j === 5) || (i === 5 && j === 4)) {
                    cellClass += ' highlight-very-high';
                }

                if (i === likelihoodValue && j === impactValue) {
                    cellClass += ' highlight';
                    value = riskScoreValue;
                }
                let cell = { cellKey: `cell-${i}-${j}`, value, cellClass };
                row.cells.push(cell);
            }
            matrix.push(row);
        }
        this.rows = matrix;
    }
}