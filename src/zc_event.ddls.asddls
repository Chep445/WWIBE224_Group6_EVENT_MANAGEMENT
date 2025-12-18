@EndUserText.label: 'Event App'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_Event
  provider contract transactional_query
  as projection on ZICE_Event
{
  key EventUuid,
  
  @UI.lineItem: [{ position: 10 }]
  @UI.selectionField: [{ position: 10 }]
  EventId,
  
  @UI.lineItem: [{ position: 20 }]
  Title,
  
  @UI.lineItem: [{ position: 30 }]
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.7
  Location,
  
  @UI.lineItem: [{ position: 40 }]
  @UI.selectionField: [{ position: 20 }]
  StartDate,
  
  @UI.lineItem: [{ position: 50 }]
  EndDate,
  
  @UI.lineItem: [{ position: 60, label: 'Status' }]
  StatusText,

  /* Buttons für Actions */
  @UI.lineItem: [
    { type: #FOR_ACTION, dataAction: 'openEvent', label: 'Open event', position: 70 },
    { type: #FOR_ACTION, dataAction: 'closeEvent', label: 'Close event', position: 80 }
  ]
  LocalLastChangedAt
}
