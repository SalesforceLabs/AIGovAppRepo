public class AuditUtils {

    public static void auditChanges(List<SObject> newRecords, Map<Id, SObject> oldMap) {
        String objectAPIName = newRecords[0].getSObjectType().getDescribe().getName();

        List<aig_AI_Gov_Audit_Config__mdt> auditConfigs = [
            SELECT aig_Field__c
            FROM aig_AI_Gov_Audit_Config__mdt
            WHERE aig_Object__c = :objectAPIName
        ];

        List<aig_AI_Gov_Audit_Event__c> auditEvents = new List<aig_AI_Gov_Audit_Event__c>();

        for (SObject newRecord : newRecords) {
            SObject oldRecord = oldMap != null ? oldMap.get(newRecord.Id) : null; // Handle inserts

            for (aig_AI_Gov_Audit_Config__mdt config : auditConfigs) {
                String fieldName = config.aig_Field__c;

                if (fieldName != null && (oldRecord == null || hasFieldChanged(newRecord, oldRecord, fieldName))) { // Check for inserts
                    String oldValue = (oldRecord != null) ? String.valueOf(oldRecord.get(fieldName)) : null;
                    String newValue = String.valueOf(newRecord.get(fieldName));

                    aig_AI_Gov_Audit_Event__c auditEvent = new aig_AI_Gov_Audit_Event__c();
                    auditEvent.aig_Object__c = objectAPIName;
                    auditEvent.aig_RecordId__c = newRecord.Id;
                    auditEvent.aig_Field__c = fieldName;
                    auditEvent.aig_Old_Value__c = oldValue;
                    auditEvent.aig_New_Value__c = newValue;
                    auditEvent.aig_Change_Type__c = (oldRecord == null) ? 'Insert' : 'Update';
                    auditEvent.aig_Transaction_DateTime__c = System.now();
                    auditEvent.aig_Change_Maker__c = UserInfo.getUserId();

                    auditEvents.add(auditEvent);
                }
            }
        }

        if (!auditEvents.isEmpty()) {
            insert auditEvents;
        }
    }

    private static Boolean hasFieldChanged(SObject newRecord, SObject oldRecord, String fieldName) {
        Object oldValue = (oldRecord == null) ? null : oldRecord.get(fieldName);
        Object newValue = newRecord.get(fieldName);

        if (oldValue == null && newValue == null) {
            return false;
        } else if (oldValue == null || newValue == null) {
            return true;
        } else {
            return !oldValue.equals(newValue);
        }
    }
}