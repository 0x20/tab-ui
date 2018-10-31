.pragma library

function get(url, callback) {
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = (function(myxhr) {
        return function() {
            if (xhr.readyState == xhr.DONE)
            callback(myxhr);
        }
    })(xhr);
    xhr.open('GET', url, true);
    xhr.send('');
}

function post(url, body, callback) {
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = (function(myxhr) {
        return function() {
            callback(myxhr);
        }
    })(xhr);
    xhr.open('POST', url, true);
    xhr.send(JSON.stringify(body));
}
