Public class AutoConvertLeads
{      @InvocableMethod
    public static void LeadAssign(List<Id> LeadIds)
        {
            LeadStatus CleadStatus= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true Limit 1];
            List<Database.LeadConvert> MassLeadconvert = new List<Database.LeadConvert>();
            for(id currentlead: LeadIds){
                Database.LeadConvert Leadconvert = new Database.LeadConvert();
                Leadconvert.SetLeadId(currentlead);
                Leadconvert.setConvertedStatus(CleadStatus.MasterLabel);
                MassLeadconvert.add(Leadconvert);
        }
        if (!MassLeadconvert.isEmpty())
        {
            List<Database.LeadConvertResult> lcr = Database.convertLead(MassLeadconvert);
        }
    }
}