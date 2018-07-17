# Dataquest documentation

Centralised location for documentation.

## Usage

### Locally

Download the latest Hugo release to a directory on your `PATH`.

https://github.com/gohugoio/hugo/releases

Run the server and visit the link in the output.

```
hugo serve
```

### Docker

* Get Google API credentials from the Cloud Console.
* This service must be run on port 80 for authentication,
  so make sure that port is not already in use.

```
export CLOUD_CLIENT_ID=<google api id>
export NGO_CLIENT_SECRET=<google api secret>
export NGO_TOKEN_SECRET=$(openssl rand -base64 12)

docker build -t dataquestio/docs .
docker run --rm --name docs -it -p 80:80 -e DEBUG=1 -e NGO_CLIENT_ID=$NGO_CLIENT_ID -e NGO_CLIENT_SECRET=$NGO_CLIENT_SECRET -e NGO_TOKEN_SECRET=$NGO_TOKEN_SECRET -e NGO_CALLBACK_SCHEME=http dataquestio/docs
```

Visit `http://localhost/`. You should be redirected to Google oauth for signin.

## Notes

* Markdown/content files are rendered into a sub-directory with and index.html (for nice URLs) so when referencing images always prefix the path with `../`. E.g. if you have a content file called `cats.md` and an `images` directory in the same location, you will need to reference the image as `![Cute](../images/cute.jpg)` as `cats.md` is rendered as `cats/index.html`.