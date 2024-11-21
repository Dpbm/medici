# TODOS

## Main

- [x] check notification denied
- [x] check notification denied then accepted when already open ['user may need to restart the app']
- [x] check notification denied then accepted when closed
- [x] check takeMed function when click on `delay`
- [x] check takeMed function when click on `take`
- [x] check the edit when expired foreground and background
- [x] check the edit when quantity foreground and background
- [x] check take med notification foreground and background
- [x] check if background notifications work when accepted at first

## ALL

- [x] use DateTime for everything
- [x] fix logError
- [x] add `debugPrint` for each error
- [x] use named routing
- [x] remove appBar
- [x] fix layout width/height
- [x] navbar center padding icons
- [x] bottom bar - remove unnecessary things
- [x] dose type to enum
- [x] create a DB as a class
- [x] pass an instance of a DB class throughout the application
- [x] fix Icon Buttons Widgets. Set it as IconButton SubClasses
- [x] update icon color on bottom bar
- [x] ensure that bottom bar won't push to the same screen
- [x] extract error message to a separated widget

## Notifications

- [x] identify why sometimes the app freezes on splash screen after calling `Datetime.now().timeZoneName`
- [x] test don't allow notifications
- [x] add `showUserInterface=true`
- [x] fix open on edit page when clicked

## Cards

- [x] update default image
- [x] fix middle text size
- [x] fix image height
- [x] fix red bar size
- [x] add an Icon to show that's archived
- [x] change text for late meds from `Em x horas` to `Atrasado a x horas`
- [x] fix middle text size
- [x] fix image height
- [x] fix card image
- [x] update default image
- [x] fix red bar size
- [x] add an Icon to show that's archived
- [x] added expired and not enough status

## Image Area

- [x] fix image area width

## Forms

- [x] fix slowness
- [x] disable button on submit
- [x] add a status `sending...`
- [x] pass a controller to each input
- [x] change all elements to `Stateful`
- [x] set input date and input time as `textFormField`s
- [x] fix keyboard overlapping
- [x] check if submit is enabled or not (change styles as well)
- [x] fix image area size
- [x] add frequency text
- [x] add starting time
- [x] (edit page) get time offsets
- [x] refactor submit to a single function in db
- [x] (edit page) fix: `Another exception was thrown: LateInitializationError: Field 'name' has not been initialized.`
- [x] (edit page) fix late

## Input Hour

- [x] zero padding

## Add

- [x] setup notifications
- [x] fix top bar
- [x] permissions to access camera, files and notifications
- [x] handle images (camera/files)
- [x] db insert drug function
- [x] add db model
- [x] open calendar
- [x] setup notifications
- [x] refactor take photo func.
- [x] pad time with zeros

## Edit

- [x] update notifications
- [x] fix first update issue

## Home

- [x] Modal
- [x] update alert status on modal button click (aware and taken)
- [x] update amount
- [x] check if there's enough
- [x] show only the next drug and late ones
- [x] late comes first
- [x] change `RestartableTimer` to `Timer.Periodic`
- [x] fix get data
- [x] update time period to check remaining drugs to take(use 5s)
- [x] reduce the amount of medicine when click on modal
- [x] scroll view
- [x] get drugs
- [x] create cards
- [x] fix `type 'int' is not a subtype of type 'double' in type cast`
- [x] add title
- [x] order by time
- [x] fix time diff, once if the next time to take is tomorrow, the diff is smaller than doses for today late
- [x] reload after coming back from drug page
- [x] get drugs that are need to be taken today
- [x] get alerts that are neither `taken` nor `late`
- [x] fix filter that is not showing the new med as late at first
- [x] fix modal text padding and margin

## Drugs

- [x] reset status after 24h
- [x] check last Day (archive drug and remove notifications)
- [x] add recurrent mark
- [x] add a lastDay mark
- [x] quantity alert action to refill amount
- [x] fix scheduled alarms
- [x] what happens when you confirm you have taken the medicine in both modal and notification (check if the difference of time between `last_interaction` and `.now()` is, at least, the same as the time division)
- [x] update last interaction
- [x] don't let the quantity be less than 1
- [x] handle new drug (after expiration) and new quantity, create a page for that
- [x] quantity notifications have even negative numbers as ID and expiration ones have odd negative IDs
- [x] quantity and expiration notifications redirect to another pages
- [x] create notification for expiration before `expiration_offset` days
- [x] add and remove quantity and expiration notifications
  - [x] add.dart
  - [x] edit.dart
  - [x] drug.dart
- [x] add a way to refill/renew drug on drug screen
- [x] already taken status
- [x] drug status (archived, expired, drugs finished)
- [x] check for Tomorrow filter
- [x] update status indicator widget
- [x] add status for each alert
- [x] remove notifications after deleting the medicine
- [x] delete and add new notifications after updating drug
- [x] add notification settings
- [x] get everything related to that
- [x] archive
- [x] unarchive from drugs list
- [x] update style for archive/unarchive button
- [x] delete
- [x] edit
- [x] error text
- [x] update default image
- [x] fix schedule component for one dose
- [x] add recurrent status
- [x] handle when expiration is today
- [x] handle when lastDay is today
- [x] handle different drug status (update on edit, on add, on take drug) (statuses: current, archived, refill, expired)

- `aware`, `taken`, `late`, `pending` statuses

## Drugs list

- [x] show only one drug each
- [x] refactor get all Drugs to get only the drug data of unique drugs

## Leaflet

- [x] fix JWT expiration date
