<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<link href="../css/style.css" rel="stylesheet" type="text/css">
<link href="../css/unit.css" rel="stylesheet" type="text/css">
<link href="../css/loading.css" rel="stylesheet" type="text/css">
<link href='../css/fullcalendar.css' rel='stylesheet' type='text/css' />
<link href='../css/fullcalendar.print.css' rel='stylesheet' type='text/css'  media='print' />
<link href='../themes/vbi-theme/jquery.ui.all.css' rel='stylesheet' type='text/css'  />

<script src="../js/jquery.min.js" type="text/javascript"></script>
<script src="../js/ui/jquery-ui-1.8.10.custom.js" type="text/javascript"></script>
<script src="../js/fullcalendar.js" type="text/javascript"></script>
<script src="../js/thickbox.js" type="text/javascript"></script>
<script src="../js/loading.js" type="text/javascript"></script>
<script src="../js/popup.js" type="text/javascript"></script>

<jsp:useBean id="securProfile" class="com.bitmap.security.SecurityProfile" scope="session"></jsp:useBean>
<%@ taglib uri="/WEB-INF/lib/customtag.tld" prefix="bmp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ปฏิทินแผนการผลิต</title>

<script type="text/javascript">
$(function(){
	$('#calendar').fullCalendar({
		header: {
			left: 'prev,next today',
			center: 'title',
			right: 'month,agendaWeek,agendaDay'
		},
		theme: true,
		editable: false,
		droppable: false, // this allows things to be dropped onto the calendar !!!
		drop: function(date, allDay) { // this function is called when something is dropped
		
			// retrieve the dropped element's stored Event Object
			var originalEventObject = $(this).data('eventObject');
			
			// we need to copy it, so that multiple events don't have a reference to the same object
			var copiedEventObject = $.extend({}, originalEventObject);
			
			// assign it the date that was reported
			copiedEventObject.start = date;
			copiedEventObject.allDay = allDay;
			copiedEventObject.id = $(this).attr('id');
			// render the event on the calendar
			// the last `true` argument determines if the event "sticks" (http://arshaw.com/fullcalendar/docs/event_rendering/renderEvent/)
			$('#calendar').fullCalendar('renderEvent', copiedEventObject, true);
			
			// is the "remove after drop" checkbox checked?
			if ($('#drop-remove').is(':checked')) {
				// if so, remove the element from the "Draggable Events" list
				$(this).remove();
			}
			
		},
		events: '../CalendarServlet?action=get_pd_calendar'
		,
		eventClick: function(e, jsEvent, view ) {
			/*if (e.allDay) {
				alert('AllDay');
			} else {
				alert('Date: ' + e.start + " - " + e.end);
			}*/
	        // change the border color just for fun
	       

	    },
	    eventDrop: function(e,dayDelta,minuteDelta,allDay,revertFunc) {
	    	//alert('ID: ' + e.id + ' / Date: ' + e.start + " - " + e.end);
	      // $.post('BookManage',)

	      /*  if (!confirm("แน่ใจนะครับบบบบบบ?")) {
	            revertFunc();
	        }
			*/
	    },
	    dayClick: function(date, allDay, jsEvent, view) {
	    	$('#calendar').fullCalendar( 'changeView', 'agendaDay' ).fullCalendar( 'gotoDate', date  );
	    	
	    }
	});
});
</script>
<style type='text/css'>

	body {
		margin-top: 40px;
		text-align: center;
		font-size: 14px;
		font-family: "Lucida Grande",Helvetica,Arial,Verdana,sans-serif;
		}
		
	#wrap {
		width: 1100px;
		margin: 0 auto;
		}
		
	#external-events {
		float: left;
		width: 150px;
		padding: 0 10px;
		border: 1px solid #ccc;
		background: #eee;
		text-align: left;
		}
		
	#external-events h4 {
		font-size: 16px;
		margin-top: 0;
		padding-top: 1em;
		}
		
	.external-event { /* try to mimick the look of a real event */
		margin: 10px 0;
		padding: 2px 4px;
		background: #3366CC;
		color: #fff;
		font-size: .85em;
		cursor: pointer;
		}
		
	#external-events p {
		margin: 1.5em 0;
		font-size: 11px;
		color: #666;
		}
		
	#external-events p input {
		margin: 0;
		vertical-align: middle;
		}

	#calendar {
		width: 1100px;
		}

</style>
</head>
<body>

<div id="wrap">

	<div id="calendar"></div>

</div>

</body>
</html>