	var apiPath = "http://api.brain-map.org/api/v2/";
	var sectionPath = "data/SectionDataSet/query.json?"
	var structureList = ['RSP','Tel','PedHy','p3','p2','p1','M','PPH','PH','PMH','MH','CSPall','DPall','MPall'];
	var ageList = ['E11.5 Embryo','E13.5 Embryo','E15.5 Embryo','E18.5 Brain','P4 Brain','P14 Brain','P28 Brain','P56 Brain'];
	
	var dataPoints = [];
	var jsonString = '';
	
	function createStructure(structureId, ageId) {
		var xyz = makeArrayOf(-1, geneList.length+2);
		xyz[0] = structureId;
		xyz[1] = ageId;
		dataPoints.push(xyz);
	}
	
	function getDataPoints() {
	
		var geneAcronyms = '';
		for (var g in geneList) {
			geneAcronyms = geneAcronyms + "'" + geneList[g] + "',";
		}
		geneAcronyms = geneAcronyms.slice(0, -1);
		
		var structureAcronyms = '';
		for (var s in structureList) {
			structureAcronyms = structureAcronyms + "'" + structureList[s] + "',";
		}
		structureAcronyms = structureAcronyms.slice(0, -1);
		
//		var spaceIds = '';
//		for (var a in ageList) {
//			spaceIds = spaceIds + Number(Number(a)+1) + ",";
//		}
//		spaceIds = spaceIds.slice(0, -1);
		spaceIds = '1,2,3,5,6,7,8,9'
	
		var queryPath = "include=genes[acronym$in" + geneAcronyms + "],products[id$in3],reference_space[id$in" + spaceIds + "],structure_unionizes(structure[acronym$in" + structureAcronyms + "])";
		var url =  apiPath + sectionPath + queryPath;
		
		//document.write(url + '<br>');
		
		var current_rows = 0;
		var total_rows = 0;
		
		$.ajax(url, {
			dataType: "json",
			async: false,
			success: function(response) {
				current_rows = response.num_rows;
				total_rows = response.total_rows;
			},
			error: function() {
		    		document.write('Error: ' + response.statusText + '<br>');
		  	}
		});
		
		//document.write(current_rows + ' : ' + total_rows + '<br>');
		
		$.ajax(url+ "&start_row=" + 0 + "&num_rows=" + total_rows, {
			dataType: "json",
			async: false,
			success: function(response) {
				if (response.num_rows > 0) {
					for (var i in response.msg) {
						geneId = Number(searchStringInArray(response.msg[i].genes[0].acronym, geneList));
						ageId = Number(searchStringInArray(response.msg[i].reference_space.name, ageList));
						for (var s in response.msg[i].structure_unionizes) {
							structureId = Number(searchStringInArray (response.msg[i].structure_unionizes[s].structure.acronym, structureList));
							if (ageId>=0 && structureId>=0) {
								dataPoints[getIndex(ageId,structureId)][Number(geneId)+2] = Math.max(dataPoints[getIndex(ageId,structureId)][Number(geneId)+2], response.msg[i].structure_unionizes[s].expression_energy);
							}
						}
					}
				}
			},
			error: function() {
		    		document.write('Error: ' + response.statusText + '<br>');
		  	}
		});
	}
	
	function getIndex(ageId,structureId) {
		return ageId + ageList.length*structureId;
	}
	
	function getRowsNumber() {
		var total_rows = 0;
		$.ajax(url, {
			dataType: "json",
			async: false,
			success: function(response) {
				if (response.num_rows > 0) {
					total_rows = response.total_rows;
				}
			},
			error: function() {
		    		document.write('Error: ' + response.statusText + '<br>');
		  	}
		});
		return (total_rows)
	}
	
	function makeArrayOf(value, arrlength) {
  		var arr = [], i = arrlength;
  		while (i--) {
    			arr[i] = value;
  		}
  		return arr;
	}
	
	function searchStringInArray (string, stringArray) {
    		for (var j=0; j<stringArray.length; j++) {
        			if (stringArray[j]==string) return j;
    		}
    		return -1;
	}

	function replaceWithNA(value) {
  		if (value==-1)
  			return '"NA"';
  		else
  			return value;
	}
	
	for (var s in structureList) {
		for (var a in ageList) {
			createStructure(s, a);
		}
	}
	
	getDataPoints();
	
	document.write('Structure' + ' ');
	document.write('Age' + ' ');
	for (var g in geneList) {
		document.write(geneList[g] + ' ');
	}
	document.write('<br>');
	
	for (var i in dataPoints) {
		for (var j in dataPoints[i]) {
			document.write(dataPoints[i][j] + ' ');
		}
		document.write('<br>');
	}
