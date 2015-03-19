(function() {
  describe('feedbackWidget', function() {
    var $httpBackend, elem, scope;
    elem = scope = $httpBackend = null;
    beforeEach(function() {
      module('$feedback.directives');
      return inject(function($injector) {
        var $compile, $rootScope, compiled, html;
        $rootScope = $injector.get('$rootScope');
        $httpBackend = $injector.get('$httpBackend');
        $compile = $injector.get('$compile');
        $httpBackend.when('POST', '/x').respond({
          ok: 'ok'
        });
        scope = $rootScope.$new();
        html = '<feedback-widget url="/x" thanksText="y" />';
        elem = angular.element(html);
        compiled = $compile(elem)(scope);
        return scope.$digest();
      });
    });
    it("should set html", function() {
      return expect(elem.html()).toMatch(/btn-feedback-submit/);
    });
    it("should change viewMode on click", function() {
      var formGroupScope;
      formGroupScope = elem.find('.form-group').scope();
      expect(formGroupScope.viewMode).toEqual('sm');
      $(elem).find('button.btn-feedback-toggle').click();
      return expect(formGroupScope.viewMode).toEqual('lg');
    });
    it("should post on click", function() {
      var formGroupScope;
      $httpBackend.expectPOST('/x', '{"feedback":{"comment":"mycomment"}}');
      formGroupScope = elem.find('.form-group').scope();
      formGroupScope.url = '/x';
      formGroupScope.feedback.comment = 'mycomment';
      return $(elem).find('button.btn-feedback-submit').click();
    });
    return it("should show thank you message after click", function() {
      var formGroupScope;
      formGroupScope = elem.find('.form-group').scope();
      formGroupScope.url = '/x';
      $(elem).find('button.btn-feedback-submit').click();
      return expect(formGroupScope.thanksMsg).toBe(true);
    });
  });

}).call(this);
