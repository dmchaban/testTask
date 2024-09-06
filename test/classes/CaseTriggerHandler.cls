public with sharing class CaseTriggerHandler {

    public static void onAfterInsert(Case[] insertedCases) {
        Set<Id> accountIds = new Set<Id>();
        for (Case record : insertedCases) {
            if (record.AccountId != null) {
                accountIds.add(record.AccountId);
            }
        }
        updateCaseCount(accountIds);
    }

    public static void onAfterUpdate(Case[] updatedCases, Map<Id, Case> oldCasesMap) {
        Set<Id> accountIds = new Set<Id>();
        for(Case record : updatedCases) {
            if(record.AccountId != oldCasesMap.get(record.Id).AccountId || record.Status != oldCasesMap.get(record.Id).Status) {
                accountIds.add(record.AccountId);
                accountIds.add(oldCasesMap.get(record.Id).AccountId);
            }
        }
        updateCaseCount(accountIds);
    }

    public static void onAfterDelete(Case[] deletedCases) {
        Set<Id> accountIds = new Set<Id>();
        for (Case record : deletedCases) {
            if (record.AccountId != null) {
                accountIds.add(record.AccountId);
            }
        }
        updateCaseCount(accountIds);
    }

    public static void onAfterUndelete(Case[] undeletedCases) {
        Set<Id> accountIds = new Set<Id>();
        for (Case record : undeletedCases) {
            if (record.AccountId != null) {
                accountIds.add(record.AccountId);
            }
        }
        updateCaseCount(accountIds);
    }

    public static void updateCaseCount(Set<Id> accountIds) {
        List<Account> accountsToUpdate = [SELECT Id, (SELECT Id, Status FROM Cases) FROM Account WHERE Id IN :accountIds];
        
        if (!accountsToUpdate.isEmpty()) {
            for (Account acc : accountsToUpdate) {
                Integer closed = 0;
                Integer open = 0;
                for (Case c : acc.Cases) {
                    if (c.Status == 'Closed') {
                        closed++;
                    } else {
                        open++;
                    }
                }
                acc.Number_of_Open_Cases__c = open;
                acc.Number_of_Closed_Cases__c = closed;
            }
            update accountsToUpdate;
        }
    }
}
