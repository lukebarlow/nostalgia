hash = (obj, i) ->
    return obj._id || obj.id || i

jdp = require('jsondiffpatch').create({objectHash : hash})
d3 = require('d3')

module.exports = (object) ->

    dispatch = d3.dispatch('change')
    
    copy = (o) ->
        return JSON.parse(JSON.stringify(o))

    backstory = [] # synonym for 'history', which is already used by browser
    unpatching = false
    lastValue = copy(object)
    nostalgia = {}
    position = -1


    nostalgia.backstory = ->
        return backstory


    nostalgia.position = ->
        return position


    nostalgia.report = ->
        console.log('backstory', backstory)
        console.log('position', position)


    nostalgia.step = ->
        patch = jdp.diff(lastValue, object)
        position++
        if position < backstory.length # have forward history which we now clear
            backstory = backstory.slice(0, position)
        backstory.push(patch) 
        lastValue = copy(object)


    nostalgia.back = ->
        if position <= -1
            console.log('already at the beginning of what nostalgia remembers')
            return
        jdp.unpatch(object, backstory[position])
        position--
        lastValue = copy(object)
        dispatch.change()


    nostalgia.forward = ->
        if position > backstory.length - 2
            console.log('already at the forefront of history')
            return
        position++
        jdp.patch(object, backstory[position])
        lastValue = copy(object)
        dispatch.change()


    nostalgia.on = (type, listener) ->
        dispatch.on(type, listener)
        return nostalgia


    return nostalgia
        