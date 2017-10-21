String.prototype.format = function() {
    var s = this,
        i = arguments.length;

    while (i--) {
        s = s.replace(new RegExp('\\{' + i + '\\}', 'gm'), arguments[i]);
    }
    return s;
};

function parseJSONData(JSONString) {
  return jQuery.parseJSON(JSONString)  
}

function toggle($targetContainer) {
    if ($targetContainer.is(':visible')) {
        $targetContainer.slideUp('fast');
        return false;
    } else {
        //$targetContainer.attr('style', "display: none");
        $targetContainer.slideDown('fast');
        return true;
    }

}