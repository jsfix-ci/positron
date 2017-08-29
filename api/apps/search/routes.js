import search from '../../lib/elasticsearch.coffee'
import { matchAll } from './queries'

// GET /api/search
const index = (req, res, next) => {
  search.client.search({
    body: {
      query: matchAll(req.query.term)
    }},
    (error, response) => {
      if (error) {
        return console.log(`nothing matched for: ${req.query.term}`)
      }
      return res.send(response.hits)
    }
  )
}

export default index
