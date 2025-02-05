public class aigTestDataFactory {

    public static aig_AI_Use_Case__c createAIUseCase(String description, String status) {
        return new aig_AI_Use_Case__c(
            aig_Description__c = description,
            aig_Status__c = status
        );
    }

    public static aig_AI_Use_Case_Risk__c createAIUseCaseRisk(Id useCaseId, String impact, String likelihood, Boolean acceptableRisk) {
        return new aig_AI_Use_Case_Risk__c(
            aig_AI_Use_Case__c = useCaseId,
            aig_Impact__c = impact,       // Set Impact
            aig_Likelihood__c = likelihood, // Set Likelihood
            aig_Acceptable_Risk__c = acceptableRisk
        );
    }
}