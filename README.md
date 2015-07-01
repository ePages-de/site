# SITe


## Installation

```sh
npm install
```

## Usage

Starting the test server:

```sh
npm start
```

Building the JavaScript (Development):

```
gulp build
```

Building the JavaScript (Production):

```
NODE_ENV=production gulp build
```

Watch for changes and build for development:

```
gulp watch
```

## Testing

```sh
npm install -g karma-cli # run once to have the karma binary handy

karma start karma.conf.coffee
```
