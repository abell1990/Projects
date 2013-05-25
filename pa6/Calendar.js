/**********  Public interface ***********/

/* Calendar class constructor. Takes in an id for the div which will later be poplated 
   dynamically with calendar HTML by calls to the render method */
function Calendar(id)
{
	this.calendar = document.getElementById(id);
	this.calendar_id = id;
}

/* Instance method to repopulate the div attached with this calendar object with a new calendar 
   for the given date */
Calendar.prototype.render = function(date)
{
	this.create_empty_calendar();
	this.populate_calendar(date);
}

/********** END Public interface ***********/




/******** Private method section **********/

/* Clears out the contents of the associated div and populates the control and header rows */
Calendar.prototype.create_empty_calendar = function()
{
	/* Clear previous contents of the calendar div */
	this.calendar.innerHTML = ''; 

	/* Create a new table */ 
	var table = document.createElement("TABLE");
	table.id = this.calendar_id + "-calendarTable";
	this.calendar.appendChild(table);

	/* Create header row which contains the table title and the controls */
	var controlsRow = document.createElement("TR");
	controlsRow.innerHTML = "<th><a href='' id='" + this.calendar_id + "-leftControl'>&lt;</a></th> \
							 <th id='" + this.calendar_id + "-calendarTitle' colspan='5'></th> <th> \
							 <a href='' id='" + this.calendar_id + "-rightControl'>&gt;</a></th>";
	table.appendChild(controlsRow);
	
	/* Create a second row with the abbreviations for the days of the week */
	var dayNameRow = document.createElement("TR");
	dayNameRow.className = "dayNamesRow";
	dayNameRow.innerHTML = "<td>Su</td><td>Mo</td><td>Tu</td><td>We</td><td>Th</td><td>Fr</td><td>Sa</td>";
	table.appendChild(dayNameRow);
}

/* Populates the div cleared out by create_empty_calendar with the appropriate days for the
   month speficied by date */
Calendar.prototype.populate_calendar = function(date)
{
	var calendar = this;
	var table = document.getElementById(this.calendar_id  + "-calendarTable");

	/* Set calendar title */
	var title = document.getElementById(this.calendar_id + '-calendarTitle');
	title.innerHTML = Calendar.monthNames[date.getMonth()] + " " + String(date.getFullYear());

	/* Set event handler for left control */
	var leftControl = document.getElementById(this.calendar_id + '-leftControl');
	leftControl.onclick = function(event) {
		calendar.render( Calendar.previous_month(date) );
		event.preventDefault();
	}

	/* Set event handler for right control */
	var rightControl = document.getElementById(this.calendar_id + '-rightControl');
	rightControl.onclick = function(event) {
		calendar.render( Calendar.next_month(date) );
		event.preventDefault();
	}	

	/* Populate calendar with the actual days */
	var currDay = Calendar.start_of_calendar(date);
	for (var r = 0; r < Calendar.weeks_in_calendar(date); r++)
	{	
		/* Create a new row for each week */
		var row = document.createElement("TR");
		table.appendChild(row);

		for (var c = 0; c < Calendar.DAYS_IN_WEEK; c++)
		{
			/* Create a new cell for each day and assign appropriate CSS class 
			   depending on whether its on the month we are displaying or not. */
			var cell = document.createElement("TD");
			cell.innerHTML = String(currDay.getDate());
			
			if (Calendar.is_same_date(currDay, new Date()))
				cell.className = "today";
			else
				cell.className = currDay.getMonth() == date.getMonth() ? "dayInCurrentMonth" : "dayNotInCurrentMonth";
			
			row.appendChild(cell);

			currDay = currDay.tomorrow();
		}
	}
}


/******* Helper Methods **********/

Calendar.DAYS_IN_WEEK = 7;
Calendar.DAY_IN_MSECS = 1000*60*60*24;
Calendar.monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

Calendar.start_of_calendar = function(date)
{
	/* Create date for the 1st day of the month */
	var startOfMonth = new Date(date);
	startOfMonth.setDate(1); 

	/* Compute date for the start of the week */
	var startOfCal = new Date(startOfMonth);
	startOfCal.setDate(startOfMonth.getDate() - startOfMonth.getDay());

	return startOfCal;
}


Calendar.end_of_calendar = function(date)
{
	/* Create date for the last day of the month */
	var endOfMonth = new Date(date.getFullYear(), date.getMonth() + 1, 0);
	
	/* Compute date for the end of the week */
	var endOfCal = new Date(endOfMonth);
	endOfCal.setDate(endOfMonth.getDate() + 6 - endOfMonth.getDay());

	return endOfCal;
}


/* Number of days from startDate (including startDay) to endDate */
Calendar.day_difference = function(startDate, endDate)
{
	return Math.ceil((endDate.getTime()-startDate.getTime())/(Calendar.DAY_IN_MSECS)) + 1;
}

Calendar.days_in_calendar = function(date)
{
	var startDate = Calendar.start_of_calendar(date);
	var endDate = Calendar.end_of_calendar(date);

	return Calendar.day_difference(startDate, endDate);
}

Calendar.is_same_date = function(date1, date2)
{
	return (date1.getDate() == date2.getDate() 
        && date1.getMonth() == date2.getMonth()
        && date1.getFullYear() == date2.getFullYear());
}

Calendar.weeks_in_calendar = function(date)
{
	return Calendar.days_in_calendar(date) / 7;
}

Calendar.previous_month = function(date)
{
	var prevMonth = new Date(date);
	prevMonth.setMonth(prevMonth.getMonth() - 1);
	return prevMonth;
}

Calendar.next_month = function(date)
{
	var nextMonth = new Date(date);
	nextMonth.setMonth(nextMonth.getMonth() + 1);
	return nextMonth;
}

Date.prototype.addDays = function(days)
{
    var dat = new Date(this.valueOf());
    dat.setDate(dat.getDate() + days);

    return dat;
}

Date.prototype.tomorrow = function()
{
    return this.addDays(1);
}

/******** END Helper function section **********/

