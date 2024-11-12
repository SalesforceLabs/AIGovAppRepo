public with sharing class aigMultipleChoicePLGenController {

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getResponseDetails(String recordId) {
        // Fetch the related fields from aigov__aig_AI_Use_Case_Risk__c
        String query = 'SELECT aigov__aig_AI_Compliance_Checklist_Question__c, aigov__aig_Compliance_Checklist_Question_Resp__c, aigov__aig_Risk__c, aigov__aig_Decision_Maker__r.aigov__aig_AI_Stakeholder__r.Name FROM aigov__aig_AI_Use_Case_Risk__c WHERE Id = :recordId';
        aigov__aig_AI_Use_Case_Risk__c useCaseRisk = (aigov__aig_AI_Use_Case_Risk__c) Database.query(query);

        Map<String, Object> result = new Map<String, Object>();

        if (useCaseRisk != null) {
            String complianceChecklistQuestionId = (String) useCaseRisk.aigov__aig_AI_Compliance_Checklist_Question__c;
            String currentResponse = (String) useCaseRisk.aigov__aig_Compliance_Checklist_Question_Resp__c;
            String riskValue = (String) useCaseRisk.aigov__aig_Risk__c;
            result.put('currentResponse', currentResponse); 
            result.put('riskValue', riskValue); // Add risk value to result
            result.put('stakeholder', useCaseRisk.aigov__aig_Decision_Maker__r.aigov__aig_AI_Stakeholder__r.Name);

            if (complianceChecklistQuestionId != null) {
                // Fetch the response type from the related question
                String questionQuery = 'SELECT Id, aigov__aig_Response_Type__c FROM aigov__aig_AI_Compliance_Checklist_Question__c WHERE Id = :complianceChecklistQuestionId';
                aigov__aig_AI_Compliance_Checklist_Question__c complianceChecklistQuestion = (aigov__aig_AI_Compliance_Checklist_Question__c) Database.query(questionQuery);
                String responseType = complianceChecklistQuestion.aigov__aig_Response_Type__c;
                result.put('responseType', responseType);

                if (responseType == 'Multiple Choice') {
                    // Fetch the multiple choice options
                    String mcQuery = 'SELECT Id, Name, aigov__aig_Likelihood__c, aigov__aig_Impact__c FROM aigov__aig_AI_Compliance_Checklist_Resp_Choice__c WHERE aigov__aig_AI_Compliance_Checklist_Question__c = :complianceChecklistQuestionId';
                    List<SObject> choices = Database.query(mcQuery);
                    
                    List<Map<String, String>> options = new List<Map<String, String>>();
                    for (SObject choice : choices) {
                        Map<String, String> option = new Map<String, String>();
                        option.put('label', (String) choice.get('Name'));
                        option.put('value', (String) choice.get('Id'));
                        option.put('likelihood', (String) choice.get('aigov__aig_Likelihood__c'));
                        option.put('impact', (String) choice.get('aigov__aig_Impact__c'));
                        options.add(option);
                    }
                    result.put('options', options);
                }
            }
        }
        system.debug ('result:' +result);

        return result;
    }

    @AuraEnabled
    public static void updateRiskResponse(String recordId, String selectedChoiceId, String responseText, String description) {
        // Fetch the use case risk record
        aigov__aig_AI_Use_Case_Risk__c useCaseRisk = [SELECT Id, aigov__aig_Compliance_Checklist_Question_Resp__c, aigov__aig_Likelihood__c, aigov__aig_Impact__c FROM aigov__aig_AI_Use_Case_Risk__c WHERE Id = :recordId LIMIT 1];
        
        if (selectedChoiceId != null) {
            // Fetch the selected choice details
            aigov__aig_AI_Compliance_Checklist_Resp_Choice__c selectedChoice = [SELECT Name, aigov__aig_Likelihood__c, aigov__aig_Impact__c FROM aigov__aig_AI_Compliance_Checklist_Resp_Choice__c WHERE Id = :selectedChoiceId LIMIT 1];
            
            // Update the fields on the use case risk record
            useCaseRisk.aigov__aig_Compliance_Checklist_Question_Resp__c = selectedChoice.Name;
            useCaseRisk.aigov__aig_Likelihood__c = selectedChoice.aigov__aig_Likelihood__c;
            useCaseRisk.aigov__aig_Impact__c = selectedChoice.aigov__aig_Impact__c;
        } else {
            // Update only the response text
            useCaseRisk.aigov__aig_Compliance_Checklist_Question_Resp__c = responseText;
            
        }

        useCaseRisk.aigov__aig_Description__c = description;
        
        update useCaseRisk;
    }
}