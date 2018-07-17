---
title: Creating and sending e-mail with Mailjet
---

{{< highlight go >}} A bunch of code here {{< /highlight >}}

We used to send e-mails using SESand a convoluted jinja2 templating process
that was really hard to test and introspect. We still use those in a lot of
places, using templates in `mainstack/server/util/email`. Those templates were
generated from [MJML](https://mjml.io/) templates that are stored in the
`email-templates` repo.

We have migrated our most important templates to be hosted on
[mailjet](https://mailjet.com), where they can be easily edited using either
their drag and drop UI called Passport or their online MJML editor.

## Mailjet Account

You'll need a mailjet account to edit templates and check out stats.
You'll need to be added to the company shared account, 'vik@dataquest.io'. I
think Vik is the only person who has permission to add you to the account for
now.

I find mailjet can be a bit opaque about whether you are in your personal
account, -- which you'll never use -- or your shared dataquest account.
There is a dropdown in the right side of the top toolbar where you can switch
between "Main API key" and "vik@dataquest.io". Select the latter.

![shared account dropdown](../images/mailjet_account_dropdown.png)

## Creating the templates
Mailjet provides
[good documentation](https://dev.mailjet.com/template-language/)
on how to create templates in MJML and Passport. You should read it,
but I found that it didn't answer my most pressing questions
without quite a bit of research, so here's a quick cheatsheet:

 *  The [template manager[(https://app.mailjet.com/templates/transactional) can
 be hard to find, so there's a link to it. I have had to file a support ticket to
 get them to fix permissions on this. Do that if it redirects to dashboard or a
 restricted dashboard page.
 *  In a template, you need to prefix variables with `var:`. So the syntax to
 include a variable that was sent as part of the template payload, you would
 want to reference `{{var:name_from_context:"Default Value"}}`.
 *  You can nest json objects in the context. The nested variable lookup is
 standard `.` notation: `{{var:outer.inner.innerer:"Default Value"}} would
 do the expected looku in a JSON of `{outer: {inner: {innerer: 'value}}}`.
 *  If a variable in the context is a list, you can loop over it using:

    ```jinja
    <mj-raw>{% for item in var:list_of_items %}</mj-raw>
    {{item}}
    <mj-raw>{% endfor %}</mj-raw>
    ```
 Note that you don't need to use `var` in front of the individual item from the
 list once inside the loop.
 *  If you are inserting loops into the visual editor, you don't need the
 `mj-raw` tags.
 *  Conditionals look like `{% if var:condition %}yes{% else %}no{% endif %}`,
 and must also be wrapped in `<mj-raw>` tags.
 *  The user interface has a basic template testing feature that allows you to
 set variables, but it doesn't work yet with complex data structures like loops
 and conditionals.

## Sending non-mailjet template mail from Django
We send all our mail through Django, but we haven't migrated all our templates
to the mailjet UI yet.

We use [django-mailjet](https://github.com/kidig/django-mailjet)
as a django e-mail backend for mailjet. It seems to be abandonware, but the
code looks maintainable enough if we want to take over. There is a fork that
migrates the API to mailjet 3.1, but it looks like the code was written by an
intern. I tried it briefly and it failed, so I decided to stay with the more
stable version.

Our mail is (generally) sent through the two functions in
`mainstack/server/util.email`. These functions just work if you want to send a
text object or old-school html template.

## Sending mailjet template mail from Django

If you want to send a mailjet template e-mail instead, these are the steps to
follow:

 *  Create the template in Mailjet
 *  When you save the template, it will give you a template ID. They label it
    'test id' for some reason, but the word 'test' is a misnomer. Copy it.
 *  Open `mainstack/dsserver/settings.py` and find the `MAILJET_TEMPLATE_IDS`
    section. This is a map of human readable template names to the integer id
    you just copied. I suggest using the same name for the template that you
    used when you saved the template in mailjet.
 *  You'll probably be sending the e-mail using `send_mail_delay`. You call it
    like so:

    ```
    send_mail_delay(
        subject='',
        template_name='human_readable_name',
        vars={'variable': 'dictionary'},
        from_email=settings.DEFAULT_FROM_EMAIL_NOREPLY,
        user_id=user.id,
        unsubscribe=True,
        is_mailjet=True)
    ```

    Notes:
     *  Using an empty string for `subject` tells mailjet to use the subject
        associated with the template
     *  `template_name` should be the name you used above in
        `MAILJET_TEMPLATE_IDS`.
     *  `vars` is a json-serializable dict that maps to the `var:` template
        variables described above in "Creating a template".
     *  `is_mailjet=True` is what tells the send_mail function to look up a
        mailjet template by the id you defined, rather than trying to load a
        jinja template from `util/email`.

## Debugging

Mailjet is pretty bad for debugging templates. If you have an error in your
template it just tells you the message was 'blocked' in the Mailjet stats
interface, but it won't say why. In order to get any information about the
error, you need to pass an e-mail address to send the error to.

This is really annoying because it means you have to run the service locally
in order to set the e-mail that the message gets sent to. See the
[instructions](../local-install/) for a local install. It's not easy.

Once you have it running on localhost and you want to test e-mails:

 *  Get the Mailjet API keys from somebody and put them in `dsserver/private.py`
    (create it if it doesn't exist). You also need to tell it to use the mailjet
    e-mail backend. Should look something like this (these won't work,
    I made them up):

    ```
    MAILJET_API_KEY = '5c252dff969c22acc4efcc5860f6fd45'
    MAILJET_API_SECRET = '24f352f29ffcb9215a5aaea2698e64f2'
    EMAIL_BACKEND = 'django_mailjet.backends.MailjetBackend'

    ```

That should send a real e-mail whenever you call a function that sends one.
Make a user with your e-mail address and initiate an action that sends an
e-mail.

To get the template error messages, change the `MAILJET_ERROR_FORWARD`
variable in `dsserver/settings.py` to point to your e-mail address. If you don't
do this, you'll be spamming Dusty and he'll get grumpy.

I recommend commenting (prepend with a `#`) the EMAIL_BACKEND line in your
`private.py` when you are doing regular local development. Otherwise you'll have
real live e-mails going out unexpectedly, and that would be unfortunate.

If you need to do some quick and dirty debugging on the Mailjet API, you can
put a breakpoint right after `msg.send()` (currently the last line) in
`util/email.py`. Then print the value of `msg.mailjet_response`.

### Who writes template e-mails?

In general, I expect that marketing and CS people will be creating most of the
templates in mailjet, with some communication with eng to identify good variable
names.

Then the engineer can hook up the templates and test on localhost as described
above. They might have to tweak the templates a bit if there are errors.

## Migrating templates

Our existing templates are already in mjml format and they live
[here](https://gitlab.dataquest.io/dataquestio/email-templates/tree/master/full_templates)

Note: There is a `templates` directory in that repo too, but the `full_templates`
are the ones that you want to use for migration.

Unfortunately, those templates use Jinja syntax for variable substitution, which
isn't completely backwards compatible with the less sophisticated mailjet
templates.

To migrate, you'll need to:

 *  Change any variables inside of `{{` and `}}` tags to have a `var:` prefix.
    So `{{name}}` becomes `{{var:name}}`.
 *  Probably add a default value for all variables. So
    `{{name}} becomes `{{name:"Default Student"}}`
 *  Remove any filters from variable names. This is a bit tricky. The easy part
    is removing the filters, which is anything after a `|` character in a
    variable. So `{{name|title}}` becomes just `{{name}}`. The hard part is that
    now you need to do the job of the filter before you pass it into the
    template's variable dict. In the case of `title`, you'd need to call
    `{'name': 'name.title()'` when calling the `send_mail` function.
 *  Convert any complex objects to json-serializable format. So instead of
    passing a `missions.models.Mission` object, pass
    `{mission: {name: mission.name, sequence: mission.sequence}}`
 *  When looping over a variable, remember to give it the `var:` prefix.
