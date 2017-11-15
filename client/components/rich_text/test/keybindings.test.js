import {
  keyBindingFnCaption,
  keyBindingFnFull
} from '../utils/keybindings.js'

jest.unmock('draft-js')
const Draft = require.requireActual('draft-js')

describe('Keybindings', () => {
  describe('#keyBindingFnCaption', () => {
    let e
    Draft.getDefaultKeyBinding = jest.fn()
    Draft.KeyBindingUtil.hasCommandModifier = jest.fn()

    it('Returns the name of a recognized key binding if command modifier', () => {
      Draft.KeyBindingUtil.hasCommandModifier.mockReturnValueOnce(true)
      e = { keyCode: 75 }
      expect(keyBindingFnCaption(e)).toBe('link-prompt')
      expect(Draft.getDefaultKeyBinding.mock.calls.length).toBe(0)
    })

    it('Returns the default key binding if no command modifier', () => {
      Draft.KeyBindingUtil.hasCommandModifier.mockReturnValueOnce(false)
      e = { keyCode: 75 }
      keyBindingFnCaption(e)
      expect(Draft.getDefaultKeyBinding.mock.calls.length).toBe(1)
    })

    it('Returns the default binding if no setting specified', () => {
      Draft.KeyBindingUtil.hasCommandModifier.mockReturnValueOnce(true)
      e = { keyCode: 45 }
      keyBindingFnCaption(e)
      expect(Draft.getDefaultKeyBinding.mock.calls.length).toBe(1)
    })
  })

  describe('#keyBindingFnFull', () => {
    let e
    Draft.KeyBindingUtil.hasCommandModifier = jest.fn().mockReturnValue(true)

    it('Returns the name of a recognized key binding', () => {
      Draft.getDefaultKeyBinding = jest.fn()

      e = { keyCode: 49 }
      expect(keyBindingFnFull(e)).toBe('header-one')

      e.keyCode = 50
      expect(keyBindingFnFull(e)).toBe('header-two')

      e.keyCode = 51
      expect(keyBindingFnFull(e)).toBe('header-three')

      e.keyCode = 191
      expect(keyBindingFnFull(e)).toBe('custom-clear')

      e.keyCode = 55
      expect(keyBindingFnFull(e)).toBe('ordered-list-item')

      e.keyCode = 56
      expect(keyBindingFnFull(e)).toBe('unordered-list-item')

      e.keyCode = 75
      expect(keyBindingFnFull(e)).toBe('link-prompt')

      e.keyCode = 219
      expect(keyBindingFnFull(e)).toBe('blockquote')

      e.keyCode = 88
      e.shiftKey = true
      expect(keyBindingFnFull(e)).toBe('strikethrough')
      expect(Draft.getDefaultKeyBinding.mock.calls.length).toBe(0)
    })

    it('Returns the keyboard event of left or right arrow keys', () => {
      Draft.KeyBindingUtil.hasCommandModifier = jest.fn().mockReturnValue(false)

      e = { keyCode: 37 }
      expect(keyBindingFnFull(e).keyCode).toBe(37)

      e.keyCode = 38
      expect(keyBindingFnFull(e).keyCode).toBe(38)
      expect(Draft.getDefaultKeyBinding.mock.calls.length).toBe(0)
    })

    it('Returns the default key binding if no command modifier', () => {
      e = { keyCode: 75 }
      keyBindingFnFull(e)
      expect(Draft.getDefaultKeyBinding.mock.calls.length).toBe(1)
    })

    it('Returns the default binding if no setting specified', () => {
      Draft.KeyBindingUtil.hasCommandModifier.mockReturnValueOnce(true)
      e = { keyCode: 45 }
      keyBindingFnFull(e)
      expect(Draft.getDefaultKeyBinding.mock.calls.length).toBe(1)
    })
  })
})
