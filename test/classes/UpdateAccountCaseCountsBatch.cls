public with sharing class UpdateAccountCaseCountsBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id FROM Account]);
    }

    public void execute(Database.BatchableContext bc, List<Account> scope) {
        Set<Id> accountIds = new Set<Id>();
        for (Account acc : scope) {
            accountIds.add(acc.Id);
        }
        CaseTriggerHandler.updateCaseCount(accountIds);
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('finish batch process for updating account case counts');
    }

}