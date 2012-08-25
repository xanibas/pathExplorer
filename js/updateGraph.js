function updateSize(sel) {
  		svg.selectAll("circle.node").transition().duration(1000).attr('r', function(d) { return d.genes[sel.selectedIndex].expression; });
  		//svg.selectAll(".link").transition().duration(1000)
  		//	.style("stroke-opacity", function(d) { return 10*sig(d.values[sel.selectedIndex].distance); })
  		//	.style("stroke-width", function(d) { return 10*sig(d.values[sel.selectedIndex].distance); });
}
  
function updateOpacity(sel) {
  		svg.selectAll(".link")
  		.style("stroke-opacity", function(o) {
  			return o.values[0].distance<sel.selectedIndex/20? getOpacity(o) : 0;
        });   
}
    
