# TODOS

## ALL

- [x] use named routing

## Notifications

- [ ] identify why sometimes the app freezes on splash screen after calling `Datetime.now().timeZoneName`

## Cards

- [x] update default image
- [x] fix middle text size
- [x] fix image height
- [x] fix red bar size
- [x] add an Icon to show that's archived
- [x] change text for late meds from `Em x horas` to `Atrasado a x horas`

## Image Area

- [x] fix image area width

## Forms

- [ ] fix slowness
- [x] disable button on submit
- [x] add a status `sending...`

## Input Hour

- [x] zero padding

## Add

- [x] setup notifications

## Edit

- [x] update notifications
- [ ] fix first update issue

## Home

- [x] Modal
- [x] update alert status on modal button click (aware and taken)
- [x] update amount
- [x] check if there's enough
- [x] show only the next drug and late ones
- [x] late comes first
- [x] change `RestartableTimer` to `Timer.Periodic`
- [ ] fix get data
- [x] update time period to check remaining drugs to take(use 5s)
- [x] reduce the amount of medicine when click on modal

## Drugs

- [x] reset status after 24h
- [x] check last Day (archive drug and remove notifications)
- [x] add recurrent mark
- [x] add a lastDay mark
- [ ] quantity alert action to refill amount
- [x] fix scheduled alarms
- [x] what happens when you confirm you have taken the medicine in both modal and notification (check if the difference of time between `last_interaction` and `.now()` is, at least, the same as the time division)
- [x] update last interaction
- [x] don't let the quantity be less than 1
- [ ] handle new drug (after expiration) and new quantity, create a page for that
- [x] quantity notifications have even negative numbers as ID and expiration ones have odd negative IDs
- [ ] quantity and expiration notifications redirect to another pages
- [x] create notification for expiration before `expiration_offset` days
- [x] add and remove quantity and expiration notifications
  - [x] add.dart
  - [x] edit.dart
  - [x] drug.dart
- [ ] add a way to refill/renew drug on drug screen

## Drugs list

- [x] show only one drug each
- [x] refactor get all Drugs to get only the drug data of unique drugs

---

## ALL

- [x] remove appBar
- [ ] fix layout width/height
- [ ] navbar center padding icons
- [ ] bottom bar - remove unnecessary things
- [ ] dose type to enum
- [x] create a DB as a class
- [x] pass an instance of a DB class throughout the application
- [ ] fix Icon Buttons Widgets. Set it as IconButton SubClasses
- [x] update icon color on bottom bar
- [x] ensure that bottom bar won't push to the same screen
- [ ] extract error message to a separated widget

## Add

- [ ] fix top bar
- [x] permissions to access camera, files and notifications
- [x] handle images (camera/files)
- [x] db insert drug function
- [x] add db model
- [x] open calendar
- [x] setup notifications
- [x] refactor take photo func.
- [ ] pad time with zeros

## Forms

- [x] pass a controller to each input
- [x] change all elements to `Stateful`
- [x] set input date and input time as `textFormField`s
- [x] fix keyboard overlapping
- [ ] check if submit is enabled or not (change styles as well)
- [ ] fix image area size
- [x] add frequency text
- [x] add starting time
- [x] (edit page) get time offsets
- [ ] refactor submit to a single function in db
- [x] (edit page) fix: `Another exception was thrown: LateInitializationError: Field 'name' has not been initialized.`
- [x] (edit page) fix late

## HOME

- [x] scroll view
- [x] get drugs
- [x] create cards
- [x] fix `type 'int' is not a subtype of type 'double' in type cast`
- [ ] add title
- [x] order by time
- [x] fix time diff, once if the next time to take is tomorrow, the diff is smaller than doses for today late
- [x] reload after coming back from drug page
- [x] get drugs that are need to be taken today
- [ ] get alerts that are neither `taken` nor `late`

## CARDS

- [x] fix middle text size
- [ ] fix image height
- [ ] fix card image
- [ ] update default image
- [ ] fix red bar size
- [ ] add an Icon to show that's archived

## Drugs

- [ ] already taken status
- [ ] drug status (archived, expired, drugs finished)
- [ ] check for Tomorrow filter
- [ ] update status indicator widget
- [ ] add status for each alert
- [ ] remove notifications after deleting the medicine
- [ ] delete and add new notifications after updating drug

- `aware`, `taken`, `late`, `pending`

## Drug page

- [x] add notification settings
- [x] get everything related to that
- [x] archive
- [x] unarchive from drugs list
- [ ] update style for archive/unarchive button
- [x] delete
- [x] edit
- [x] error text
- [x] update default image
- [ ] fix schedule component for one dose
- [ ] add recurrent status

## Leaflet

- [ ] fix JWT expiration date
