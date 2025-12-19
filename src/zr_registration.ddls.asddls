@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic View Registration'
define view entity ZR_REGISTRATION
  as select from zce_registration

  association to parent ZR_Event        as _Event
    on $projection.EventUuid = _Event.EventUuid

  association to ZR_PARTICIPANT         as _Participant
    on $projection.ParticipantUuid = _Participant.ParticipantUuid
{
  key registration_uuid     as RegistrationUuid,
      registration_id       as RegistrationId,
      event_uuid            as EventUuid,
      participant_uuid      as ParticipantUuid,
      status                as Status,
      remarks               as Remarks,
      created_by            as CreatedBy,
      created_at            as CreatedAt,
      last_changed_by       as LastChangedBy,
      last_changed_at       as LastChangedAt,
      local_last_changed_at as LocalLastChangedAt,

      _Event,
      _Participant
}
