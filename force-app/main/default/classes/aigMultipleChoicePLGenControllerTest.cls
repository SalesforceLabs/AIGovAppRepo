@isTest
public class aigMultipleChoicePLGenControllerTest {
    
    @testSetup
    static void setupTestData() {
        //Create test data for AI Risk Packet
        aigov__aig_AI_Compliance_Checklist__c testComplianceChecklist = new aigov__aig_AI_Compliance_Checklist__c(
            Name = 'Test Packet'
        );
        insert testComplianceChecklist;

        // Create test data for the AI Risk Packet Question
        aigov__aig_AI_Compliance_Checklist_Question__c testQuestion = new aigov__aig_AI_Compliance_Checklist_Question__c(
            aigov__aig_Response_Type__c = 'Multiple Choice',
            aigov__aig_Question__c = 'Is this an acceptable risk?',
            aigov__aig_AI_Compliance_Checklist__c = testComplianceChecklist.Id
        );
        insert testQuestion;
        
        // Create test data for the multiple choice options
        aigov__aig_AI_Compliance_Checklist_Resp_Choice__c choice1 = new aigov__aig_AI_Compliance_Checklist_Resp_Choice__c(
            aigov__aig_AI_Compliance_Checklist_Question__c = testQuestion.Id,
            Name = 'Choice 1',
            aigov__aig_Likelihood__c = 'Unlikely',
            aigov__aig_Impact__c = 'Low'
        );
        aigov__aig_AI_Compliance_Checklist_Resp_Choice__c choice2 = new aigov__aig_AI_Compliance_Checklist_Resp_Choice__c(
            aigov__aig_AI_Compliance_Checklist_Question__c = testQuestion.Id,
            Name = 'Choice 2',
            aigov__aig_Likelihood__c = 'Unlikely',
            aigov__aig_Impact__c = 'High'
        );
        insert new List<aigov__aig_AI_Compliance_Checklist_Resp_Choice__c>{choice1, choice2};

        //Create test data for AI Use Case
        aigov__aig_AI_Use_Case__c testUseCase = new aigov__aig_AI_Use_Case__c(
        );
        insert testUseCase;

        // Create test data for the AI Use Case Risk
        aigov__aig_AI_Use_Case_Risk__c useCaseRisk = new aigov__aig_AI_Use_Case_Risk__c(
            aigov__aig_AI_Compliance_Checklist_Question__c = testQuestion.Id,
            aigov__aig_Compliance_Checklist_Question_Resp__c = 'Initial Response',
            aigov__aig_Risk__c = 'High Risk',
            aigov__aig_AI_Use_Case__c = testUseCase.Id
        );
        insert useCaseRisk;
    }

    @isTest
    static void testGetResponseDetails() {
        // Fetch the use case risk record for the test
        aigov__aig_AI_Use_Case_Risk__c useCaseRisk = [SELECT Id FROM aigov__aig_AI_Use_Case_Risk__c LIMIT 1];

        // Call the controller method
        Map<String, Object> result = aigMultipleChoicePLGenController.getResponseDetails(useCaseRisk.Id);
        
        // Verify the result contains expected keys and values
        System.assert(result.containsKey('currentResponse'));
        System.assertEquals('Initial Response', result.get('currentResponse'));
        
        System.assert(result.containsKey('riskValue'));
        System.assertEquals('High Risk', result.get('riskValue'));
        
        System.assert(result.containsKey('responseType'));
        System.assertEquals('Multiple Choice', result.get('responseType'));

        System.assert(result.containsKey('options'));
        List<Map<String, String>> options = (List<Map<String, String>>) result.get('options');
        System.assertEquals(2, options.size());
        System.assertEquals('Choice 1', options[0].get('label'));
    }

    @isTest
    static void testUpdateRiskResponse() {
        // Fetch the use case risk record for the test
        aigov__aig_AI_Use_Case_Risk__c useCaseRisk = [SELECT Id FROM aigov__aig_AI_Use_Case_Risk__c LIMIT 1];

        // Fetch one of the multiple choice options
        aigov__aig_AI_Compliance_Checklist_Resp_Choice__c choice = [SELECT Id FROM aigov__aig_AI_Compliance_Checklist_Resp_Choice__c LIMIT 1];

        // Call the updateRiskResponse method with the selected choice
        aigMultipleChoicePLGenController.updateRiskResponse(useCaseRisk.Id, choice.Id, null, 'Updated Description');

        // Verify that the use case risk record has been updated
        aigov__aig_AI_Use_Case_Risk__c updatedUseCaseRisk = [SELECT aigov__aig_Compliance_Checklist_Question_Resp__c, aigov__aig_Description__c FROM aigov__aig_AI_Use_Case_Risk__c WHERE Id = :useCaseRisk.Id];
        System.assertEquals('Choice 1', updatedUseCaseRisk.aigov__aig_Compliance_Checklist_Question_Resp__c);
        System.assertEquals('Updated Description', updatedUseCaseRisk.aigov__aig_Description__c);
    }
}