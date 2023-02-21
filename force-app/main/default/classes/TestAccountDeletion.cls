@isTest
private class TestAccountDeletion {
    @isTest static void TestAccountDeleteValidation() {

        Account acct = new Account(Name='Test Account');
        insert acct;
        Contact con = new Contact(FirstName='John', LastName= ' Smith',
                                       AccountId=acct.Id);
        insert con;
        // Perform test
        Test.startTest();
        Database.DeleteResult result = Database.delete(acct, false);
        Test.stopTest();
        // Verify 
        // In this case the deletion should have been stopped by the trigger,
        // so verify that we got back an error.
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('Account cannot be deleted while contacts are related',
                             result.getErrors()[0].getMessage());
    }
}