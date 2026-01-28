package com.Reports.Excel;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;

public class FileValidation {
	public String validate(InputStream stream) {
		try {
			String statusFlag = null;
			HSSFWorkbook workbook = new HSSFWorkbook(stream);
			HSSFSheet sheet = workbook.getSheetAt(0);
			Iterator<Row> rowiterator = sheet.rowIterator();
			List<Row> rowlist = new ArrayList<>();
			Set<RowClass> rowset = new HashSet<>();
			RowClass rowclassobj = null;
			int notNullCount = 0;
			int rowcounter = 0;
			Iterator var12 = sheet.iterator();

			while (true) {
				Iterator celliterator;
				while (var12.hasNext()) {
					Row row = (Row) var12.next();
					celliterator = row.iterator();

					while (celliterator.hasNext()) {
						Cell cell = (Cell) celliterator.next();
						if (cell.getCellType() != 3) {
							++notNullCount;
							break;
						}
					}
				}

				Map<String, Integer> blankcells = new HashMap<>();

				for (Row row = (Row) rowiterator.next(); rowcounter < notNullCount - 1; ++rowcounter) {
					List<Cell> celllist = new ArrayList<>();
					row = (Row) rowiterator.next();

					Cell cell;
					for (celliterator = row.cellIterator(); celliterator.hasNext(); celllist.add(cell)) {
						cell = (Cell) celliterator.next();
						if (cell.getCellType() == 3) {
							blankcells.put("colnum" + cell.getColumnIndex(), row.getRowNum());
							if (cell.getCellType() != 1) {
								cell.setCellType(1);
							}

							statusFlag = "error";
						}
					}

					int var22 = celllist.size();

					try {
						rowclassobj = new RowClass(((Cell) celllist.get(0)).toString(),
								((Cell) celllist.get(1)).toString(), ((Cell) celllist.get(2)).toString(),
								((Cell) celllist.get(3)).toString(), ((Cell) celllist.get(4)).toString());
						if (rowset.contains(rowclassobj)) {
						
						}

						rowset.add(rowclassobj);
						rowlist.add(row);
					} catch (NumberFormatException var17) {
						;
					}
				}

				if (statusFlag == null) {
					if (rowlist.size() != rowset.size()) {
						statusFlag = "error";
					} else {
						statusFlag = "success";
					}

					return statusFlag;
				}

				return statusFlag;
			}
		} catch (Exception var18) {
			var18.printStackTrace();
			return "success";
		}
	}
}