nostalgia = require('../../nostalgia')


describe 'nostalgia', ->


    it 'can reverse setting a property on an object', ->
        o = {a : 14, b : 2, c : 3}
        n = nostalgia(o)
        o.a = 22
        n.step()
        n.back()
        expect(o.a).toBe(14)


    it 'can reverse setting a property on an object multiple times', ->
        d = {a : 1, b : 2, c : 3}
        n = nostalgia(d)
        d.a = 9
        n.step()
        d.a = 15
        n.step()
        d.a = 22
        n.step()
        expect(d.a).toBe(22)
        n.back()
        expect(d.a).toBe(15)
        n.back()
        expect(d.a).toBe(9)
        n.back()
        expect(d.a).toBe(1)


    it 'can reverse adding to an array', ->
        d = [1, 2, 3]
        n = nostalgia(d)
        d.push(19)
        n.step()
        expect(d).toEqual([1, 2, 3, 19])
        n.back()
        expect(d).toEqual([1, 2, 3])


    it 'can reverse adding properties to an object', ->
        d = {a : 1, b : 2, c : 3}
        n = nostalgia(d)
        d.f = 22
        n.step()
        expect('f' of d).toBe(true)
        n.back()
        expect('f' of d).toBe(false)


    it 'can reverse changing a value in an array', ->
        d = [1, 2, 3]
        n = nostalgia(d)
        d[1] = 99
        n.step()
        expect(d).toEqual([1, 99, 3])
        n.back()
        expect(d).toEqual([1, 2, 3])


    it 'can reverse splicing a value into an array', ->
        d = [1, 2, 3]
        n = nostalgia(d)
        d.splice(1,0,12,13)
        n.step()
        expect(d).toEqual([1, 12, 13, 2, 3])
        n.back()
        expect(d).toEqual([1, 2, 3])


    it 'can go forward through history after going back', ->
        d = {a : 1, b : 2, c : 3}
        n = nostalgia(d)
        d.a = 9
        n.step()
        d.a = 15
        n.step()
        d.a = 22
        n.step()
        expect(d.a).toBe(22)
        n.back()
        expect(d.a).toBe(15)
        n.back()
        expect(d.a).toBe(9)
        n.forward()
        expect(d.a).toBe(15)
        n.forward()
        expect(d.a).toBe(22)


    it 'will give a warning but not break if you go back too far', ->
        d = {a : 1, b : 2, c : 3}
        n = nostalgia(d)
        d.a = 9
        n.step()
        n.back()
        n.back()
        n.back()
        n.back()
        expect(d.a).toBe(1)


    it 'will give a warning but not break if you go forward too far', ->
        d = {a : 1, b : 2, c : 3}
        n = nostalgia(d)
        d.a = 9
        n.step()
        n.forward()
        expect(d.a).toBe(9)
        n.forward()
        n.forward()
        n.back()
        expect(d.a).toBe(1)


    it 'can step back then go forward a different way', ->
        d = {a : 1, b : 2, c : 3}
        n = nostalgia(d)
        d.a = 15
        n.step()
        expect(d.a).toBe(15)
        n.back()
        expect(d.a).toBe(1)
        d.a = 1200
        n.step()
        expect(d.a).toBe(1200)
        n.back()
        expect(d.a).toBe(1)


    it 'can step back and forward through longer histories', ->
        d = {a : 1, b : 2, c : 3}
        n = nostalgia(d)
        d.a = 15
        n.step()
        expect(d.a).toBe(15)
        d.a = 22
        n.step()
        expect(d.a).toBe(22)
        n.back()
        expect(d.a).toBe(15)
        d.a = 1200
        n.step()
        expect(d.a).toBe(1200)
        n.back()
        expect(d.a).toBe(15)
        n.back()
        expect(d.a).toBe(1)
