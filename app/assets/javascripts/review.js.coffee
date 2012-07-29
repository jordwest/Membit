
window.Reviews =
  Models: {}
  Collections: {}
  Views: {}
  Templates: {}
  App: {}

window.Reviews.Templates.CardFront =
  _.template("
      <p class='prompt'>Recall the reading and meaning of the word:</p>
      <p class='expression'><%= word.expression %></p>
      <hr/>
      <div class='center'>
        <button class='btn btn-primary reveal-button'>Show Answer</button>
      </div>")

window.Reviews.Templates.CardBack =
  _.template("<p class='reading'><%= word.reading %></p>
        <hr/>
        <p class='meaning'><%= word.meaning %></p>
        <hr/>
        <p class='prompt'>Rate your answer:</p>
        <div class='buttons'>

          <div class='span1 offset1'>
            <button class='btn btn-danger answer-0 answer-button' value='0'>0</button>
          </div>

          <div class='span1'>
            <button class='btn btn-danger answer-1 answer-button' value='1'>1</button>
          </div>

          <div class='span1'>
            <button class='btn btn-danger answer-2 answer-button' value='2'>2</button>
          </div>
          <div class='span1'>
            <button class='btn answer-3 answer-button' value='3'>3</button>
          </div>
          <div class='span1'>
            <button class='btn answer-4 answer-button' value='4'>4</button>
          </div>
          <div class='span1'>
            <button class='btn btn-success answer-5 answer-button' value='5'>5</button>
          </div>
        </div>")

window.Reviews.Templates.Loading =
  _.template("<div class='loading'>Loading next card...</div>")

window.Reviews.Templates.Error =
  _.template("<div class='error'>Couldn't talk to the server. Please check
   your internet connection then press Reconnect</div>
   <div class='center'><button class='btn btn-primary reconnect-button'>Reconnect</button> </div>")

window.Reviews.Templates.Finished =
  _.template("<div class='finished'><h1>Congratulations</h1><p>You have finished your reviews for today. Check back tomorrow for more reviews.</p></div>
     ")

window.Reviews.Models.UserWord = Backbone.Model.extend({})
window.Reviews.Models.Review = Backbone.Model.extend({})

window.Reviews.Collections.UserWords = Backbone.Collection.extend({
  model: window.Reviews.Models.UserWord
})

window.Reviews.Collections.Reviews = Backbone.Collection.extend({
  model: window.Reviews.Models.Review
})

window.Reviews.App.Reviews = new window.Reviews.Collections.Reviews()
window.Reviews.App.SendingReviews = new window.Reviews.Collections.Reviews()

window.Reviews.App.UserWords = new window.Reviews.Collections.UserWords()
window.Reviews.App.UserWords.reset(cardsInit)

window.Reviews.Views.Card = Backbone.View.extend({
  id: "card-review"
  events:
    "click .answer-button": "answer"
    "click .reveal-button": "reveal"
    "click .reconnect-button": "reconnect"
  commsInProgress: false
  reveal: ->
    this.render_back()
  answer: (evt) ->
    window.Reviews.App.Reviews.add({
      user_word_id: this.model.get('id')
      answer: evt.target.value
      time_to_answer_in_seconds: 1
      sending: false
    })
    # Need to set this in the actual collection - the collection may have been reset in the meantime
    _(window.Reviews.App.UserWords.where({id: this.model.id})).first().set('reviewed', true)
    this.selectCard()
    this.sendWaiting()
  sendWaiting: ->
    if(window.Reviews.App.Reviews.length < 1)
      return
    if(this.commsInProgress == true)
      this.userWaiting = true
      this.render_loading()
    else
      this.commsInProgress = true
      view = this
      $.ajax({
        data: {reviews: JSON.stringify(window.Reviews.App.Reviews.toJSON())}
        cache: false
        dataType: 'json'
        url: 'review.json'
        type: 'POST'
        success: (data, textStatus, jqXHR) ->
          view.commsInProgress = false
          window.Reviews.App.SendingReviews.reset([])

          # Load the new words
          window.Reviews.App.UserWords.reset(data)
          console.log "Updated words with data from server"
          if(view.userWaiting == true)
            view.userWaiting = false
            view.render_front()
            view.sendWaiting()
        error: ->
          view.commsInProgress = false
          window.Reviews.App.SendingReviews.each (o) ->
            window.Reviews.App.Reviews.add(o.toJSON())
          window.Reviews.App.SendingReviews.reset([])
          view.render_error()
      })
      window.Reviews.App.Reviews.each (o) ->
        window.Reviews.App.SendingReviews.add(o.toJSON())
      window.Reviews.App.Reviews.reset([])
  reconnect: ->
    this.render_loading()
    this.userWaiting = true
    this.sendWaiting()
  selectCard: ->
    console.log "Loading new word"
    console.log window.Reviews.App.UserWords.where({reviewed: false}).length
    if window.Reviews.App.UserWords.where({reviewed: false}).length < 1
      this.model = null
      this.render_finished()
    else
      this.model = _(window.Reviews.App.UserWords.where({reviewed: false})).first()
      this.render_front()
  render_error: ->
    this.$el.html(window.Reviews.Templates.Error())
  render_loading: ->
    this.$el.html(window.Reviews.Templates.Loading())
  render_front: ->
    this.$el.html(window.Reviews.Templates.CardFront(this.model.toJSON()))
  render_back: ->
    this.$el.html(window.Reviews.Templates.CardBack(this.model.toJSON()))
    this.$el.find('p.reading').rubyann()
  render_finished: ->
    this.$el.html(window.Reviews.Templates.Finished())
})

window.Reviews.App.CardView = new window.Reviews.Views.Card({
  model: window.Reviews.App.UserWords.first()
  el: "#card-review"
})

window.Reviews.App.CardView.selectCard()