@isTest
public with sharing class OpenClosedCaseTriggerTest {
    @TestSetup
    static void setupTestData() {
        Account acc1 = new Account(Name = 'Test Account 1');
        Account acc2 = new Account(Name = 'Test Account 2');
        insert new List<Account>{ acc1, acc2 };

        Case case1 = new Case(Status = 'New', AccountId = acc1.Id);
        Case case2 = new Case(Status = 'Closed', AccountId = acc1.Id);
        Case case3 = new Case(Status = 'New', AccountId = acc2.Id);
        Case case4 = new Case(Status = 'Closed', AccountId = acc2.Id);
        insert new List<Case>{ case1, case2, case3, case4 };
    }

    @isTest
    static void testAfterInsert() {
        Account acc = new Account(Name = 'Test Insert Account');
        insert acc;

        Case openCase = new Case(Status = 'New', AccountId = acc.Id);
        Case closedCase = new Case(Status = 'Closed', AccountId = acc.Id);

        Test.startTest();
        insert new List<Case>{ openCase, closedCase };
        Test.stopTest();

        Account updatedAcc = [SELECT Number_of_Open_Cases__c, Number_of_Closed_Cases__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(1, updatedAcc.Number_of_Open_Cases__c, 'should be 1');
        System.assertEquals(1, updatedAcc.Number_of_Closed_Cases__c, 'should be 1');
    }

    @isTest
    static void testAfterUpdate() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account 1' LIMIT 1];
        Case testCase = [SELECT Id, Status FROM Case WHERE AccountId = :acc.Id AND Status = 'New' LIMIT 1];

        testCase.Status = 'Closed';

        Test.startTest();
        update testCase;
        Test.stopTest();

        Account updatedAcc = [SELECT Number_of_Open_Cases__c, Number_of_Closed_Cases__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(0, updatedAcc.Number_of_Open_Cases__c, 'should be 0');
        System.assertEquals(2, updatedAcc.Number_of_Closed_Cases__c, 'should be 2');
    }

    @isTest
    static void testAfterDelete() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account 2' LIMIT 1];
        Case testCase = [SELECT Id FROM Case WHERE AccountId = :acc.Id AND Status = 'New' LIMIT 1];

        Test.startTest();
        delete testCase;
        Test.stopTest();

        Account updatedAcc = [SELECT Number_of_Open_Cases__c, Number_of_Closed_Cases__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(0, updatedAcc.Number_of_Open_Cases__c, 'should be 0');
        System.assertEquals(1, updatedAcc.Number_of_Closed_Cases__c, 'should be 1');
    }

    @isTest
    static void testAfterUndelete() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account 2' LIMIT 1];
        Case testCase = [SELECT Id FROM Case WHERE AccountId = :acc.Id AND Status = 'New' LIMIT 1];

        delete testCase;
        Test.startTest();
        undelete testCase;
        Test.stopTest();

        Account undeletedAcc = [SELECT Number_of_Open_Cases__c, Number_of_Closed_Cases__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(1, undeletedAcc.Number_of_Open_Cases__c, 'should be 1');
        System.assertEquals(1, undeletedAcc.Number_of_Closed_Cases__c, 'should be 1');
    }
}