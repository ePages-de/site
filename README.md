# SITe

[ ![Codeship Status for ePages-de/site-prototype](https://codeship.com/projects/2c3bb520-02dd-0133-ab60-36fe44f74615/status?branch=master)](https://codeship.com/projects/89026)

## Installation

```sh
npm install
```

## Usage

Starting the test server:

```sh
NODE_ENV=development npm start
```

Building the JavaScript (Development):

```
NODE_ENV=development gulp build
```

Building the JavaScript (Production):

```
NODE_ENV=production gulp build
```

Watch for changes and build for development:

```
NODE_ENV=development gulp watch
```

## Testing

Tests are run against a caching proxy for the API. When adding new tests you
have to record new responses with `REPLAY=record npm test` and then modify the
new files in ./fixtures/ by deleting the "accept-language" and
"accept-encoding" headers from requests to workaround different chrome version
on your machine and CircleCI

```sh
NODE_ENV=development npm test # or npm run watch to keep running
```
