module.exports = (argString) ->
  """
  {
    articles(#{argString}){
      thumbnail_image
      thumbnail_title
      slug
      published_at
      scheduled_publish_at
      id
      channel_id
      partner_channel_id
    }
  }
  """
