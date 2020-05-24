class Dashing.Networkgraph extends Dashing.Widget

 
  ready: ->
    container = $(@node).parent()
    # Gross hacks. Let's fix this.
    width = (Dashing.widget_base_dimensions[0] * container.data("sizex")) + Dashing.widget_margins[0] * 2 * (container.data("sizex") - 1)
    height = (Dashing.widget_base_dimensions[1] * container.data("sizey"))
    @graph = new Rickshaw.Graph(
      element: @node
      width: width
      height: height
      renderer: @get("graphtype")
      max: @get("max")
      interpolation: 'basis'
      unstack: 'true'
      series: [
        {
          color: "#03a1fc",
          data: [{x:0, y:0}]
        },
        {
          color: "#dc5945",
          data: [{x:0, y:0}]
        }
      ]
      padding: {top: 0.02, left: 0.02, right: 0.02, bottom: 0.02}
    )

    @graph.series[0].data = @get('pointsUP') if @get('pointsUP')
    @graph.series[1].data = @get('pointsDOWN') if @get('pointsDOWN')

    x_axis = new Rickshaw.Graph.Axis.Time(graph: @graph)
    y_axis = new Rickshaw.Graph.Axis.Y(graph: @graph, tickFormat: Rickshaw.Fixtures.Number.formatKMBT)
    @graph.render()

  onData: (data) ->
    if @graph
      @graph.series[0].data = data.pointsUP
      @graph.series[1].data = data.pointsDOWN
      @graph.render()
