//function iOSOrAndroid() {
//    var u = navigator.userAgent;
////    var isAndroid = u.indexOf('Android') > -1 || u.indexOf('Adr') > -1;
//    var isiOS = u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/);
//    return isiOS;
//}

function changeNavigationBarColor(color) {
//    if (iOSOrAndroid()) {
        window.webkit.messageHandlers.changeNavigationBarColor.postMessage(color);
//    }
}

function imageSourceStringFromPoint(x, y) {
    var element = document.elementFromPoint(x, y);
    if (element.tagName == 'IMG' && element.src) {
        var rect = element.getBoundingClientRect();
        return element.src;
    }
    return null;
}