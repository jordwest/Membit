$(document).ready ->
  jQuery.timeago.settings.allowFuture = true;
  $('abbr.timeago').timeago()