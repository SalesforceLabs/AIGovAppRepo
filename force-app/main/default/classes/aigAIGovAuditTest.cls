@isTest
private class aigAIGovAuditTest {

    @isTest
    static void testAIUseCaseInsert() {
        aig_AI_Use_Case__c useCase = aigTestDataFactory.createAIUseCase('Test Description', 'Draft');

        Test.startTest();
        insert useCase;
        Test.stopTest();

        List<aig_AI_Gov_Audit_Event__c> auditEvents = [SELECT aig_Field__c, aig_Old_Value__c, aig_New_Value__c, aig_Change_Type__c,aig_RecordId__c FROM aig_AI_Gov_Audit_Event__c WHERE aig_RecordId__c = :useCase.Id];

        System.assertEquals(2, auditEvents.size(), 'Expected 2 audit events.');

        aig_AI_Gov_Audit_Event__c descriptionEvent = null;
        aig_AI_Gov_Audit_Event__c statusEvent = null;

        for (aig_AI_Gov_Audit_Event__c event : auditEvents) {
            if (event.aig_Field__c == 'aigov__aig_Description__c') {
                descriptionEvent = event;
            } else if (event.aig_Field__c == 'aigov__aig_Status__c') {
                statusEvent = event;
            }
        }

        System.assertNotEquals(null, descriptionEvent, 'Description Audit Event Not Found');
        System.assertEquals('Insert', descriptionEvent.aig_Change_Type__c, 'Incorrect Change Type for Description');
        System.assertEquals('Test Description', descriptionEvent.aig_New_Value__c, 'Incorrect New Value for Description'); // Stripped HTML
        System.assertEquals(null, descriptionEvent.aig_Old_Value__c, 'Incorrect Old Value for Description');

        System.assertNotEquals(null, statusEvent, 'Status Audit Event Not Found');
        System.assertEquals('Insert', statusEvent.aig_Change_Type__c, 'Incorrect Change Type for Status');
        System.assertEquals('Draft', statusEvent.aig_New_Value__c, 'Incorrect New Value for Status');
        System.assertEquals(null, statusEvent.aig_Old_Value__c, 'Incorrect Old Value for Status');
    }

    @isTest
    static void testAIUseCaseUpdate() {
        aig_AI_Use_Case__c useCase = aigTestDataFactory.createAIUseCase('Original Description', 'Draft');
        insert useCase;

        useCase.aig_Description__c = 'Updated Description';
        useCase.aig_Status__c = 'Proposed';

        Test.startTest();
        update useCase;
        Test.stopTest();

        List<aig_AI_Gov_Audit_Event__c> auditEvents = [SELECT aig_Field__c, aig_Old_Value__c, aig_New_Value__c, aig_Change_Type__c,aig_RecordId__c FROM aig_AI_Gov_Audit_Event__c WHERE aig_RecordId__c = :useCase.Id];

        System.assertEquals(4, auditEvents.size(), 'Expected 4 audit events.');

        aig_AI_Gov_Audit_Event__c descriptionUpdate = null;
        aig_AI_Gov_Audit_Event__c statusUpdate = null;
        aig_AI_Gov_Audit_Event__c descriptionInsert = null;
        aig_AI_Gov_Audit_Event__c statusInsert = null;


        for (aig_AI_Gov_Audit_Event__c event : auditEvents) {
            if (event.aig_Field__c == 'aigov__aig_Description__c' && event.aig_Change_Type__c == 'Update') {
                descriptionUpdate = event;
            } else if (event.aig_Field__c == 'aigov__aig_Status__c' && event.aig_Change_Type__c == 'Update') {
                statusUpdate = event;
            } else if (event.aig_Field__c == 'aigov__aig_Description__c' && event.aig_Change_Type__c == 'Insert') {
                descriptionInsert = event;
            } else if (event.aig_Field__c == 'aigov__aig_Status__c' && event.aig_Change_Type__c == 'Insert') {
                statusInsert = event;
            }
        }

        System.assertNotEquals(null, descriptionUpdate, 'Description Update Event not found');
        System.assertEquals('Updated Description', descriptionUpdate.aig_New_Value__c, 'Incorrect New Value for Description Update');
        System.assertEquals('Original Description', descriptionUpdate.aig_Old_Value__c, 'Incorrect Old Value for Description Update');
        System.assertEquals('Update', descriptionUpdate.aig_Change_Type__c, 'Incorrect Change Type for Description Update');

        System.assertNotEquals(null, statusUpdate, 'Status Update Event not found');
        System.assertEquals('Proposed', statusUpdate.aig_New_Value__c, 'Incorrect New Value for Status Update');
        System.assertEquals('Draft', statusUpdate.aig_Old_Value__c, 'Incorrect Old Value for Status Update');
        System.assertEquals('Update', statusUpdate.aig_Change_Type__c, 'Incorrect Change Type for Status Update');

        System.assertNotEquals(null, descriptionInsert, 'Description Insert Event not found');
        System.assertEquals('Original Description', descriptionInsert.aig_New_Value__c, 'Incorrect New Value for Description Insert');
        System.assertEquals(null, descriptionInsert.aig_Old_Value__c, 'Incorrect Old Value for Description Insert');
        System.assertEquals('Insert', descriptionInsert.aig_Change_Type__c, 'Incorrect Change Type for Description Insert');

        System.assertNotEquals(null, statusInsert, 'Status Insert Event not found');
        System.assertEquals('Draft', statusInsert.aig_New_Value__c, 'Incorrect New Value for Status Insert');
        System.assertEquals(null, statusInsert.aig_Old_Value__c, 'Incorrect Old Value for Status Insert');
        System.assertEquals('Insert', statusInsert.aig_Change_Type__c, 'Incorrect Change Type for Status Insert');
    }

    @isTest
    static void testAIUseCaseRiskInsert() {
        aig_AI_Use_Case__c useCase = aigTestDataFactory.createAIUseCase('Test Description','Draft');
        insert useCase;

        aig_AI_Use_Case_Risk__c risk = aigTestDataFactory.createAIUseCaseRisk(useCase.Id, 'High', 'Likely', true); // Use Impact/Likelihood

        Test.startTest();
        insert risk;
        Test.stopTest();

        List<aig_AI_Gov_Audit_Event__c> auditEvents = [SELECT aig_Field__c, aig_Old_Value__c, aig_New_Value__c, aig_Change_Type__c, aig_RecordId__c FROM aig_AI_Gov_Audit_Event__c WHERE aig_RecordId__c in (:useCase.Id, :risk.Id)];

        // Assertions
        System.assertEquals(4, auditEvents.size(), 'Expected 4 audit events.');

        // Use Case Audit Events
        aig_AI_Gov_Audit_Event__c useCaseDescriptionEvent = null;
        aig_AI_Gov_Audit_Event__c useCaseStatusEvent = null;

        //Risk Audit Events
        aig_AI_Gov_Audit_Event__c riskAcceptableRiskEvent = null;
        aig_AI_Gov_Audit_Event__c riskRiskScoreEvent = null;

        for (aig_AI_Gov_Audit_Event__c event : auditEvents) {
            if (event.aig_RecordId__c == useCase.Id) {
                if (event.aig_Field__c == 'aigov__aig_Description__c') {
                    useCaseDescriptionEvent = event;
                } else if (event.aig_Field__c == 'aigov__aig_Status__c') {
                    useCaseStatusEvent = event;
                }
            } else if (event.aig_RecordId__c == risk.Id) {
                if (event.aig_Field__c == 'aigov__aig_Acceptable_Risk__c') {
                    riskAcceptableRiskEvent = event;
                } else if (event.aig_Field__c == 'aigov__aig_Risk_Score__c') {
                    riskRiskScoreEvent = event;
                }
            }
        }

        System.assertNotEquals(null, useCaseDescriptionEvent, 'Use Case Description Audit Event Not Found');
        System.assertEquals('Insert', useCaseDescriptionEvent.aig_Change_Type__c, 'Incorrect Change Type for Use Case Description');
        System.assertEquals('Test Description', useCaseDescriptionEvent.aig_New_Value__c, 'Incorrect New Value for Use Case Description');
        System.assertEquals(null, useCaseDescriptionEvent.aig_Old_Value__c, 'Incorrect Old Value for Use Case Description');

        System.assertNotEquals(null, useCaseStatusEvent, 'Use Case Status Audit Event Not Found');
        System.assertEquals('Insert', useCaseStatusEvent.aig_Change_Type__c, 'Incorrect Change Type for Use Case Status');
        System.assertEquals('Draft', useCaseStatusEvent.aig_New_Value__c, 'Incorrect New Value for Use Case Status');
        System.assertEquals(null, useCaseStatusEvent.aig_Old_Value__c, 'Incorrect Old Value for Use Case Status');


        System.assertNotEquals(null, riskAcceptableRiskEvent, 'Risk Acceptable Risk Audit Event Not Found');
        System.assertEquals('Insert', riskAcceptableRiskEvent.aig_Change_Type__c, 'Incorrect Change Type for Risk Acceptable Risk');
        System.assertEquals('true', riskAcceptableRiskEvent.aig_New_Value__c, 'Incorrect New Value for Risk Acceptable Risk'); //Note the string comparison
        System.assertEquals(null, riskAcceptableRiskEvent.aig_Old_Value__c, 'Incorrect Old Value for Risk Acceptable Risk');

        System.assertNotEquals(null, riskRiskScoreEvent, 'Risk Score Audit Event Not Found');
        System.assertEquals('Insert', riskRiskScoreEvent.aig_Change_Type__c, 'Incorrect Change Type for Risk Score');
        System.assertEquals('16', riskRiskScoreEvent.aig_New_Value__c, 'Incorrect New Value for Risk Score'); //Note the string comparison
        System.assertEquals(null, riskRiskScoreEvent.aig_Old_Value__c, 'Incorrect Old Value for Risk Score');
    }

    @isTest
    static void testAIUseCaseRiskUpdate() {
        aig_AI_Use_Case__c useCase = aigTestDataFactory.createAIUseCase('Test Description','Draft');
        insert useCase;
        aig_AI_Use_Case_Risk__c risk = aigTestDataFactory.createAIUseCaseRisk(useCase.Id, 'High', 'Likely', true);
        insert risk;

        risk.aig_Impact__c = 'Very High'; // Update Impact
        risk.aig_Likelihood__c = 'Very Unlikely'; // Update Likelihood
        risk.aig_Acceptable_Risk__c = false;

        Test.startTest();
        update risk;
        Test.stopTest();

        List<aig_AI_Gov_Audit_Event__c> auditEvents = [SELECT aig_Field__c, aig_Old_Value__c, aig_New_Value__c, aig_Change_Type__c,aig_RecordId__c FROM aig_AI_Gov_Audit_Event__c WHERE aig_RecordId__c = :risk.Id];

        System.assertEquals(4, auditEvents.size(), 'Expected 4 audit events.');

        aig_AI_Gov_Audit_Event__c acceptableRiskUpdate = null;
        aig_AI_Gov_Audit_Event__c riskScoreUpdate = null;
        aig_AI_Gov_Audit_Event__c acceptableRiskInsert = null;
        aig_AI_Gov_Audit_Event__c riskScoreInsert = null;

        for (aig_AI_Gov_Audit_Event__c event : auditEvents) {
                if (event.aig_Field__c == 'aigov__aig_Acceptable_Risk__c' && event.aig_Change_Type__c == 'Update') {
                    acceptableRiskUpdate = event;
                }
                if (event.aig_Field__c == 'aigov__aig_Risk_Score__c' && event.aig_Change_Type__c == 'Update') {
                    riskScoreUpdate = event;
                }
                if (event.aig_Field__c == 'aigov__aig_Acceptable_Risk__c' && event.aig_Change_Type__c == 'Insert') {
                    acceptableRiskInsert = event;
                }
                if (event.aig_Field__c == 'aigov__aig_Risk_Score__c' && event.aig_Change_Type__c == 'Insert') {
                    riskScoreInsert = event;
                }
        }

        System.assertNotEquals(null, acceptableRiskUpdate, 'Acceptable Risk Update Event not found');
        System.assertEquals('false', acceptableRiskUpdate.aig_New_Value__c, 'Incorrect New Value for Acceptable Risk Update');
        System.assertEquals('true', acceptableRiskUpdate.aig_Old_Value__c, 'Incorrect Old Value for Acceptable Risk Update');
        System.assertEquals('Update', acceptableRiskUpdate.aig_Change_Type__c, 'Incorrect Change Type for Acceptable Risk Update');

        System.assertNotEquals(null, riskScoreUpdate, 'Risk Score Update Event not found');
        System.assertEquals('5', riskScoreUpdate.aig_New_Value__c, 'Incorrect New Value for Risk Score Update');
        System.assertEquals('16', riskScoreUpdate.aig_Old_Value__c, 'Incorrect Old Value for Risk Score Update');
        System.assertEquals('Update', riskScoreUpdate.aig_Change_Type__c, 'Incorrect Change Type for Risk Score Update');

        System.assertNotEquals(null, acceptableRiskInsert, 'Acceptable Risk Insert Event not found');
        System.assertEquals('true', acceptableRiskInsert.aig_New_Value__c, 'Incorrect New Value for Acceptable Risk Insert');
        System.assertEquals(null, acceptableRiskInsert.aig_Old_Value__c, 'Incorrect Old Value for Acceptable Risk Insert');
        System.assertEquals('Insert', acceptableRiskInsert.aig_Change_Type__c, 'Incorrect Change Type for Acceptable Risk Insert');


        System.assertNotEquals(null, riskScoreInsert, 'Risk Score Insert Event not found');
        System.assertEquals('16', riskScoreInsert.aig_New_Value__c, 'Incorrect New Value for Risk Score Insert');
        System.assertEquals(null, riskScoreInsert.aig_Old_Value__c, 'Incorrect Old Value for Risk Score Insert');
        System.assertEquals('Insert', riskScoreInsert.aig_Change_Type__c, 'Incorrect Change Type for Risk Score Insert');
    }
}