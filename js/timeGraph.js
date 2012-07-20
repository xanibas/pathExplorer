var width = 800,
    height = 600
    
var color = d3.scale.category20();

var dataLegend = [
      {age: "E11.5"},
      {age: "E13.5"},
      {age: "E15.5"},
      {age: "E18.5"},
      {age: "P4"},
      {age: "P14"},
      {age: "P28"},
      {age: "P56"}];
      
var svg = d3.select("#graph")
    .append("svg")
        .attr("width", width)
        .attr("height", height) 

var select = document.getElementById("selectThreshold");    
  for(var i = 0; i < 11; i++) {
	var opt = i/10;
	var el = document.createElement("option");
	el.textContent = opt;
	el.value = opt;
	select.appendChild(el);
}

svg.selectAll("circle")
    .data(dataLegend).enter().append("svg:circle")
        .attr('class', 'label')
        .attr('r', 5)
        .style('fill', function(d, i) { return color(i+1); })
        .attr("cx", 20)
        .attr("cy", function(d, i) { return 20 + i*30; } );
        
svg.selectAll("a.legend")
    .data(dataLegend).enter().append("svg:a")
        .append("text")
              .attr("text-anchor", "left")
              .attr("x", 30)
	     .attr("y", function(d, i) { return 25 + i*30; })
              .text(function(d) { return d.age;});

var force = d3.layout.force()
    .gravity(0.1)
    .linkDistance( function(d) { return ((15/(d.value))); })
    .linkStrength( function(d) { return d.value; })
    .charge(-100)
    .size([width, height]);

d3.json("data/queryGraph.json", function(json) {
  force
      .nodes(json.nodes)
      .links(json.links)
      .start();

  var link = svg.selectAll(".link")
      .data(json.links)
      .enter().append("line")
      .attr("class", "link")
      .style("stroke-opacity", function(d) { return 2*d.value;})
      .style("stroke-width", function(d) { return 5*d.value; });

  var node = svg.selectAll(".node")
      .data(json.nodes)
      .enter().append('svg:g')
      .attr('class', 'node')
      .call(force.drag)
      //.on("click", fade(0.1));
      
  node.append('circle')
      .attr('class', 'node')
      .attr('r', function(d) { return d.genes[0].expression; })
      .style('fill', function(d) { return color(d.group); });

  node.append("text")
      .attr('dx', 12)
      .attr('dy', '.35em')
      .text(function(d) { return d.struct });
  
  var select = document.getElementById("selectGene");    
  var numgenes = svg.select("circle.node").data()[0].genes.length;
  for(var i = 0; i < numgenes; i++) {
	var opt = svg.select("circle.node").data()[0].genes[i].name;
	var el = document.createElement("option");
	el.textContent = opt;
	el.value = opt;
	select.appendChild(el);
  }
 
//  var linkedByIndex = {};
//  json.links.forEach(function(d) {
//  		if (d.value>0.3)
//        	linkedByIndex[d.source.index + "," + d.target.index] = 1;
//  });
//  
//  function isConnected(a, b) {
//        return linkedByIndex[a.index + "," + b.index] || linkedByIndex[b.index + "," + a.index] || a.index == b.index;
//  }

	node
        .filter(function(d) { return d.genes[0].measured=="false"; })
        .attr("transform", function(d) { return "translate(" + -10 + "," + -10 + ")"; });

  force.on("tick", function() {
  
    link.attr("x1", function(d) { return d.source.x; })
        .attr("y1", function(d) { return d.source.y; })
        .attr("x2", function(d) { return d.target.x; })
        .attr("y2", function(d) { return d.target.y; });

    node
        .filter(function(d) { return d.genes[0].measured=="true"; })
        .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });
  });
  
});
    
