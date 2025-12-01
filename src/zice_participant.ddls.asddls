@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View für Teilnehmer'
define view entity ZICE_Participant
  as select from zce_participant
{
  key participant_uuid as ParticipantUuid,
      participant_id   as ParticipantId,
      first_name       as FirstName,
      last_name        as LastName,
      email            as Email,
      // Wir basteln uns einen vollen Namen für die schöne Anzeige
      concat_with_space(first_name, last_name, 1) as FullName
}
