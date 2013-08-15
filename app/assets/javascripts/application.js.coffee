#= require jquery
#= require jquery_ujs
#= require date-en-US
#= require underscore-min
#= require jquery.timeago
#= require highcharts
#= require_tree .

$(document).ready ->
	$("abbr.timeago").timeago()
	$(".game").on "dblclick", ->
		$(this).find(".delete-link").removeClass "is-hidden"
