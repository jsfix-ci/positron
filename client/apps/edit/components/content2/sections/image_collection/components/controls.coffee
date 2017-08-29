React = require 'react'
_ = require 'underscore'
sd = require('sharify').data
gemup = require 'gemup'
SectionControls = React.createFactory require '../../../section_controls/index.coffee'
UrlArtworkInput = React.createFactory require './url_artwork_input.coffee'
Autocomplete = require '../../../../../../../components/autocomplete/index.coffee'
Artwork = require '../../../../../../../models/artwork.coffee'
{ div, section, h1, h2, span, header, input, a, nav } = React.DOM

module.exports = React.createClass
  displayName: 'ImageCollectionControls'

  componentDidMount: ->
    @setupAutocomplete()

  componentWillUnmount: ->
    @autocomplete.remove()

  addArtworkFromUrl: (newImages) ->
    @props.section.set images: newImages
    @props.onChange()

  setupAutocomplete: ->
    $el = $(@refs.autocomplete)
    @autocomplete = new Autocomplete
      url: "#{sd.ARTSY_URL}/api/search?q=%QUERY"
      el: $el
      filter: (res) ->
        vals = []
        for r in res._embedded.results
          if r.type?.toLowerCase() == 'artwork'
            id = r._links.self.href.substr(r._links.self.href.lastIndexOf('/') + 1)
            vals.push
              id: id
              value: r.title
              thumbnail: r._links.thumbnail?.href
        return vals
      templates:
        suggestion: (data) ->
          """
            <div class='autocomplete-suggestion' \
               style='background-image: url(#{data.thumbnail})'>
            </div>
            #{data.value}
          """
      selected: @onSelect
    _.defer -> $el.focus()

  onSelect: (e, selected) ->
    new Artwork(id: selected.id).fetch
      success: (artwork) =>
        newImages = @props.images.concat [artwork.denormalized()]
        @props.section.set images: newImages
        $(@refs.autocomplete).val('').focus()
        @props.onChange()

  upload: (e) ->
    gemup e.target.files[0],
      app: sd.GEMINI_APP
      key: sd.GEMINI_KEY
      progress: (percent) =>
        @props.setProgress percent
      add: (src) =>
        @props.setProgress 0.1
      done: (src) =>
        image = new Image
        image.src = src
        image.onload = =>
          newImages = @props.images.concat [{
            url: src
            type: 'image'
            width: image.width
            height: image.height
          }]
          @props.section.set images: newImages
          @props.setProgress null

  render: ->
    SectionControls {
      section: @props.section
      channel: @props.channel
      articleLayout: @props.article.get('layout')
      onChange: @props.onChange
      sectionLayouts: true
    },
      section { className: 'dashed-file-upload-container' },
        h1 {}, 'Drag & ',
          span { className: 'dashed-file-upload-container-drop' }, 'drop'
          ' or '
          span { className: 'dashed-file-upload-container-click' }, 'click'
          span {}, ' to upload'
        h2 {}, 'Up to 30mb'
        input { type: 'file', onChange: @upload }

      section { className: 'edit-controls__artwork-inputs' },
        div { className: 'edit-controls__autocomplete-input' },
          input {
            ref: 'autocomplete'
            className: 'bordered-input bordered-input-dark'
            placeholder: 'Search for artwork by title'
          }
        UrlArtworkInput {
          images: @props.images
          addArtworkFromUrl: @addArtworkFromUrl
        }