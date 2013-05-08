/* Taken from http://stackoverflow.com/questions/563406/add-days-to-datetime-using-javascript */
Date.prototype.addDays = function(days)
{
    var dat = new Date(this.valueOf());
    dat.setDate(dat.getDate() + days);

    return dat;
}

function Calendar(id)
{
	this.cal_id = id;
}

Calendar.prototype.render = function(date)
{
	var calElem = document.getElementById(this.cal_id);
}

Calendar.num_days_in_cal = 35;

Calendar.start_of_cal = function(date)
{
	/* create date for the 1st of the month */
	var startOfMonth = new Date(date);
	startOfMonth.setDate(1); 

	/* compute date for the start of the week */
	var startOfCal = new Date(startOfMonth);
	startOfCal.setDate(startOfMonth.getDate() - startOfMonth.getDay());

	return startOfCal;
}

