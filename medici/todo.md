# TODOS

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
- [ ] setup notifications
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
