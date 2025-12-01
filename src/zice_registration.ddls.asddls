@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Registration Interface View'
define root view entity ZICE_Registration
  as select from zce_registration
  
  // Falls Sie die Namen anzeigen wollen, lassen Sie die Associations drin:
  association [0..1] to ZICE_Event       as _Event       on $projection.EventUuid       = _Event.EventUuid
  association [0..1] to ZICE_Participant as _Participant on $projection.ParticipantUuid = _Participant.ParticipantUuid
{
  key registration_uuid as RegistrationUuid,
      registration_id   as RegistrationId,
      event_uuid        as EventUuid,
      participant_uuid  as ParticipantUuid,
      status            as Status,
      
      /* Berechnung der Farbe für den Status (Criticality) */
      case status
        when 'Approved' then 3 -- Grün
        when 'Rejected' then 1 -- Rot
        when 'New'      then 2 -- Gelb/Neutral
        else 0
      end               as StatusCriticality,

      remarks           as Remarks,
      
      @Semantics.user.createdBy: true
      created_by        as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at        as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by   as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at   as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      
      // Public Associations
      _Event,
      _Participant
}
