@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Registration Interface View'
define view entity ZICE_Registration
  as select from zce_registration
  association to parent ZICE_Event as _Event
    on $projection.EventUuid = _Event.EventUuid
  association [0..1] to ZICE_Participant as _Participant
    on $projection.ParticipantUuid = _Participant.ParticipantUuid
{
  key registration_uuid        as RegistrationUuid,
      registration_id          as RegistrationId,

      event_uuid               as EventUuid,
      participant_uuid         as ParticipantUuid,

      status                   as Status,
      case status 
        when 'Approved' then 3 
        when 'Rejected' then 1
        when 'New' then 2
        else 0
        end as StatusCriticality,
      remarks                  as Remarks,

      @Semantics.user.createdBy: true
      created_by               as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at               as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by          as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at          as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at    as LocalLastChangedAt,

      _Event,
      _Participant
}
