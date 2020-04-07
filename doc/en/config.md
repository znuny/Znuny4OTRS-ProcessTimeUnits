# Configuration

For technical reasons, working hours can only be recorded and filed together with an article, which is why this add-on creates at least one article per ticket. Its attributes can be defined in the System Configuration. There it is also set whether only one article per ticket or a new one is created for each recorded time.

Changing the settings may affects existing and new tickets.

## Show time accounting field in an Activity Dialog
To record the time, the dynamic field `ProcessTimeUnits` must be added to a dialog.

## System Configuration

### Subject of the article
The text from `Znuny4OTRSProcessTimeUnits::Article###Subject` is used as the subject for the created article.

### Body of the article
The text from the setting `Znuny4OTRSProcessTimeUnits::Article###Body` is used for the content of the article.

### Sendertype
With  `Znuny4OTRSProcessTimeUnits::Article###SenderType` is selected who created the article:
- the **system**,
- the **customer**, or
- the **agent** (default)
The type cannot be changed subsequently for existing articles.

### Number of articles
With `Znuny4OTRSProcessTimeUnits::ArticleCreateOnce` you determine whether a only one article should be created per ticket or one for each recorded accounting time.
