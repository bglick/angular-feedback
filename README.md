Angular Feedback
================

Angular Feedback is a simple ajax feedback widget wrapped in an angular.js directive.

The widget collects user feedback in a comment box and sends an HTTP POST to the server with the comment content.  Immediately upon submitting the POST, the widget shows the `thanks-text` value.  The widget is "fire and forget".  It does not implement any callbacks from the server.

The widget resets its content after each submit, so user's can continue to submit feedback as they move through your app.

_It's up to you to write a server side handler for the feedback._  See the Server Side note below for information on the JSON you'll need to consume.

## Usage

### Javascript
``` javascript
var app = angular.module('myAppName',['$feedback.directives']);

```

### HTML
Download either file from the `/dist` folder in this project and include it with your other javascript.

``` html
<!-- include your normal angular stuff -->
<script src='/path/to/angular-feedback.min.js'></script>
<feedback-widget url='/myfeedbackurl' thanks-text='Thanks so much!' />

```
The `thanks-text` attribute is optional. The default text is "Thanks for your feedback!"


### Server Side

When the user clicks the submit button, the widget will make a post to the address provided in the `url` attribute. 

Assuming the end user entered "hello world" into the comment box, the post's JSON payload will be
``` json
{"feedback":{"comment":"hello world"}}
```

### Styling
The HTML template used by the directive looks like this:

``` html
    <div ng-show='viewMode=="lg"' class='form-group'>
      <label class='lbl-feedback-comment' for='feedbackComment'>Comment:</label>
      <textarea class='form-control txt-feedback-comment' ng-model='feedback.comment' id='feedbackComment'/>
      <button class='btn-feedback-submit btn btn-sm btn-primary' ng-disabled='!feedback.comment.length>0'>Submit</button>
      <button class='btn-feedback-cancel btn btn-sm' ng-click='viewMode="sm"'>Cancel</button>
    </div>
    <div class='div-feedback-toggle-off text-right'>
      <div class='div-feedback-thanks-text' ng-show='thanksMsg==true'>{{thanksText}}</div>
      <button ng-click='viewMode="lg";thanksMsg=false' ng-show='viewMode=="sm"' class='btn btn-sm btn-feedback-toggle'>Feedback</button>
    </div>
```

Extra classes have been added to assist you with any additional styling.

* `btn-feedback-toggle`: The initial feedback button that the user sees
* `lbl-feedback-comment`: The "Comment:" label for the text area
* `txt-feedback-comment`: The comment textarea
* `btn-feedback-submit`: The submit button
* `btn-feedback-cancel`: The cancel button that closes the widget
* `div-feedback-thanks-text`: The thank you message text that is shown after the user click's submit

### Server Side Sample (Rails)
``` ruby
class FeedbacksController < ApplicationController
  def create
    #load the comment (verbose way just to illustrate where the data is coming from)
    f = Feedback.new(comment:params[:feedback][:comment]) 
    
    #load some extra stuff from the request for more info
    f.user_agent = request.headers['HTTP_USER_AGENT']
    f.referer = request.headers['HTTP_REFERER']
    f.user = current_user
    
    
    begin
      f.save!
    rescue
      #don't bubble errors up to users since the widget isn't looking for the error
      ExceptionNotifier.notify_exception($!)
    end

    #you can render any response you want since the client isn't listening anymore
    render json: {'ok'=>'ok'}
  end
end

```

### Pro Tip

If you're using this directive in multiple spots within your app, wrap it in your own custom directive so you can encapsulate your settings and extra formatting.

``` coffee
@myapp.directive 'myFeedback', () ->
  {
    replace:true
    restrict:'E'
    template:"
      <div class='my-extra-formatting-wrapper'>
        <feedback-widget url='/my_feedback_url' thanks-text='Thanks!' />
      </div>"
  }

```
``` html
<my-feedback />
```

## Contributing

Pull requests are always welcome.
