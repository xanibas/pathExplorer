

function createChart() {
	var values = d3.range(10).map(randomIrwinHall(10));
	console.log(values);
}


function randomIrwinHall(m) {
  return function() {
    for (var s = 0, j = 0; j < m; j++)
    	s += Math.random();
    return s / m;
  };
}
    
