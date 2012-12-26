$ ->
    class Plotter
        constructor: ($canvas) ->
            @width = parseInt $canvas.attr('width')
            @height = parseInt $canvas.attr('height')
            @ctx = $canvas[0].getContext '2d'

        set_window: (min_x, max_x, min_y, max_y) ->
            @window = {min: [min_x, min_y], max: [max_x, max_y], width: max_x - min_x, height: max_y - min_y}

        _xy_to_screen: ([x, y]) =>
            u = (x - @window.min[0]) * @width / @window.width
            v = (@window.max[1] - y) * @height / @window.height
            [u, v]

        #_screen_to_xy: ([u, x]) =>
            #x = ()

        @grain = 50
        @epsilon = 0.1
        _make_indices: ->
            #we want @grain indices in the window
            _.range @window.min[0], @window.max[0] + Plotter.epsilon, @window.width / Plotter.grain

        _move_to: ([x, y]) ->
            @ctx.moveTo x, y

        _line_to: ([x, y]) ->
            @ctx.lineTo x, y

        _plot_points: (points) ->
            @ctx.beginPath()
            @ctx.strokeStyle = '#5c5cd6'
            @_move_to points[0]
            @_line_to point for point in points[1..]
            @ctx.stroke()

        plot: (f) ->
            indices = @_make_indices()
            values = _(indices).map f

            screen_points = _.map(_.zip(indices, values), @_xy_to_screen)
            @ctx.clearRect 0, 0, @width, @height
            @_draw_axes()
            @_plot_points screen_points

        _plus: (p1, p2) ->
            [p1[0] + p2[0], p1[1] + p2[1]]

        @min = 1
        @tick_width = 4
        _draw_axes: () ->
            @ctx.strokeStyle = "#000"
            if @window.min[0] <= 0 <= @window.max[0]
                #draw y axis
                @ctx.beginPath()
                @_move_to @_xy_to_screen([0, @window.min[1]])
                @_line_to @_xy_to_screen([0, @window.max[1]])
                @ctx.stroke()

                #draw labels
                delta = Math.ceil(@window.width / 10)
                @ctx.beginPath()
                for y in (_.range 0, @window.max[1], delta).concat(
                          _.range @window.min[1], 0, delta)
                    point = @_xy_to_screen([0, y])
                    @_move_to @_plus(point, [-Plotter.tick_width, 0])
                    @_line_to @_plus(point, [Plotter.tick_width, 0])
                @ctx.stroke()

            if @window.min[1] <= 0 <= @window.max[1]
                #draw y axis
                @ctx.beginPath()
                @_move_to @_xy_to_screen([@window.min[0], 0])
                @_line_to @_xy_to_screen([@window.max[0], 0])
                @ctx.stroke()

                #draw labels
                delta = Math.ceil(@window.width / 10)
                @ctx.beginPath()
                for x in (_.range 0, @window.max[0], delta).concat(
                          _.range @window.min[0], 0, delta)
                    point = @_xy_to_screen([x, 0])
                    @_move_to @_plus(point, [0, -Plotter.tick_width])
                    @_line_to @_plus(point, [0, Plotter.tick_width])
                @ctx.stroke()

    window.plotter = new Plotter $('#paper')
    #plotter.set_window(-2, 2, 0, 4)
    plotter.set_window(-2, 2, -8, 8)
    f = (x) -> Math.pow x, $('#pow').val()
    plotter.plot f
    $('#pow').change -> plotter.plot f



    # [width, height] = [400, 300]

    # ctx = $('#paper')[0].getContext '2d'
    # #ctx.beginPath()
    # #ctx.moveTo 0, 0
    # #ctx.lineTo width, height
    # #ctx.stroke()

    # $pow = $ '#pow'

    # f = (x) ->
    #     foo = Math.pow(x, $pow.val())

    # indices = [-50..50]
    # values = _(indices).map f

    # origin = {x: width/2, y: height/2}
    # xy_to_screen = (x, y) ->
    #     {x: origin.x + x, y: origin.y - y}

    # move_to = (point) ->
    #     ctx.moveTo point.x, point.y

    # line_to = (point) ->
    #     ctx.lineTo point.x, point.y

    # draw = ->
    #     ctx.clearRect(0, 0, width, height)
    #     ctx.beginPath()
    #     values = _(indices).map f
    #     console.log indices
    #     console.log values
    #     move_to xy_to_screen(indices[0], values[0])
    #     for [x, y] in _.zip(indices, values)
    #         line_to xy_to_screen(x, y)
    #     ctx.stroke()

    # console.log(values)

    # console.log 'hello world!'

    # $pow.change ->
    #     draw()""
