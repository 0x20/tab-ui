.pragma library
.import QuickPromise 1.0 as QP

function get(url) {
    return new QP.Q.Promise(function (resolve, reject) {
        var xhr = new XMLHttpRequest();
        console.log("XHR created for " + url);
        xhr.onreadystatechange = (function(myxhr) {
            return function() {
                if (myxhr.readyState === 4) {
                    if (myxhr.status !== 200) {
                        reject(myxhr);
                    } else {
                        resolve(myxhr);
                    }
                    //console.log("XHR response for " + url + ": " + myxhr.status + " - " + myxhr.statusText);
                }
            };
        })(xhr);
        xhr.open('GET', url, true);
        xhr.send();
    })
}

function post(url, body) {
    return new QP.Q.Promise(function (resolve, reject) {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = (function(myxhr) {
            return function() {
                if (myxhr.readyState === 4) {
                    if (myxhr.status !== 200) {
                        reject(myxhr);
                    } else {
                        resolve(myxhr);
                    }
                    //console.log("XHR response for " + url + ": " + myxhr.status + " - " + myxhr.statusText);
                }
            };
        })(xhr);
        xhr.open('POST', url, true);
        xhr.setRequestHeader("Content-Type", "application/json");
        xhr.send(JSON.stringify(body));
    })
}
