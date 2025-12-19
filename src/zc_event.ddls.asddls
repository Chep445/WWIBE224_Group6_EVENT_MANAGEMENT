@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View Event'
define root view entity ZC_EVENT
  provider contract transactional_query
  as projection on ZR_Event
{
  key EventUuid,
      EventId,
      Title,
      Location,
      StartDate,
      EndDate,
      MaxParticipants,
      Status,
      StatusText,
      Description,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      _Registrations : redirected to composition child ZC_REGISTRATION        
}
