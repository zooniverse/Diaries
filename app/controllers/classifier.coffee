$ = require 'jqueryify'
Spine = require 'spine'

Classification = require 'zooniverse/models/classification'
Subject = require 'zooniverse/models/subject'
User = require 'zooniverse/models/user'

MarkingSurface = require 'marking-surface'
TextTool = require './text-tool'
{ToolControls} = MarkingSurface
{Tool} = MarkingSurface


class Classifier extends Spine.Controller
  
  template: require '../views/classifier'

  events:
    'click .task': 'onDoTask'
    'click .finish': 'onFinishTask'

  elements:
    '.subject-container': 'subjectContainer'

  constructor: ->
    super
    
    @render()
	
    @surface ?= new MarkingSurface
      tool: TextTool
      container: @subjectContainer
      width: 1024
      height: 560
      
    @surface.image.attr src: 'img/0199.jpg'
    @surface.zoom 1

    User.on 'change', @onUserChange
    Subject.on 'select', @onSubjectSelect

  render: =>
    @html @template()

  onUserChange: (e, user) =>
    # user, User.current

    if user
      #alert 'hello user!'
    else
      alert 'you arent a user!'

    Subject.next()

  onSubjectSelect: (e, subject) =>
    # Subject.current

    @classification = new Classification { subject }
    console.log @classification

  onDoTask: =>
    @classification.annotate Date.now()
    console.log @classification

  onFinishTask: =>
    @classification.send()

    Subject.next()

module.exports = Classifier
