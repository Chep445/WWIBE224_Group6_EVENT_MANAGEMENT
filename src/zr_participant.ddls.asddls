@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic View Participant'
define view entity ZR_PARTICIPANT
  as select from zce_participant
{
  key participant_uuid       as ParticipantUuid,
      participant_id         as ParticipantId,
      first_name             as FirstName,
      last_name              as LastName,
      email                  as Email,
      phone                  as Phone,
      created_by             as CreatedBy,
      created_at             as CreatedAt,
      last_changed_by        as LastChangedBy,
      last_changed_at        as LastChangedAt,
      local_last_changed_at  as LocalLastChangedAt
}
