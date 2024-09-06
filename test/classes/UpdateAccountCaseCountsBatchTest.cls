@isTest
public with sharing class UpdateAccountCaseCountsBatchTest {
    @TestSetup
    static void setupTestData() {
        Account acc1 = new Account(Name = 'Test Account 1');
        Account acc2 = new Account(Name = 'Test Account 2');
        List<Account> accounts = new List<Account>{acc1, acc2};
        insert accounts;

        Case case1 = new Case(Status = 'New', AccountId = acc1.Id);
        Case case2 = new Case(Status = 'Closed', AccountId = acc1.Id);
        Case case3 = new Case(Status = 'New', AccountId = acc2.Id);
        Case case4 = new Case(Status = 'Closed', AccountId = acc2.Id);
        insert new List<Case>{case1, case2, case3, case4};

        acc1.Number_of_Open_Cases__c = 0;
        acc1.Number_of_Closed_Cases__c = 0;
        acc2.Number_of_Open_Cases__c = 0;
        acc2.Number_of_Closed_Cases__c = 0;
        update accounts;
    }

    @isTest
    static void testBatchCaseCountUpdate() {
        Account acc1 = [SELECT Id, Number_of_Open_Cases__c, Number_of_Closed_Cases__c FROM Account WHERE Name = 'Test Account 1' LIMIT 1];
        Account acc2 = [SELECT Id, Number_of_Open_Cases__c, Number_of_Closed_Cases__c FROM Account WHERE Name = 'Test Account 2' LIMIT 1];

        System.assertEquals(0, acc1.Number_of_Open_Cases__c, 'should be 0');
        System.assertEquals(0, acc1.Number_of_Closed_Cases__c, 'should be 0');
        System.assertEquals(0, acc2.Number_of_Open_Cases__c, 'should be 0');
        System.assertEquals(0, acc2.Number_of_Closed_Cases__c, 'should be 0');

        Test.startTest();
        UpdateAccountCaseCountsBatch batch = new UpdateAccountCaseCountsBatch();
        Database.executeBatch(batch, 200);
        Test.stopTest();

        acc1 = [SELECT Id, Number_of_Open_Cases__c, Number_of_Closed_Cases__c FROM Account WHERE Name = 'Test Account 1' LIMIT 1];
        acc2 = [SELECT Id, Number_of_Open_Cases__c, Number_of_Closed_Cases__c FROM Account WHERE Name = 'Test Account 2' LIMIT 1];

        System.assertEquals(1, acc1.Number_of_Open_Cases__c, 'should be 1');
        System.assertEquals(1, acc1.Number_of_Closed_Cases__c, 'should be 1');
        System.assertEquals(1, acc2.Number_of_Open_Cases__c, 'should be 1');
        System.assertEquals(1, acc2.Number_of_Closed_Cases__c, 'should be 1');
    }
}