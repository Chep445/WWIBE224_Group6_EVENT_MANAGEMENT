@EndUserText.label: 'Teilnahmen verwalten'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@UI: { headerInfo: { typeName: 'Teilnahme', typeNamePlural: 'Teilnahmen', title: { type: #STANDARD, value: 'RegistrationId' } } }

define  view entity ZC_Registration
  provider contract transactional_query
  as projection on ZICE_Registration
{
  @UI.facet: [ { id: 'General', purpose: #STANDARD, type: #IDENTIFICATION_REFERENCE, label: 'Allgemein', position: 10 } ]

  @UI.hidden: true
  key RegistrationUuid,

  @UI.lineItem: [ { position: 10 } ]
  @UI.identification: [ { position: 10 } ]
  RegistrationId,

  // --- ANZEIGE KLARTEXTE (statt UUIDs) ---
  @UI.lineItem: [ { position: 20, label: 'Veranstaltung' } ]
  @UI.identification: [ { position: 20, label: 'Veranstaltung' } ]
  _Event.Title as EventTitle,

  @UI.lineItem: [ { position: 30, label: 'Teilnehmer' } ]
  @UI.identification: [ { position: 30, label: 'Teilnehmer' } ]
  _Participant.FullName as ParticipantName,

  // --- STATUS: Filter, Dropdown, Farben & Buttons ---
  @UI.selectionField: [ { position: 10 } ]
  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_StatusVH', element: 'Status' } }]
  @UI.lineItem: [ 
      { position: 40, criticality: 'StatusCriticality' },
      { type: #FOR_ACTION, dataAction: 'approveRegistration', label: 'Approve' }, 
      { type: #FOR_ACTION, dataAction: 'rejectRegistration', label: 'Reject' }
  ]
  @UI.identification: [ { position: 40, criticality: 'StatusCriticality' } ]
  @UI.textArrangement: #TEXT_ONLY
  Status,

  // Hilfsfeld für die Farbe (muss enthalten sein, aber unsichtbar)
  @UI.hidden: true
  StatusCriticality,

  @UI.lineItem: [ { position: 50 } ]
  Remarks,
  
  // Wichtig für das optimistische Sperren (ETag)
  @UI.hidden: true
  LocalLastChangedAt
}
