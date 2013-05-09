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

}


// TODO: check all vars are local