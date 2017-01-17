rewire = require 'rewire'
routes = rewire '../routes'
_ = require 'underscore'
sinon = require 'sinon'
fixtures = require '../../../../test/helpers/fixtures'
User = require '../../../models/user'

describe 'routes', ->

  beforeEach ->
    routes.__set__ 'Lokka', sinon.stub().returns(
      query: sinon.stub().returns
        then: sinon.stub().yields({ articles: [fixtures().articles] }).returns
          catch: sinon.stub().yields()
    )
    @req = { query: {}, user: new User(fixtures().users), params: {} }
    @res = { render: sinon.stub(), locals: fixtures().locals }
    @next = sinon.stub()

  describe '#articles_list', ->

    it 'fetches articles', ->
      routes.articles_list @req, @res, @next
      @res.locals.sd.ARTICLES.length.should.equal 1

    it 'sends arguments to the template', ->
      routes.articles_list @req, @res, @next
      @res.render.args[0][0].should.equal 'index'
      @res.render.args[0][1].published.should.be.true()
      @res.render.args[0][1].current_channel.name.should.equal 'Editorial'
