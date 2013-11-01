Spine = require 'spine'

Editor = require '../../lib/text-widgets'
{WidgetFactory} = Editor
{toolbars} = Editor


class Toolbars extends Spine.Controller
  template: require '../../views/classifier/toolbars'
      
  elements:
    '#document-metadata': 'metadata'
    '.types': 'pageTypes'
    '.toolbar': 'pageTools'
    
  helper:
    selectedCategory: (note) =>
      return
    selectedDocument: (document) =>
      return
        
  events:
    'change .documents': ->
      @el.trigger 'pickDocument'
      @toggleCategories()
    'change .categories': ->
      @el.trigger 'pickCategory', $('.categories :checked').val()

  constructor: ->
    super
    
    @render()

  render: =>
    @html @template(@)
    
    @pageTypes
      .find('h2')
      .attr('tabindex', '0')
      .attr('role', 'button')
      .on 'click keypress', @reset
    
  toggleCategories: ->
    category = $('.documents :checked').val()
    @metadata.html ''
    
    toolbar = toolbars[ category ] ? { template: '' }
      
    switch category
      when 'orders'
        orders = WidgetFactory.makeWidget 'orders'
        @metadata.html orders.template
      
    @pageTypes.addClass 'closed'
    @pageTools.removeClass('closed').html toolbar.template
    $('.categories').css
      'visibility': 'visible'
  
  selectPageType: (type) =>
    selector = "#document-#{type}"
    $( selector )
      .attr( 'checked', 'checked' )
      .prop( 'checked', true )
      
  select: (type) =>
    $( "#category-#{type}" )
      .attr('checked', 'checked')
      .prop('checked', true)
  
  deselect: (type)=>
    $( "#category-#{type}" )
      .removeAttr('checked')
      .prop('checked', false)
  
  reset: =>
    @pageTypes.removeClass 'closed'
    $('.categories :checked, .documents :checked')
      .removeAttr('checked')
      .prop('checked', false)
    @pageTools.addClass('closed').html ''
    @metadata.html ''

module.exports = Toolbars