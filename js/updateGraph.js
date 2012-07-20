function updateSize(sel) {
  		svg.selectAll("circle.node").transition().duration(1000).attr('r', function(d) { return d.genes[sel.selectedIndex].expression; });
}
  
function updateOpacity(sel) {
  		var linkedByIndex = {};
  		svg.selectAll(".link").forEach(function(d) {
  		if (d.value>0.3)
        	linkedByIndex[d.source.index + "," + d.target.index] = 1;
  		});
  
  		svg.selectAll(".link").style("stroke-opacity", function(o) {
        	return o.value<(sel.selectedIndex)/10 ? 0 : 1;
        });
                
                
}
    
//  function fade(opacity) {
//            return function(d) {
//                node.style("stroke-opacity", function(o) {
//                    thisOpacity = isConnected(d, o) ? 1 : opacity;
//                    this.setAttribute('fill-opacity', thisOpacity);
//                    return thisOpacity;
//                });
//                
//                link.style("stroke-opacity", function(o) {
//                	return o.source === d || o.target === d ? 1 : opacity;
//                });
//                
//            };
//   }
    
