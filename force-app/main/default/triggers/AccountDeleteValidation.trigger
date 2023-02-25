trigger AccountDeleteValidation on Account (before delete) {

   if (Trigger.isBefore && Trigger.isDelete) {
      List<Contact> currentContacts = [SELECT AccountId FROM Contact WHERE AccountId IN : Trigger.oldMap.keySet()];

      Set<Id> accIds = new Set<Id>();
      for (Contact contact : currentContacts) {
          accIds.add(contact.accountId);
      }

      for (Account account : trigger.old) {
         if (accIds.contains(account.Id)) {
             account.addError('Account cannot be deleted while contacts are related');
         }
      }    
   }
}