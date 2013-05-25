function TableScan () {}

/* Takes in a table id and a column name. Looks for a table with that id and
   a column in that table with the given name in the header row. If found
   it will add up all the numeric entries in that column and return the sum */
TableScan.sumColumn = function (id, colName)
{
	var table = document.getElementById (id);

	if (!TableScan.isValidTable (table)) return 0;

	var index = TableScan.getColumnIndex (table, colName);

	/* colName not found */
	if (index == -1) return 0;

	/* sum up all numeric values values over all data rows for that column */
	var allRows = table.rows; 
	var sum = 0;
	for (var i = 1; i < allRows.length; i++)
	{
		var cell = allRows[i].children[index];		
		
		if (!cell) continue;
		
		var cellValue = +cell.textContent;
		
		if (TableScan.isNumber (cellValue))
		{
			sum += cellValue;
		}
	}

	return Math.round (sum * 1E6) / 1E6;
}



/* Helper method section */

TableScan.isValidTable = function (table)
{
	if (!table) return false; /* check element exists */
	if (table.nodeName != "TABLE") return false; /* is it a table element */
	if (!table.tBodies[0] || !table.rows[0]) return false; /* verify it has a tbody and a header row*/

	return true;
}

TableScan.isNumber = function (n) 
{   
	return !isNaN(parseFloat(n)) && isFinite(n); 
}

/* Returns index of column whose name is colName or -1 if not found */
TableScan.getColumnIndex = function (table, colName)
{
	var headerRow = table.rows[0];
	var headerCols = headerRow.children;
	var index = -1;
	
	for (var i = 0; i < headerCols.length; i++)
	{
		if (headerCols[i].textContent == colName)
			index = i;
	}

	return index;
}