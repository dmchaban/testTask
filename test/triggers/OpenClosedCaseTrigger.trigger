trigger OpenClosedCaseTrigger on Case (after insert, after update, after delete, after undelete) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            CaseTriggerHandler.onAfterInsert(Trigger.new);
        }
        if (Trigger.isUpdate) {
            CaseTriggerHandler.onAfterUpdate(Trigger.new, Trigger.oldMap);
        }
        if (Trigger.isDelete) {
            CaseTriggerHandler.onAfterDelete(Trigger.old);
        }
        if (Trigger.isUndelete) {
            CaseTriggerHandler.onAfterUndelete(Trigger.new);
        }
    }
}
