function Calendar(id)
{
	this.calendar = document.getElementById(id);
	this.cal_id = id;
}

Calendar.one_day=1000*60*60*24;
Calendar.monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

Calendar.prototype.render = function(date)
{
	this.create_empty_calendar();
	this.populate_table(date);
}

Calendar.prototype.populate_table = function(date)
{
	var calendar = this;
	var table = document.getElementById(this.cal_id  + "-calTable");

	/* Set Calendar title */
	var title = document.getElementById(this.cal_id + '-calTitle');
	title.innerHTML = Calendar.monthNames[date.getMonth()] + " " + String(date.getFullYear());

	/* Set event handler for left control */
	var leftcontrol = document.getElementById(this.cal_id + '-lc');
	var prevMonth = new Date(date);
	prevMonth.setMonth(prevMonth.getMonth() - 1);
	leftcontrol.onclick = function(event) {
		calendar.render(prevMonth);
		event.preventDefault();
	}
	//leftcontrol.setAttribute("onclick", "c = new Calendar('" + String(this.cal_id) + "'); c.render(new Date('" + String(prevMonth) + "'));");

	/* Set event handler for right control */
	var rightcontrol = document.getElementById(this.cal_id + '-rc');
	var nextMonth = new Date(date);
	nextMonth.setMonth(nextMonth.getMonth() + 1);
	rightcontrol.onclick = function(event) {
		calendar.render(nextMonth);
		event.preventDefault();
	}	
	//rightcontrol.setAttribute("onclick", "c = new Calendar('" + String(this.cal_id) + "'); c.render(new Date('" + String(nextMonth) + "'));");

	/* Populate calendar with the actual days */
	var start = Calendar.start_of_cal(date);
	for (var r = 0; r < Calendar.weeks_in_cal(date); r++)
	{	
		var row = document.createElement("TR");
		row.className = "content_even";
		table.appendChild(row);
		for (var c = 0; c < 7; c++)
		{
			var cell = document.createElement("TD");
			row.appendChild(cell);

			cell.innerHTML = String(start.getDate());

			if (date.getMonth() != start.getMonth())
				cell.className = "cntr content_odd";
			else
				cell.className = "cntr";
			start = start.tomorrow();
		}
	}
}

Calendar.prototype.create_empty_calendar = function()
{
	/* clear previous contents of the calendar div */
	this.calendar.innerHTML = ''; 

	/* create a new table with header row, controls row, and days of the week row*/ 
	var table = document.createElement("TABLE");
	table.id = this.cal_id + "-calTable";
	this.calendar.appendChild(table);

	var controlsRow = document.createElement("TR");
	table.appendChild(controlsRow);

	controlsRow.innerHTML = "<th><a href='' id='" + this.cal_id + "-lc'>&lt;</a></th> <th id='" + this.cal_id + "-calTitle' colspan='5'></th> <th><a href='' id='" + this.cal_id + "-rc'>&gt;</a></th>";

	var dayNameRow = document.createElement("TR");
	dayNameRow.className = "header";
	table.appendChild(dayNameRow);

	dayNameRow.innerHTML = "<td>Su</td><td>Mo</td><td>Tu</td><td>We</td><td>Th</td><td>Fr</td><td>Sa</td>";
}





/* Helper function section */


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
	return Math.ceil((endDate.getTime()-startDate.getTime())/(Calendar.one_day)) + 1;
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

/* Fix id names */
