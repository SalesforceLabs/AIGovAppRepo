public with sharing class aigMultipleChoicePLGenController {

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getResponseDetails(String recordId) {
        // Fetch the related fields from aigov__aig_AI_Use_Case_Compliance_Question__c
        String query = 'SELECT aigov__aig_AI_Compliance_Checklist_Question__c, aigov__aig_Question__c, aigov__aig_Response__c, aigov__aig_Decision_Maker__r.aigov__aig_AI_Stakeholder__r.Name FROM aigov__aig_AI_Use_Case_Compliance_Question__c WHERE Id = :recordId';
        aigov__aig_AI_Use_Case_Compliance_Question__c useCaseQuest = (aigov__aig_AI_Use_Case_Compliance_Question__c) Database.query(query);

        Map<String, Object> result = new Map<String, Object>();

        if (useCaseQuest != null) {
            String complianceChecklistQuestionId = (String) useCaseQuest.aigov__aig_AI_Compliance_Checklist_Question__c;
            String currentResponse = (String) useCaseQuest.aigov__aig_Response__c;
            String questionValue = (String) useCaseQuest.aigov__aig_Question__c;
            result.put('currentResponse', currentResponse); 
            result.put('questionValue', questionValue); // Add question text value to result
            result.put('stakeholder', useCaseQuest.aigov__aig_Decision_Maker__r.aigov__aig_AI_Stakeholder__r.Name);

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
    public static void updateComplianceQuestionResponse(String recordId, String selectedChoiceId, String responseText, String description) {
        // Fetch the use case compliance question record
        aigov__aig_AI_Use_Case_Compliance_Question__c useCaseQuest = [SELECT Id, aigov__aig_Response__c, aigov__aig_Likelihood__c, aigov__aig_Impact__c FROM aigov__aig_AI_Use_Case_Compliance_Question__c WHERE Id = :recordId LIMIT 1];
        
        if (selectedChoiceId != null) {
            // Fetch the selected choice details
            aigov__aig_AI_Compliance_Checklist_Resp_Choice__c selectedChoice = [SELECT Name, aigov__aig_Likelihood__c, aigov__aig_Impact__c FROM aigov__aig_AI_Compliance_Checklist_Resp_Choice__c WHERE Id = :selectedChoiceId LIMIT 1];
            
            // Update the fields on the use case compliance question record
            useCaseQuest.aigov__aig_Response__c = selectedChoice.Name;
            useCaseQuest.aigov__aig_Likelihood__c = selectedChoice.aigov__aig_Likelihood__c;
            useCaseQuest.aigov__aig_Impact__c = selectedChoice.aigov__aig_Impact__c;
        } else {
            // Update only the response text
            useCaseQuest.aigov__aig_Response__c = responseText;
            
        }

        update useCaseQuest;
    }
}