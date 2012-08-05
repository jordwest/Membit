
window.Reviews =
  Models: {}
  Collections: {}
  Views: {}
  Templates: {}
  App: {}

debugOutput = false

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
   your internet connection then press Reconnect<br/><br/>If you're still having trouble, try refreshing this page.</div>
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
window.Reviews.App.ReviewHistory = new window.Reviews.Collections.Reviews()

window.Reviews.App.UserWords = new window.Reviews.Collections.UserWords()

window.Reviews.Views.Card = Backbone.View.extend({
  id: "card-review"
  events:
    "click .answer-button": "answer_event"
    "click .reveal-button": "reveal"
    "click .reconnect-button": "reconnect"
  commsInProgress: false
  showingSide: "none"
  startTime: null
  reveal: ->
    this.render_back()
  answer_event: (evt) ->
    this.answer(evt.target.value)
  answer: (answer_number) ->
    endTime = new Date().getTime()
    timeDiff = (endTime - this.startTime) / 1000

    review = window.Reviews.App.Reviews.add({
      user_word_id: this.model.get('id')
      answer: answer_number
      time_to_answer_in_seconds: timeDiff
      sending: false
      last_review: this.model.get('last_review')
    })
    window.Reviews.App.ReviewHistory.add(review.toJSON())
    if(debugOutput)
      console.log review.toJSON()
      console.log "Answered ID "+this.model.get('id')
    # Need to set this in the actual collection - the collection may have been reset in the meantime
    _(window.Reviews.App.UserWords.where({id: this.model.id})).first().set('reviewed', true)
    this.selectCard()
    this.sendWaiting()
  sendWaiting: ->
    if(window.Reviews.App.Reviews.length < 1)
      return
    if(debugOutput)
      console.log "Sending waiting reviews:"
      console.log window.Reviews.App.Reviews.toJSON()
    if(this.commsInProgress == true)
      if(debugOutput)
        console.log "Can't send, comms in progress"
      this.userWaiting = true
      this.render_loading()
    else
      this.commsInProgress = true
      view = this
      if(debugOutput)
        console.log "Performing request"
      $.ajax({
        data: {reviews: JSON.stringify(window.Reviews.App.Reviews.toJSON())}
        cache: false
        dataType: 'json'
        url: 'review.json'
        type: 'POST'
        success: (data, textStatus, jqXHR) ->
          if(debugOutput)
            console.log "Request successful"
          view.commsInProgress = false
          window.Reviews.App.SendingReviews.reset([])

          # Load the new words
          window.Reviews.App.UserWords.reset(data.cards)
          window.Reviews.App.Stats.set(data.stats)
        
          # Make sure current word is in the set
          if(view.model != null && window.Reviews.App.UserWords.where({id: view.model.id}).length < 1)
            console.log "Switched cards"
            view.selectCard()

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
    availableCards = window.Reviews.App.UserWords.filter (uw) ->
      return (window.Reviews.App.ReviewHistory.where({
        user_word_id: uw.get('id')
        last_review: uw.get('last_review')
      }).length == 0)
    if availableCards.length < 1
      this.model = null
      this.render_finished()
      if(debugOutput)
        console.log "Cards finished"
    else
      this.model = _(availableCards).first()
      if(debugOutput)
        console.log "Selected card ID="+this.model.id
      this.render_front()
  render_error: ->
    this.showingSide = "none";
    this.$el.html(window.Reviews.Templates.Error())
  render_loading: ->
    this.showingSide = "none";
    this.$el.html(window.Reviews.Templates.Loading())
  render_front: ->
    if(this.model == null)
      this.render_finished()
      return
    this.showingSide = "front";
    this.$el.html(window.Reviews.Templates.CardFront(this.model.toJSON()))
    $("#inline-help-card-front").show()
    $("#inline-help-card-back").hide()
  render_back: ->
    if(this.model == null)
      this.render_finished()
      return
    this.showingSide = "back";
    this.$el.html(window.Reviews.Templates.CardBack(this.model.toJSON()))
    this.$el.find('p.reading').rubyann()
    $("#inline-help-card-front").hide()
    $("#inline-help-card-back").show()
    this.startTime = new Date().getTime()
  render_finished: ->
    this.showingSide = "none";
    this.$el.html(window.Reviews.Templates.Finished())
    $("#inline-help-card-front").hide()
    $("#inline-help-card-back").hide()
})

window.Reviews.App.CardView = new window.Reviews.Views.Card({
  model: window.Reviews.App.UserWords.first()
  el: "#card-review"
})

$(document).on "keydown", (evt) ->
  #console.log evt.keyCode
  if (48 <= evt.keyCode <= 53)
    if window.Reviews.App.CardView.showingSide == "back"
      window.Reviews.App.CardView.answer(evt.keyCode - 48)
  if (96 <= evt.keyCode <= 101)
    if window.Reviews.App.CardView.showingSide == "back"
      window.Reviews.App.CardView.answer(evt.keyCode - 96)
  if (evt.keyCode == 70)
    if window.Reviews.App.CardView.showingSide == "front"
      window.Reviews.App.CardView.render_back()

window.Reviews.Models.Stats = Backbone.Model.extend({})
window.Reviews.Views.Stats = Backbone.View.extend({
  initialize: ->
    this.model.on 'change', this.render, this
  template: _.template("
  <h3>Today's Study</h3>
  <table class='table'>
    <tbody>
      <tr>
        <td>Due for review:</td>
        <td><%= remaining_due + remaining_failed %></td>
      </tr>
      <tr>
        <td>New words:</td>
        <td><%= remaining_new %></td>
      </tr>
      <tr class='total'>
        <td>Total remaining today:</td>
        <td><%= total_remaining %></td>
      </tr>
      <tr>
        <td colspan=2><div class='progress progress-striped'>
          <div class='bar' style='width: <%= (1-(total_remaining/total_reviews_today))*100 %>%;'>
            <%= total_reviews_today-total_remaining %> of <%= total_reviews_today %> words
          </div>
        </div></td>
      </tr>
      </tbody>
  </table>
        ")
  render: ->
    this.$el.html(this.template(this.model.toJSON()))
})

window.Reviews.App.Stats = new window.Reviews.Models.Stats()
window.Reviews.App.StatsView = new window.Reviews.Views.Stats({
  el: ".review-stats"
  model: window.Reviews.App.Stats
})

# Init stuff

if(typeof cardsInit != 'undefined')
  window.Reviews.App.UserWords.reset(cardsInit.cards)
  window.Reviews.App.Stats.set(cardsInit.stats)

window.Reviews.App.CardView.selectCard()