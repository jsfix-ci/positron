#
# Generic section container component that handles things like hover controls
# and editing states. Also decides which section to render based on the
# section type.
#

React = require 'react'
SectionText = React.createFactory require '../section_text/index.coffee'
SectionVideo = React.createFactory require '../section_video/index.coffee'
SectionSlideshow = React.createFactory require '../section_slideshow/index.coffee'
SectionEmbed = React.createFactory require '../section_embed/index.coffee'
SectionFullscreen = React.createFactory require '../section_fullscreen/index.coffee'
SectionCallout = React.createFactory require '../section_callout/index.coffee'
SectionToc = React.createFactory require '../section_toc/index.coffee'
SectionImageSet = React.createFactory require '../section_image_set/index.coffee'
SectionImageCollection = React.createFactory require '../section_image_collection/index.coffee'
SectionImage = React.createFactory require '../section_image/index.coffee'
{ div, nav, button } = React.DOM
icons = -> require('./icons.jade') arguments...

module.exports = React.createClass
  displayName: 'SectionContainer'

  getInitialState: ->
    dropPosition: 'top'

  onClickOff: ->
    @setEditing(off)()
    @refs.section?.onClickOff?()
    if @props.section.get('type') is 'image_set' or 'image_collection'
      @props.section.destroy() if @props.section.get('images')?.length is 0

  componentDidMount: ->
    @props.section.on 'change:layout', => @forceUpdate()

  setEditing: (editing) -> =>
    @props.onSetEditing if editing then @props.index ? true else null

  removeSection: (e) ->
    e.stopPropagation()
    @props.section.destroy()

  onDragStart: (e) ->
    dragStart = e.clientY - ($(e.currentTarget).position().top - window.scrollY)
    @props.onDragStart e, dragStart

  onDragOver: (e) ->
    mousePosition = e.clientY - @props.dragStart
    $dragOver = $(e.currentTarget).find('.edit-section-container')
    dragOverID = $dragOver.data('id')
    dragOverTop = $dragOver.position().top + 20 - window.scrollY
    dragOverCenter = dragOverTop + ($dragOver.height() / 2)
    if mousePosition > dragOverCenter and dragOverID is !@props.sections.length or dragOverID is @props.dragging + 1
      @setState dropPosition: 'bottom'
    else
      @setState dropPosition: 'top'
    @props.onSetDragOver dragOverID unless dragOverID is @props.dragOver

  printDropPlaceholder: ->
    if @props.dragOver is @props.index
      unless @props.index is @props.dragging
        div {
          className: 'edit-section-drag-placeholder'
          style: height: @props.draggingHeight
        }

  render: ->
    div {
        draggable: !@props.editing
        onDragStart: @onDragStart
        onDragEnd: @props.onDragEnd
        onDragOver: @onDragOver
      },
      if @state.dropPosition is 'top'
        @printDropPlaceholder()
      div {
        className: 'edit-section-container'
        'data-editing': @props.editing
        'data-type': @props.section.get('type')
        'data-layout': @props.section.get('layout')
        'data-id': @props.index
        'data-dragging': @props.dragging is @props.index
      },
        div {
          className: 'edit-section-hover-controls'
          onClick: @setEditing(on)
        },
          button {
            className: "edit-section-drag button-reset #{'is-hidden' if @props.section.get('type') is 'fullscreen'}"
            dangerouslySetInnerHTML: __html: $(icons()).filter('.draggable').html()
          }
          button {
            className: "edit-section-remove button-reset #{'is-hidden' if @props.section.get('type') is 'fullscreen'}"
            onClick: @removeSection
            dangerouslySetInnerHTML: __html: $(icons()).filter('.remove').html()
          }
        (switch @props.section.get('type')
          when 'text' then SectionText
          when 'video' then SectionVideo
          when 'slideshow' then SectionSlideshow
          when 'embed' then SectionEmbed
          when 'fullscreen' then SectionFullscreen
          when 'callout' then SectionCallout
          when 'toc' then SectionToc
          when 'image_set' then SectionImageSet
          when 'image_collection' then SectionImageCollection
          when 'image' then SectionImage
        )(
          section: @props.section
          editing: @props.editing
          ref: 'section'
          onClick: @setEditing(on)
          setEditing: @setEditing
        )
        div {
          className: 'edit-section-container-bg'
          onClick: @onClickOff
        }
      (
        if @props.section.get('type') is 'fullscreen'
          div { className: 'edit-section-container-block' }
      )
      if @state.dropPosition is 'bottom'
        @printDropPlaceholder()

