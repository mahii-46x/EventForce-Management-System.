@isTest
private class preventDoubleBookingTest {
    @isTest
    static void testPreventDoubleBooking() {
        // Sample Venue Record
        Venue__c venue = new Venue__c(Name = 'Grand Palace');
        insert venue;

        // Sample Client Record
        Client__c client = new Client__c(Name = 'Test Client');
        insert client;

        // First Booking - Should succeed
        Event__c event1 = new Event__c(
            Name = 'Tech Conference',
            Venue__c = venue.Id,
            Client__c = client.Id,
            Event_Date__c = Date.today().addDays(5)
        );
        insert event1;

        // Second Booking on same Date & Venue - Should fail
        Event__c event2 = new Event__c(
            Name = 'Design Summit',
            Venue__c = venue.Id,
            Client__c = client.Id,
            Event_Date__c = Date.today().addDays(5)
        );

        Test.startTest();
        try {
            insert event2;
            System.assert(false, 'Expected DMLException for double booking was not thrown');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('This venue is already booked'), 'Expected double booking error message');
        }
        Test.stopTest();
    }
}
