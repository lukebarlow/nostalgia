var express = require('express'),
    app = express(),
    browserify = require('browserify-middleware'),
    coffeeify = require('caching-coffeeify');

browserify.settings('extensions', ['.coffee','.js'])
browserify.settings('transform', coffeeify)

app.get('/js/nostalgia.js', browserify('src/main.js'))
app.use(express.static(__dirname + '/public'));

module.exports = app;