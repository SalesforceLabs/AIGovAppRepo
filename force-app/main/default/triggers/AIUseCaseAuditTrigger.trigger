trigger AIUseCaseAuditTrigger on aig_AI_Use_Case__c (after insert, after update) {
    aigAuditUtils.auditChanges(Trigger.new, Trigger.isUpdate ? Trigger.oldMap : null);
}