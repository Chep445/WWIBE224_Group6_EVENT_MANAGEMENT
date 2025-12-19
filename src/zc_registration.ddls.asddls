@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View Registration'
define view entity ZC_REGISTRATION
  as projection on ZR_REGISTRATION
{
  key RegistrationUuid,
      RegistrationId,
      EventUuid,
      ParticipantUuid,
      Status,
      Remarks,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      _Event : redirected to parent ZC_EVENT,
      _Participant,
      
      _Participant.ParticipantId as ParticipantId,
      _Participant.FirstName     as ParticipantFirstName,
      _Participant.LastName      as ParticipantLastName,
      _Participant.Email         as ParticipantEmail,
      _Participant.Phone         as ParticipantPhone
}
