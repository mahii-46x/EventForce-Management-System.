trigger preventDoubleBooking on Event__c (before insert, before update) {
    Set<Id> venueIds = new Set<Id>();
    Set<Date> eventDates = new Set<Date>();

    for (Event__c evt : Trigger.new) {
        if (evt.Venue__c != null && evt.Event_Date__c != null) {
            venueIds.add(evt.Venue__c);
            eventDates.add(evt.Event_Date__c);
        }
    }

    if (!venueIds.isEmpty() && !eventDates.isEmpty()) {
        List<Event__c> existingList = [
            SELECT Id, Venue__c, Event_Date__c 
            FROM Event__c 
            WHERE Venue__c IN :venueIds 
            AND Event_Date__c IN :eventDates
        ];

        for (Event__c newEvt : Trigger.new) {
            if (newEvt.Venue__c != null && newEvt.Event_Date__c != null) {
                for (Event__c existing : existingList) {
                    if (existing.Venue__c == newEvt.Venue__c && 
                        existing.Event_Date__c == newEvt.Event_Date__c && 
                        (Trigger.isInsert || (Trigger.isUpdate && existing.Id != newEvt.Id))) {
                        
                        newEvt.addError('This venue is already booked for the selected date! Please choose another venue or date.');
                        break;
                    }
                }
            }
        }
    }
}
