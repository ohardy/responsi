###
Copyright (c) 2013 Olivier Hardy

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
###

readyBound = false

$ = window.$$ = {}

$.toArray = (iterable) ->
  if !iterable
    return []
  if iterable is 'object' and 'toArray' of iterable
    return iterable.toArray()

  length  = iterable.length or 0
  results = new Array length
  while length--
    results[length] = iterable[length]

  return results

$.bindReady = (callback) ->
  return  if readyBound

  callback2 = ->
    readyBound = true
    callback()

  # Mozilla, Opera and webkit nightlies currently support this event
  if document.addEventListener

    # Use the handy event callback
    document.addEventListener "DOMContentLoaded", (->
      document.removeEventListener "DOMContentLoaded", arguments.callee, false
      callback2()
    ), false

  # If IE event model is used
  else if document.attachEvent

    # ensure firing before onload,
    # maybe late but safe also for iframes
    document.attachEvent "onreadystatechange", ->
      if document.readyState is "complete"
        document.detachEvent "onreadystatechange", arguments.callee
        callback2()


    # If IE and not an iframe
    # continually check to see if the document is ready
    if document.documentElement.doScroll and window is window.top
      (->
        # return  if jQuery.isReady
        try

          # If IE is used, use the trick by Diego Perini
          # http://javascript.nwbox.com/IEContentLoaded/
          document.documentElement.doScroll "left"
        catch error
          setTimeout arguments.callee, 0
          return

        # and execute any waiting functions
        callback2()
      )()

$.preventDefault = (evt) ->
  if evt.preventDefault
    evt.preventDefault()
  else
    evt.returnValue = false

  return false

$.getOffset = (el) ->
  _x = 0
  _y = 0
  while el and !isNaN(el.offsetLeft) and !isNaN(el.offsetTop)
    _x += el.offsetLeft - el.scrollLeft
    _y += el.offsetTop - el.scrollTop
    el = el.offsetParent

  result =
    top: _y
    left: _x

  return result

$.closest = (elem, selector) ->
  matchesSelector = elem.matches or elem.webkitMatchesSelector or elem.mozMatchesSelector or elem.msMatchesSelector

  unless matchesSelector?
    return $.closestTag elem, selector

  while elem
    if matchesSelector.bind(elem)(selector)
      return elem
    else
      elem = elem.parentNode

  return false

$.closestTag = (elem, tag) ->
  while elem
    if elem.tagName is tag
      return elem
    else
      elem = elem.parentNode

  return false

$.hasClass = (el, cl) ->
  regex = new RegExp("(?:\\s|^)" + cl + "(?:\\s|$)")
  el? and el.className? and !!el.className.match(regex)

$.addClass = (el, classes) ->
  for cls in classes.split(' ')
    if !$.hasClass el, cls
      el.className = (el.className or '') + " " + cls

  return true

$.addClassToMany = (selector, classes) ->
  for elt in Sizzle(selector)
    $.addClass elt, classes

  return true

$.removeClass = (el, classes) ->
  for cls in classes.split(' ')
    regex = new RegExp("(?:\\s|^)" + cls + "(?:\\s|$)")
    if el.className?
      el.className = el.className.replace(regex, " ")

  return true

$.removeClassToMany = (selector, classes) ->
  for elt in Sizzle(selector)
    $.removeClass elt, classes

  return true

$.toggleClass = (el, cl) ->
  (if $.hasClass(el, cl) then $.removeClass(el, cl) else $.addClass(el, cl))

  return true

$.getScrollTop = ->
  if pageYOffset?
    # most browsers except IE before #9
    return pageYOffset
  else
    B = document.body # IE 'quirks'
    D = document.documentElement # IE with doctype
    unless D.clientHeight
      D = B

    return D.scrollTop

$.addEvent = (evnt, elem, func) ->
  if elem.addEventListener
    elem.addEventListener evnt, func, false
  else if elem.attachEvent
      # IE DOM
      elem.attachEvent "on" + evnt, func
  else
    # No much to do
    elem[evnt] = func

$.hide = (elt) ->
  if elt?
    elt.style.display = 'none'

$.show = (elt) ->
  if elt?
    elt.style.display = ''

$.getWindowHeight = ->
  height = 0
  if typeof window.innerHeight is 'number'
    # Non IE
    height = window.innerHeight
  else if document.documentElement and document.documentElement.clientHeight
    # IE6+
    height = document.documentElement.clientHeight
  else if document.body and document.body.clientHeight
    height = document.body.clientHeight

  return height

$.heightFor = (elt) ->
  boundingClientRect = elt.getBoundingClientRect()
  return parseInt(boundingClientRect.bottom, 10) - parseInt(boundingClientRect.top, 10)
