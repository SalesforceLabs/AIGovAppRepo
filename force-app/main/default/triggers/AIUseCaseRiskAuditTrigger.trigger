trigger AIUseCaseRiskAuditTrigger on aig_AI_Use_Case_Risk__c (after insert, after update) {
    aigAuditUtils.auditChanges(Trigger.new, Trigger.isUpdate ? Trigger.oldMap : null);
}