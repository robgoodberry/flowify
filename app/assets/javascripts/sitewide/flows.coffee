# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'page:load ready', ->
  if $(document.body).hasClass('flows show')
    $('.flowDiv').each (idx, el) ->
      json = $(el).data('flowjson')
      Flowify.init json, el, false

window.Flowify ?= {}

Flowify.init = (json, el, showHistory) ->
  @json = json
  @el = $(el)
  @lastStep = null
  @step = null
  @stepHistory = []
  @showHistory = showHistory

  @show(0)

Flowify.show = (step, backStep) ->
  backStep ?= false
  if typeof step is 'string'
    step = @identifyStep step

  if step isnt null
    @step = step

    if backStep is false
      @stepHistory.push step
    else
      @stepHistory.pop()
      @lastStep = @stepHistory[@stepHistory.length - 2]

    if step is 0 or @showHistory is false
      title = @createTitle()

    select = @createSelect(step)
    text = @createText(step)
    container = $(document.createElement('div'))
    container.addClass 'step-container'

    if step is 0 or @showHistory is false
      container.html [title, text, select]
    else
      container.html [text, select]
    if @showHistory
      @el.after(container)
      @el = container
    else
      @el.html container

    if @showHistory is true
      window.scroll 0, document.body.scrollHeight
  else
    alert "Step error."

Flowify.createSelect = (step) ->
  options = []

  for choice in @json.flowJson[step].choices
    option = $(document.createElement('option'))
    option.val choice.nextStep
    option.html choice.text
    options.push option

  if @showHistory is false and step isnt 0
    option = $(document.createElement('option'))
    option.val "Back"
    option.html "Back"
    options.push option

  select = $(document.createElement('select'))
  select.addClass 'flow-select'
  select.attr 'multiple', 'multiple'
  select.append options
  Flowify.optionChangeListener(select)

  return select

Flowify.optionChangeListener = (el) ->
  self = @
  el.on 'change', ->
    selected = $("option:selected", @);
    selectedVal = selected.val()
    if selectedVal isnt undefined
      if selectedVal.toLowerCase() is "end"
        self.reset()
        Flowify.show(0)
      else if selectedVal.toLowerCase() is "back"
        Flowify.show(self.lastStep, true)
      else
        self.lastStep = self.step
        Flowify.show selected.val()

Flowify.createTitle = ->
  title = $(document.createElement('h2')).html @json.name
  return title

Flowify.createText = (step) ->
  text = $(document.createElement('div')).html @json.flowJson[step].text
  text.addClass 'flow-text'
  return text

Flowify.identifyStep = (stepHandle) ->
  for step, i in @json.flowJson
    if step.handle is stepHandle
      return i
  return null

Flowify.reset = ->
  @stepHistory = []
  @step = 0
  @lastStep = 0
