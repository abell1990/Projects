function TableScan() {}

TableScan.sumColumn = function(id, colName)
{
	var table = document.getElementById(id);

	// factor out
	// sanity checks
	if (!table) return 0;
	if (table.nodeName != "TABLE") return 0;
	if (!table.firstElementChild || table.firstElementChild.nodeName != "TBODY") return 0;
	if (!table.firstElementChild.firstElementChild || table.firstElementChild.firstElementChild.nodeName != "TR") return 0;

	var tbody = table.firstElementChild;

	// find the column index for colName
	var headerRow = tbody.firstElementChild;
	var headerCols = headerRow.children;
	var index = -1;
	for (var i = 0; i < headerCols.length; i++)
	{
		if (headerCols[i].textContent == colName)
			index = i;
	}

	// Colname not found
	if (index == -1) return 0;

	// sum up values over all data rows for that column
	var sum = 0;
	var allRows = tbody.children;
	for(var i = 1; i < allRows.length; i++)
	{
		var cell = allRows[i].children[index];		
		if (!cell) continue;
		
		var cellValue = +cell.textContent;
		if (isNaN(cellValue)) continue;

		sum += cellValue;
	}

	return sum;
}


// TODO: check all vars are local (i.e. declared with var keyword)
// Q: can I assume all tables will be complete? i.e. have the same number of cells per row. If not how to handle it?
// should we worry about precision problems in the sum?  problems with TableScan.sumColumn("table2", "Unit Price") and TableScan.sumColumn("table1", "Weight")