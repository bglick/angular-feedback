angular.module('$feedback.directives',[]).directive('feedbackWidget',['$http',($http) ->
  {
    restrict: 'E'
    scope: {
      url: '@'
      thanksText: '@'
      }
    link: (scope,element,attrs,controller) ->
      scope.feedback = {}
      scope.viewMode = 'sm'
      scope.$watch('viewMode',(newValue,oldValue) ->
        element.find('textarea.txt-feedback-comment').focus() if newValue == 'lg'
      )
      scope.submitMe = ->
        comment = scope.feedback.comment
        $http.post(scope.url,{feedback: {comment: comment}})
        scope.feedback.comment = ''
        scope.thanksText = 'Thanks for your feedback!' if scope.thanksText==undefined || scope.thanksText.length==0
        scope.thanksMsg = true
        scope.viewMode = 'sm'

    template: "
    <div ng-show='viewMode==\"lg\"' class='form-group'>
      <label class='lbl-feedback-comment' for='feedbackComment'>Comment:</label>
      <textarea class='form-control txt-feedback-comment' ng-model='feedback.comment' id='feedbackComment'/>
      <button class='btn-feedback-submit btn btn-sm btn-primary' ng-disabled='!feedback.comment.length>0' ng-click='submitMe()'>Submit</button>
      <button class='btn-feedback-cancel btn btn-sm' ng-click='viewMode=\"sm\"'>Cancel</button>
    </div>
    <div class='div-feedback-toggle-off text-right'>
      <div class='div-feedback-thanks-text' ng-show='thanksMsg==true'>{{thanksText}}</div>
      <button ng-click='viewMode=\"lg\";thanksMsg=false' ng-show='viewMode==\"sm\"' class='btn btn-sm btn-feedback-toggle'>Feedback</button>
    </div>"
    }
])
