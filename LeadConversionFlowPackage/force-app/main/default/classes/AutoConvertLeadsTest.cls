@IsTest
public class AutoConvertLeadsTest {
    @IsTest
    static void testLeadAssign() {
        List<Lead> testLeads = new List<Lead>();
        for (Integer i = 0; i < 5; i++) {
            Lead lead = new Lead(
                FirstName = 'Test',
                LastName = 'Lead ' + i,
                Company = 'Test Company',
                Status = 'Open'
            );
            testLeads.add(lead);
        }
        insert testLeads;

        LeadStatus convertedStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];

        List<Id> leadIds = new List<Id>();
        for (Lead testLead : testLeads) {
            leadIds.add(testLead.Id);
        }

        Test.startTest();
        AutoConvertLeads.LeadAssign(leadIds);
        Test.stopTest();

        List<Lead> convertedLeads = [SELECT Id, IsConverted FROM Lead WHERE Id IN :leadIds];
        System.assertEquals(5, convertedLeads.size());
        for (Lead convertedLead : convertedLeads) {
            System.assertEquals(true, convertedLead.IsConverted);
        }
    }
}