@EndUserText.label: 'Event App'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true   
define root view entity ZC_Event
  provider contract transactional_query
  as projection on ZICE_Event
{
  key EventUuid,

  /* [cite: 24, 31] Anzeige + Filter nach interner Nummer */
  @UI.lineItem: [{ position: 10 }]
  @UI.selectionField: [{ position: 10 }]
  EventId,

  /* [cite: 24] Title */
  @UI.lineItem: [{ position: 20 }]
  Title,

  /* [cite: 24, 32] Location + Unschärfesuche 0.7 */
  @UI.lineItem: [{ position: 30 }]
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.7
  Location,

  /* [cite: 24, 31] StartDate + Filter */
  @UI.lineItem: [{ position: 40 }]
  @UI.selectionField: [{ position: 20 }]
  StartDate,

  /* [cite: 24] EndDate */
  @UI.lineItem: [{ position: 50 }]
  EndDate,

  /* [cite: 24, 25] StatusText anzeigen */
  @UI.lineItem: [{ position: 60, label: 'Status' }]
  StatusText,

  /* Buttons für Actions [cite: 41, 42] */
  @UI.lineItem: [
    { type: #FOR_ACTION, dataAction: 'openEvent', label: 'Open event', position: 70 },
    { type: #FOR_ACTION, dataAction: 'closeEvent', label: 'Close event', position: 80 }
  ]
  
  LocalLastChangedAt
}
