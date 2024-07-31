import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import AIG_IMPACT_FIELD from '@salesforce/schema/aig_AI_Use_Case_Risk__c.aig_Impact__c';
import AIG_LIKELIHOOD_FIELD from '@salesforce/schema/aig_AI_Use_Case_Risk__c.aig_Likelihood__c';
import AIG_RISK_SCORE_FIELD from '@salesforce/schema/aig_AI_Use_Case_Risk__c.aig_Risk_Score__c';

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

    @wire(getRecord, { recordId: '$recordId', fields })
    riskRecord({ error, data }) {
        if (data) {
            this.impact = data.fields.aigov__aig_Impact__c.value;
            this.likelihood = data.fields.aigov__aig_Likelihood__c.value;
            this.riskScore = data.fields.aigov__aig_Risk_Score__c.value;
            console.log('Impact:', this.impact);
            console.log('Likelihood:', this.likelihood);
            
            console.log('Risk Score:', this.riskScore);
            this.generateMatrix();
        } else if (error) {
            console.error('Error retrieving record:', error);
        }
    }

    generateMatrix() {
        console.log('Generating matrix...');
        console.log('Impact:', this.impact);
        console.log('Likelihood:', this.likelihood);
        console.log('Risk Score:', this.riskScore);

        const impactValue = impactMapping[this.impact];
        const likelihoodValue = likelihoodMapping[this.likelihood];
        const riskScoreValue = this.riskScore;

        console.log('Mapped Impact:', impactValue);
        console.log('Mapped Likelihood:', likelihoodValue);
        console.log('Risk Score Value:', riskScoreValue);

        let matrix = [];
        for (let i = 1; i <= 5; i++) { // Likelihood from Very Unlikely (bottom) to Very Likely (top)
            let row = { rowKey: 'row-${i}', cells: [] };
            for (let j = 5; j >= 1; j--) { // Impact from Very Low (left) to Very High (right)
                //let cellClass = 'custom-cell slds-box slds-box_x-small slds-align_absolute-center';
                let cellClass = 'custom-cell  slds-box_x-small slds-align_absolute-center';
                let value = '';
                if (( i=== 1 && j === 1) || ( i=== 1 && j === 2) || ( i=== 2 && j === 1)) {
                    cellClass += ' highlight-very-low';
                }
                if (( i=== 2 && j === 2) || ( i=== 1 && j === 3) || ( i=== 3 && j === 1)) {
                    cellClass += ' highlight-low';
                }
                if (( i=== 3 && j === 3) || ( i=== 1 && j === 5) || ( i=== 5 && j === 1) 
                    || ( i=== 1 && j === 4) || ( i=== 4 && j === 1)
                    || ( i=== 2 && j === 4) || ( i=== 4 && j === 2)
                    || ( i=== 2 && j === 3) || ( i=== 3 && j === 2)) {
                    cellClass += ' highlight-moderate';
                }
                if (( i=== 5 && j === 2) || ( i=== 2 && j === 5) || ( i=== 4 && j === 3) || ( i=== 3 && j === 4)) {
                    cellClass += ' highlight-mod-high';
                }
                if (( i=== 4 && j === 4) || ( i=== 5 && j === 3) || ( i=== 3 && j === 5)) {
                    cellClass += ' highlight-high';
                }
                if (( i=== 5 && j === 5) || ( i=== 4 && j === 5) || ( i=== 5 && j === 4)) {
                    cellClass += ' highlight-very-high';
                }

                if (i === likelihoodValue && j === impactValue) {
                    cellClass += ' highlight';
                    value = riskScoreValue;
                    console.log('Setting risk score at [' + i +',' + j + '] to ' +  riskScoreValue);
                }
                let cell = { cellKey: 'cell-${i}-${j}', value, cellClass };
                row.cells.push(cell);
            }
            matrix.push(row);
        }
        this.rows = matrix;
    }
}