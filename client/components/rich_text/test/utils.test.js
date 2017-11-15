import {
  stripGoogleStyles
} from '../utils/index.js'

describe('Utils', () => {
  describe('#stripGoogleStyles', () => {
    let googleHtmlShort
    let googleHtmlLong

    beforeEach(() => {
      googleHtmlShort = '<p>hello</p><br><p>here again.</p><br class="Apple-interchange-newline">'
      googleHtmlLong = '<b style="font-weight:normal;" id="docs-internal-guid-ce2bb19a-cddb-9e53-cb18-18e71847df4e"><p><span style="font-size:11pt;color:#000000;background-color:transparent;font-weight:400;font-style:normal;font-variant:normal;text-decoration:none;vertical-align:baseline;white-space:pre-wrap;">Available at: Espacio Valverde • Galleries Sector, Booth 9F01</span></p>'
    })

    it('Removes non-breaking spaces between paragraphs', () => {
      expect(stripGoogleStyles(googleHtmlShort)).toBe('<p>hello</p><p>here again.</p>')
    })

    it('Removes dummy b tags google wraps the document in', () => {
      expect(stripGoogleStyles(googleHtmlLong)).toBe(
        '<p><span style="font-size:11pt;color:#000000;background-color:transparent;font-weight:400;font-style:normal;font-variant:normal;text-decoration:none;vertical-align:baseline;white-space:pre-wrap;">Available at: Espacio Valverde • Galleries Sector, Booth 9F01</span></p>'
      )
    })

    it('Replaces bold spans with <strong> tags', () => {
      googleHtmlLong = googleHtmlLong.replace('400', '700')
      expect(stripGoogleStyles(googleHtmlLong)).toBe(
        '<p><span><strong>Available at: Espacio Valverde • Galleries Sector, Booth 9F01</strong></span></p>'
      )
    })

    it('Replaces italic spans with <em> tags', () => {
      googleHtmlLong = googleHtmlLong.replace('font-style:normal', 'font-style:italic')
      expect(stripGoogleStyles(googleHtmlLong)).toBe(
        '<p><span><em>Available at: Espacio Valverde • Galleries Sector, Booth 9F01</em></span></p>'
      )
    })

    it('Replaces spans that are bold and italic', () => {
      googleHtmlLong = googleHtmlLong
        .replace('font-style:normal', 'font-style:italic')
        .replace('font-weight:400', 'font-weight:700')
      expect(stripGoogleStyles(googleHtmlLong)).toBe(
        '<p><span><strong><em>Available at: Espacio Valverde • Galleries Sector, Booth 9F01</em></strong></span></p>'
      )
    })
  })
})
