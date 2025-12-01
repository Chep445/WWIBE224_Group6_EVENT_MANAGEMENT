@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View für Events'
define view entity ZICE_Event
  as select from zce_event
{
  key event_uuid as EventUuid,
      event_id   as EventId,
      title      as Title,
      location   as Location,
      start_date as StartDate
}
