Spine = require 'spine'
Group = require 'zooniverse/models/project-group'

require '../../lib/jstorage.js'
store = $.jStorage

class GroupPicker extends Spine.Controller
  template: require '../../views/classifier/group_picker'
    
  events:
    'change #diary_picker': 'refresh_group'
      

  constructor: ->
    super
    
    Group.on 'fetch', @onGroupFetch

  render: =>
      
    @html @template
      groups: @groups
      
    $('#diary_picker').val store.get 'group_id', '5241bcf43ae7406825000003'
  
  onGroupFetch: (e, @groups) =>
    @render()
    
  refresh_group: =>
    return unless @groups?
    console.log 'UPDATING GROUP'
    @navigate '/classify', $('#diary_picker').val()
  
  set_group: (group_id) =>
    $('#diary_picker').val group_id
    
    store.set 'group_id', group_id
    group = (group for group in @groups when group.id == group_id)
  
    @el.trigger 'groupChange', group

module.exports = GroupPicker