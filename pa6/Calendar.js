function Calendar(id)
{
	this.calendar = document.getElementById(id);
	this.cal_id = id;
}

Calendar.prototype.render = function(date)
{
	this.create_empty_calendar();
	this.populate_table(date);
}

Calendar.prototype.populate_table = function(date)
{
	var calendar = this;
	var table = document.getElementById(this.cal_id  + "-calendarTable");

	/* Set Calendar title */
	var title = document.getElementById(this.cal_id + '-calendarTitle');
	title.innerHTML = Calendar.monthNames[date.getMonth()] + " " + String(date.getFullYear());

	/* Set event handler for left control */
	var leftControl = document.getElementById(this.cal_id + '-leftControl');
	leftControl.onclick = function(event) {
		calendar.render( Calendar.previous_month(date) );
		event.preventDefault();
	}

	/* Set event handler for right control */
	var rightControl = document.getElementById(this.cal_id + '-rightControl');
	rightControl.onclick = function(event) {
		calendar.render( Calendar.next_month(date) );
		event.preventDefault();
	}	

	/* Populate calendar with the actual days */
	var currDay = Calendar.start_of_cal(date);
	for (var r = 0; r < Calendar.weeks_in_cal(date); r++)
	{	
		/* create a new row for each week */
		var row = document.createElement("TR");
		row.className = "content_even";
		table.appendChild(row);

		for (var c = 0; c < Calendar.DAYS_IN_WEEK; c++)
		{
			var cell = document.createElement("TD");
			row.appendChild(cell);

			cell.innerHTML = String(currDay.getDate());

			if (date.getMonth() != currDay.getMonth())
				cell.className = "cntr content_odd";
			else
				cell.className = "cntr";
			currDay = currDay.tomorrow();
		}
	}
}

Calendar.prototype.create_empty_calendar = function()
{
	/* clear previous contents of the calendar div */
	this.calendar.innerHTML = ''; 

	/* create a new table */ 
	var table = document.createElement("TABLE");
	table.id = this.cal_id + "-calendarTable";
	this.calendar.appendChild(table);

	/* create header row which contains the table title and the controls */
	var controlsRow = document.createElement("TR");
	controlsRow.innerHTML = "<th><a href='' id='" + this.cal_id + "-leftControl'>&lt;</a></th> <th id='" + this.cal_id + "-calendarTitle' colspan='5'></th> <th><a href='' id='" + this.cal_id + "-rightControl'>&gt;</a></th>";
	table.appendChild(controlsRow);
	
	/* create a second row with the abbreviations for the days of the week */
	var dayNameRow = document.createElement("TR");
	dayNameRow.className = "header";
	dayNameRow.innerHTML = "<td>Su</td><td>Mo</td><td>Tu</td><td>We</td><td>Th</td><td>Fr</td><td>Sa</td>";
	table.appendChild(dayNameRow);
}





/* Helper function section */


Calendar.DAYS_IN_WEEK = 7;
Calendar.DAY_IN_MSECS = 1000*60*60*24;
Calendar.monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

Calendar.start_of_cal = function(date)
{
	/* create date for the 1st day of the month */
	var startOfMonth = new Date(date);
	startOfMonth.setDate(1); 

	/* compute date for the start of the week */
	var startOfCal = new Date(startOfMonth);
	startOfCal.setDate(startOfMonth.getDate() - startOfMonth.getDay());

	return startOfCal;
}


Calendar.end_of_cal = function(date)
{
	/* create date for the last day of the month */
	var endOfMonth = new Date(date.getFullYear(), date.getMonth() + 1, 0);
	
	/* compute date for the end of the week */
	var endOfCal = new Date(endOfMonth);
	endOfCal.setDate(endOfMonth.getDate() + 6 - endOfMonth.getDay());

	return endOfCal;
}


/* number of days from startDate (including startDay) to endDate */
Calendar.day_difference = function(startDate, endDate)
{
	return Math.ceil((endDate.getTime()-startDate.getTime())/(Calendar.DAY_IN_MSECS)) + 1;
}

Calendar.days_in_cal = function(date)
{
	var startDate = Calendar.start_of_cal(date);
	var endDate = Calendar.end_of_cal(date);

	return Calendar.day_difference(startDate, endDate);
}

Calendar.weeks_in_cal = function(date)
{
	return Calendar.days_in_cal(date) / 7;
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

/* Taken from http://stackoverflow.com/questions/563406/add-days-to-datetime-using-javascript */
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
