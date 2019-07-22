/**
 * Congo Javascript library
 */

var Congo = Congo || {};

Congo.namespace = function (ns_string) {
  var parts = ns_string.split('.'),
  parent = Congo,
  i;
  // strip redundant leading global
  if (parts[0] === "Congo") {
    parts = parts.slice(1);
  }
  for (i = 0; i < parts.length; i += 1) {
    // create a property if it doesn't exist
    if (typeof parent[parts[i]] === "undefined") {
      parent[parts[i]] = {};
    }

    parent = parent[parts[i]];
  }
  return parent;
}

Congo.exec = function( controller, action ) {
  if ( controller !== "" && Congo[controller] && action !== "" && typeof Congo[controller][action] == "object" && typeof Congo[controller][action].init == "function" ) {
    Congo[controller][action].init();
  }
}

Congo.init = function() {
  //Index doesn't exist in IE8, that's why I'm using this patchs
  if (!Array.prototype.indexOf) {
    Array.prototype.indexOf = function(elt /*, from*/) {
      var len = this.length >>> 0;

      var from = Number(arguments[1]) || 0;
      from = (from < 0) ? Math.ceil(from) : Math.floor(from);

      if (from < 0)
        from += len;

      for (; from < len; from++) {
        if (from in this && this[from] === elt)
          return from;
      }

      return -1;
    };
  }
  //end patch
  
  var body = document.body,
    controller = body.getAttribute( "data-controller" ).replace(/\//g, "_"),
    action = body.getAttribute( "data-action" );
  Congo.exec("common");
  Congo.exec(controller, action);
}

$(document).ready(Congo.init);
